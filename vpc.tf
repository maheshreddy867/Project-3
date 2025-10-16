## create VPC

resource "aws_vpc" "mahesh-vpc" {
  cidr_block = "10.0.0.0/16"  
    tags = {
        name = "Mahesh-vpc"
    }
  
}

## crate public-subnets-1

resource "aws_subnet" "mahesh-subnet-1" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Mahesh-vpc-subnet-1"
  }
}

## crate public-subnets-2

resource "aws_subnet" "mahesh-subnet-2" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "Mahesh-vpc-subnet-2"
  }
}

## crate private-subnets-3

resource "aws_subnet" "mahesh-subnet-3" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.3.0/24"

  tags = {
    Name = "Mahesh-vpc-subnet-3"
  }
}

## crate private-subnets-4

resource "aws_subnet" "mahesh-subnet-4" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.4.0/24"

  tags = {
    Name = "Mahesh-vpc-subnet-4"
  }
}

## crate private-subnets-5

resource "aws_subnet" "mahesh-subnet-5" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.5.0/24"
  availability_zone               = "us-east-1e"

  tags = {
    Name = "Mahesh-vpc-subnet-5"
  }
}

## crate private-subnets-6

resource "aws_subnet" "mahesh-subnet-6" {
  vpc_id     = aws_vpc.mahesh-vpc.id
  cidr_block = "10.0.6.0/24"
   availability_zone       = "us-east-1d"
  tags = {
    Name = "Mahesh-vpc-subnet-6"
  }
}

## create internet gateway
 
resource "aws_internet_gateway" "mahesh-igw" {
  vpc_id = aws_vpc.mahesh-vpc.id

  tags = {
    Name = "Mahesh-IGW"
  }
}

## create routetables -public

resource "aws_route_table" "mahesh-rt-1" {
  vpc_id = aws_vpc.mahesh-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.mahesh-igw.id
  }
}

resource "aws_route_table" "mahesh-rt-2" {
  vpc_id = aws_vpc.mahesh-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.mahesh-nat.id
  }
}

## create natgate way

resource "aws_nat_gateway" "mahesh-nat" {
  allocation_id = aws_eip.mahesh-eip.id
  subnet_id     = aws_subnet.mahesh-subnet-3.id

  tags = {
    Name = "Mahesh-NAT"
  }
}

## create routetable association

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.mahesh-subnet-1.id
  route_table_id = aws_route_table.mahesh-rt-1.id
}

resource "aws_route_table_association" "b" {
  subnet_id      = aws_subnet.mahesh-subnet-2.id
  route_table_id = aws_route_table.mahesh-rt-1.id
}

resource "aws_route_table_association" "c" {
  subnet_id      = aws_subnet.mahesh-subnet-3.id
  route_table_id = aws_route_table.mahesh-rt-2.id
}

resource "aws_route_table_association" "d" {
  subnet_id      = aws_subnet.mahesh-subnet-4.id
  route_table_id = aws_route_table.mahesh-rt-2.id
}

resource "aws_route_table_association" "e" {
  subnet_id      = aws_subnet.mahesh-subnet-5.id
  route_table_id = aws_route_table.mahesh-rt-2.id
}

resource "aws_route_table_association" "f" {
  subnet_id      = aws_subnet.mahesh-subnet-6.id
  route_table_id = aws_route_table.mahesh-rt-2.id
}

## create elastic IP

resource "aws_eip" "mahesh-eip" {
  
  domain   = "vpc"   
  tags  = {
    name = "mahesh-EIP"
  }
}

# creating Security Group

resource "aws_security_group" "mahesh-sg" {
  name        = "Mahesh-sg"
  description = "Allow SSH and HTTP and SQL and HTTPS"
  vpc_id      = aws_vpc.mahesh-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Mahesh-sg"
  }
}



