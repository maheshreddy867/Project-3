
## # creating Subnet groups in rds

resource "aws_db_subnet_group" "mahesh-rds" {
  name       = "subnetgroups"
  subnet_ids = [aws_subnet.mahesh-subnet-5.id, aws_subnet.mahesh-subnet-6.id]

  tags = {
    Name = "MAHESH_RDS"
  }
}

## create RDS

resource "aws_db_instance" "maheshdb01" {
  allocated_storage    = 10
  db_name              = "Maheshdb"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "Maheshreddy3285"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true

tags   = {
    Name = "Maheshreddy-DB"
}
}