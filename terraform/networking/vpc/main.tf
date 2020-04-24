resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = var.vpc_name,
  }
}

# Public Subnet #

resource "aws_subnet" "aws_subnet_public" {
  count = 2

  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "public-subnet-${count.index + 1}",
    vpc  = var.vpc_name,
  }
}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "internet-gateway",
    vpc  = var.vpc_name,
  }
}

# Private Subnet #
resource "aws_subnet" "aws_subnet_private" {
  count = 2

  availability_zone       = data.aws_availability_zones.az.names[count.index]
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index+2)
  map_public_ip_on_launch = false
  vpc_id                  = aws_vpc.vpc.id

  tags = {
    Name = "private-subnet-${count.index + 1}",
    vpc  = var.vpc_name,
  }
}

resource "aws_eip" "aws_eip" {}

resource "aws_nat_gateway" "aws_nat_gateway" {

  allocation_id = aws_eip.aws_eip.id
  subnet_id = aws_subnet.aws_subnet_public.0.id

  tags = {
    Name = "nat-gateway",
    vpc  = var.vpc_name,
  }
}

# Routing #

## Public Route ##
resource "aws_route_table" "aws_route_table_public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "public-route-table",
    vpc  = var.vpc_name,
  }
}

resource "aws_main_route_table_association" "aws_main_route_table_association" {
  route_table_id = aws_route_table.aws_route_table_public.id
  vpc_id         = aws_vpc.vpc.id
}

resource "aws_route" "aws_route_public" {
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.aws_internet_gateway.id
  route_table_id         = aws_route_table.aws_route_table_public.id
}

resource "aws_route_table_association" "aws_route_table_association_public" {
  count = 2

  route_table_id = aws_route_table.aws_route_table_public.id
  subnet_id      = aws_subnet.aws_subnet_public[count.index].id
}

## Private Route ##
resource "aws_route_table" "aws_route_table_private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "private-route-table",
    vpc  = var.vpc_name,
  }
}

resource "aws_route" "aws_route_private" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.aws_nat_gateway.id
  route_table_id         = aws_route_table.aws_route_table_private.id
}

resource "aws_route_table_association" "aws_route_table_association_private" {
  count = 2

  route_table_id = aws_route_table.aws_route_table_private.id
  subnet_id      = aws_subnet.aws_subnet_private[count.index].id
}
