output "vpc_id" {
  value = aws_vpc.main_vpc.id 
  description = "ID of the main vpc created by this module"
}

output "public_subnet_ids" {
  value = aws_subnet.main_public_subnet[*].id 
  description = "IDs of the public subnet in the VPC"
}

output "private_subnet_ids" {
    value = aws_subnet.main_private_subnet[*].id 
    description = "IDs of the private subnet in the VPC"
}