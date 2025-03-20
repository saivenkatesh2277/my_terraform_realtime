output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_az1_id" {
  description = "The ID of the public subnet in AZ1"
  value       = aws_subnet.public_az1.id
}

output "public_subnet_az2_id" {
  description = "The ID of the public subnet in AZ2"
  value       = aws_subnet.public_az2.id
}

output "private_subnet_az1_id" {
  description = "The ID of the private subnet in AZ1"
  value       = aws_subnet.private_az1.id
}

output "private_subnet_az2_id" {
  description = "The ID of the private subnet in AZ2"
  value       = aws_subnet.private_az2.id
}

output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.alb.dns_name
}

output "asg_name" {
  description = "Auto Scaling Group Name"
  value       = aws_autoscaling_group.asg.name
}
