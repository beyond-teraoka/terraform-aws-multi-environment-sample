####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-terraformer-prod"
    Environment = "prod"
  }
}

####################
# Subnet
####################
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.2.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-public-1a"
    Environment = "prod"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.2.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-public-1c"
    Environment = "prod"
  }
}

resource "aws_subnet" "dmz_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.2.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-dmz-1a"
    Environment = "prod"
  }
}

resource "aws_subnet" "dmz_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.2.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-dmz-1c"
    Environment = "prod"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.2.5.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-private-1a"
    Environment = "prod"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.2.6.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-prod-private-1c"
    Environment = "prod"
  }
}

####################
# Route Table
####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-prod-public"
    Environment = "prod"
  }
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-prod-dmz"
    Environment = "prod"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-prod-private"
    Environment = "prod"
  }
}

####################
# IGW
####################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-terraformer-prod"
    Environment = "prod"
  }
}

####################
# NATGW
####################
resource "aws_eip" "natgw" {
  vpc = true

  tags = {
    Name        = "natgw-terraformer-prod"
    Environment = "prod"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name        = "natgw-terraformer-prod"
    Environment = "prod"
  }

  depends_on = [aws_internet_gateway.igw]
}

####################
# Route
####################
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_route_table.public]
}

resource "aws_route" "dmz" {
  route_table_id         = aws_route_table.dmz.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.natgw.id
  depends_on             = [aws_route_table.dmz]
}

####################
# Route Association
####################
resource "aws_route_table_association" "public_1a" {
  subnet_id      = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id      = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "dmz_1a" {
  subnet_id      = aws_subnet.dmz_1a.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "dmz_1c" {
  subnet_id      = aws_subnet.dmz_1c.id
  route_table_id = aws_route_table.dmz.id
}

resource "aws_route_table_association" "private_1a" {
  subnet_id      = aws_subnet.private_1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_1c" {
  subnet_id      = aws_subnet.private_1c.id
  route_table_id = aws_route_table.private.id
}
