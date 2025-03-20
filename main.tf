provider "aws" {
  region = var.region
}

# -----------------------
# VPC
# -----------------------
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
}

# -----------------------
# Public Subnets (2 AZs)
# -----------------------
resource "aws_subnet" "public_az1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az1
  map_public_ip_on_launch = true
  availability_zone        = var.az1
}

resource "aws_subnet" "public_az2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr_az2
  map_public_ip_on_launch = true
  availability_zone        = var.az2
}

# -----------------------
# Private Subnets (2 AZs)
# -----------------------
resource "aws_subnet" "private_az1" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.private_subnet_cidr_az1
  availability_zone = var.az1
}

resource "aws_subnet" "private_az2" {
  vpc_id           = aws_vpc.main.id
  cidr_block       = var.private_subnet_cidr_az2
  availability_zone = var.az2
}

# -----------------------
# Internet Gateway (For Public Subnets)
# -----------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# -----------------------
# Public Route Table
# -----------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_default_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "public_assoc_az1" {
  subnet_id      = aws_subnet.public_az1.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_assoc_az2" {
  subnet_id      = aws_subnet.public_az2.id
  route_table_id = aws_route_table.public_rt.id
}

# -----------------------
# NAT Gateway (For Private Subnets)
# -----------------------
resource "aws_eip" "nat_eip" {}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_az1.id
}

# -----------------------
# Private Route Table
# -----------------------
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route_table_association" "private_assoc_az1" {
  subnet_id      = aws_subnet.private_az1.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_assoc_az2" {
  subnet_id      = aws_subnet.private_az2.id
  route_table_id = aws_route_table.private_rt.id
}

# -----------------------
# Security Groups
# -----------------------
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }
}

# -----------------------
# Load Balancer
# -----------------------
resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.public_az1.id, aws_subnet.public_az2.id]
}

# -----------------------
# Launch Template
# -----------------------
resource "aws_launch_template" "lt" {
  name_prefix   = "asg-template"
  image_id      = "ami-04b4f1a9cf54c11d0" # Replace with the latest AMI ID
  instance_type = var.instance_type
  key_name      = var.key_name
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
}

# -----------------------
# Auto Scaling Group
# -----------------------
resource "aws_autoscaling_group" "asg" {
  desired_capacity     = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = [aws_subnet.private_az1.id, aws_subnet.private_az2.id]

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }
}
