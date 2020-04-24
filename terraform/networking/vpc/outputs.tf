output "vpc" {
  value = aws_vpc.vpc
}

output "public_subnets" {
  value = aws_subnet.aws_subnet_public
}

output "private_subnets" {
  value = aws_subnet.aws_subnet_private
}