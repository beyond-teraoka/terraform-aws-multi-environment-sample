####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-terraformer-dev"
    Environment = "dev"
  }
}

####################
# Subnet
####################
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-public-1a"
    Environment = "dev"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-public-1c"
    Environment = "dev"
  }
}

resource "aws_subnet" "dmz_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.1.3.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-dmz-1a"
    Environment = "dev"
  }
}

resource "aws_subnet" "dmz_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.1.4.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-dmz-1c"
    Environment = "dev"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.1.5.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-private-1a"
    Environment = "dev"
  }
}

resource "aws_subnet" "private_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.1.6.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-dev-private-1c"
    Environment = "dev"
  }
}

####################
# Route Table
####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-dev-public"
    Environment = "dev"
  }
}

resource "aws_route_table" "dmz" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-dev-dmz"
    Environment = "dev"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-dev-private"
    Environment = "dev"
  }
}

####################
# IGW
####################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-terraformer-dev"
    Environment = "dev"
  }
}

####################
# NATGW
####################
resource "aws_eip" "natgw" {
  vpc = true

  tags = {
    Name        = "natgw-terraformer-dev"
    Environment = "dev"
  }
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.natgw.id
  subnet_id     = aws_subnet.public_1a.id

  tags = {
    Name        = "natgw-terraformer-dev"
    Environment = "dev"
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
