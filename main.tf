resource "aws_vpc" "cloud" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "cloud-vpc"
  }
}
locals {
  vpc_id = aws_vpc.cloud.id
}
resource "aws_subnet" "public_subnet" {
  count = var.subnet_public_count
  vpc_id                  = local.vpc_id
  cidr_block              = cidrsubnet(aws_vpc.cloud.cidr_block,8,count.index)
  availability_zone       = data.aws_availability_zones.available.names[(count.index % length(data.aws_availability_zones.available.names))]
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnet" {
  count = var.subnet_private_count
  vpc_id                  = local.vpc_id
  cidr_block              = cidrsubnet(aws_vpc.cloud.cidr_block,8,count.index+var.subnet_private_count)
  availability_zone       = data.aws_availability_zones.available.names[(count.index % length(data.aws_availability_zones.available.names))]
  map_public_ip_on_launch = true

  tags = {
    Name = "private-subnet-${count.index}"
  }
}

resource "aws_internet_gateway" "cloud_gateway" {
  vpc_id = local.vpc_id

  tags = {
    Name = "cloud-gateway"
  }
}
resource "aws_route_table" "public_route_table" {
  vpc_id = local.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.cloud_gateway.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = local.vpc_id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count = var.subnet_private_count
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_subnet_association" {
  count = var.subnet_private_count
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}