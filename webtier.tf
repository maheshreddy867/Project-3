resource "aws_instance" "mahesh-ec2-1" {
  ami                             = "ami-08982f1c5bf93d976"
  instance_type                   = "t2.micro"
  subnet_id                       = aws_subnet.mahesh-subnet-1.id
  key_name                        = "vcube"
  user_data                       = file("apache2.sh")
  vpc_security_group_ids          = [aws_security_group.mahesh-sg.id]
  associate_public_ip_address     = true

  tags = {
    Name = "Mahesh-1"
  }
}

resource "aws_instance" "mahesh-ec2-2" {
  ami                             = "ami-08982f1c5bf93d976"
  instance_type                   = "t2.micro"
  subnet_id                       = aws_subnet.mahesh-subnet-2.id
  key_name                        = "vcube"
  user_data                       = file("apache2.sh")
  vpc_security_group_ids          = [aws_security_group.mahesh-sg.id]
  associate_public_ip_address     = true

  tags = {
    Name = "Mahesh-2"
  }
}

## create Target Group

resource "aws_lb_target_group" "mahesh-tg-1" {
  name     = "public-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mahesh-vpc.id
}


resource "aws_lb_target_group" "mahesh-tg-2" {
  name     = "private-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.mahesh-vpc.id
}

## target group attachement

resource "aws_lb_target_group_attachment" "tg-attach-1" {
  target_group_arn = aws_lb_target_group.mahesh-tg-1.arn
  target_id        = aws_instance.mahesh-ec2-1.id
  port             = 80
}


resource "aws_lb_target_group_attachment" "tg-attach-2" {
  target_group_arn = aws_lb_target_group.mahesh-tg-2.arn
  target_id        = aws_instance.mahesh-ec2-2.id
  port             = 80
}

## create load balancer

resource "aws_lb" "mahesh-lb-1" {
  name               = "Mahesh-lb-1"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.mahesh-sg.id]
  subnets            = [for subnet in [aws_subnet.mahesh-subnet-1,aws_subnet.mahesh-subnet-2]:subnet.id]
}

## create AMi

resource "aws_ami_from_instance" "mahesh-ami-20250926-213500" {
  name               = "Mahesh-AMI--2025"
  source_instance_id = aws_instance.mahesh-ec2-1.id
}

resource "aws_placement_group" "mahesh-auto1-1" {
  name     = "mahesh-auto-1"
  strategy = "cluster"  # or "spread" / "partition" based on your needs
}

## launch instance from AMI

# Launch instance from the fetched AMI

resource "aws_instance" "mahesh-Ami-1" {
  ami           ="ami-08982f1c5bf93d976"
  instance_type = "t2.micro"
}

## launch tempate

resource "aws_launch_template" "mahesh-temp-1" {
  name_prefix   = "lt-from-instance-1"
  image_id      = aws_ami_from_instance.mahesh-ami-20250926-213500.id
  instance_type = "t2.micro"  # Choose as required
}

## create auto scalilng group

resource "aws_autoscaling_group" "mahesh-autoscaling-app" {
  name                      = "mahesh-asg"
  max_size                  = 3
  min_size                  = 1
  desired_capacity          = 2
  vpc_zone_identifier       = [aws_subnet.mahesh-subnet-1.id, aws_subnet.mahesh-subnet-2.id]

  
  launch_template {
    id      = aws_launch_template.mahesh-temp.id
    version = "$Latest"
  }

  health_check_type         = "EC2"
  termination_policies      = ["OldestInstance"]
}