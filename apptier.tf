resource "aws_instance" "mahesh-ec2-3" {
  ami                             = "ami-08982f1c5bf93d976"
  instance_type                   = "t2.micro"
  subnet_id                       = aws_subnet.mahesh-subnet-3.id
  key_name                        = "vcube"
  user_data                       = file("apache2.sh")
  vpc_security_group_ids          = [aws_security_group.mahesh-sg.id]
  associate_public_ip_address     = true

  tags = {
    Name = "Mahesh-3"
  }
}

resource "aws_instance" "mahesh-ec2-4" {
  ami                             = "ami-08982f1c5bf93d976"
  instance_type                   = "t2.micro"
  subnet_id                     = aws_subnet.mahesh-subnet-4.id
  key_name                        = "vcube"
  user_data                       = file("apache2.sh")
  vpc_security_group_ids          = [aws_security_group.mahesh-sg.id]
  associate_public_ip_address     = true

  tags = {
    Name = "Mahesh-4"
  }
}

## create load balancer

resource "aws_lb" "mahesh-lb-2" {
  name               = "Mahesh-lb-2"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mahesh-sg.id]
  subnets            = [for subnet in [aws_subnet.mahesh-subnet-3,aws_subnet.mahesh-subnet-4]:subnet.id]
}

## create AMI

resource "aws_ami_from_instance" "mahesh-ami-2024" {
  name               = "Mahesh-AMI-2024"
  source_instance_id = aws_instance.mahesh-ec2-3.id
}

resource "aws_placement_group" "mahesh-auto1" {
  name     = "mahesh-auto-1-new"
  strategy = "cluster"  # or "spread" / "partition" based on your needs
}

## launch instance from AMI

# Launch instance from the fetched AMI

resource "aws_instance" "mahesh-Ami" {
  ami           ="ami-08982f1c5bf93d976"
  instance_type = "t2.micro"
}

## launch tempate

resource "aws_launch_template" "mahesh-temp" {
  name_prefix   = "lt-from-instance-1"
  image_id      = aws_ami_from_instance.mahesh-ami-2024.id
  instance_type = "t2.micro"  # Choose as required
}

# Launch instance from the fetched AMI
resource "aws_instance" "apptier_ec2-1" {
  ami           ="ami-08982f1c5bf93d976"
  instance_type = "t2.micro"
}


## create auto scalilng group

resource "aws_autoscaling_group" "mahesh-autoscaling" {
  name                      = "mahesh-auto"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.mahesh-subnet-3.id, aws_subnet.mahesh-subnet-4.id]

  
  launch_template {
    id      = aws_launch_template.mahesh-temp.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  termination_policies      = ["OldestInstance"]
}