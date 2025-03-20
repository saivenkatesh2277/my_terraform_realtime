# AWS Region
variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# VPC
variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

# Public Subnets
variable "public_subnet_cidr_az1" {
  description = "Public Subnet CIDR in AZ1"
  type        = string
}

variable "public_subnet_cidr_az2" {
  description = "Public Subnet CIDR in AZ2"
  type        = string
}

# Private Subnets
variable "private_subnet_cidr_az1" {
  description = "Private Subnet CIDR in AZ1"
  type        = string
}

variable "private_subnet_cidr_az2" {
  description = "Private Subnet CIDR in AZ2"
  type        = string
}

# Availability Zones
variable "az1" {
  description = "First Availability Zone"
  type        = string
}

variable "az2" {
  description = "Second Availability Zone"
  type        = string
}

# EC2 Configuration
variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key pair for EC2 instance"
  type        = string
}

# Auto Scaling Group
variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}
