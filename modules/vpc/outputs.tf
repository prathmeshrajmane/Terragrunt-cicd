output "vpc-id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc.id
}

output "public_subnets_id" {
  value = aws_subnet.public-subnet.*.id
}

output "private_subnets_id" {
  value = aws_subnet.private-subnet.*.id
}

output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.internet-gateway.id
}

output "ngw_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat-gateway.id
}

output "public_route_table_id" {
  description = "The ID of public route table"
  value       = aws_route_table.public-rt.id
}

output "private_route_table_id" {
  description = "The ID of Private route table"
  value       = aws_route_table.private-rt.id
}

output "security_group_id" {
  description = "The ID of security group"
  value       = aws_security_group.security-group.id
}
