####################
# VPC
####################
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "vpc-terraformer-mng"
    Environment = "mng"
  }
}

####################
# Subnet
####################
resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}a"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-mng-public-1a"
    Environment = "mng"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = "${var.region}c"
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "subnet-terraformer-mng-public-1c"
    Environment = "mng"
  }
}

####################
# Route Table
####################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "route-terraformer-mng-public"
    Environment = "mng"
  }
}

####################
# IGW
####################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name        = "igw-terraformer-mng"
    Environment = "mng"
  }
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

####################
# VPC Peering
####################
resource "aws_vpc_peering_connection" "dev" {
  peer_vpc_id = data.terraform_remote_state.dev.outputs.vpc_id
  vpc_id      = aws_vpc.vpc.id
  auto_accept = "true"

  tags = {
    Name        = "peer-terraformer-mng-dev"
    Environment = "mng"
  }
}

resource "aws_vpc_peering_connection" "prod" {
  peer_vpc_id = data.terraform_remote_state.prod.outputs.vpc_id
  vpc_id      = aws_vpc.vpc.id
  auto_accept = "true"

  tags = {
    Name        = "peer-terraformer-mng-prod"
    Environment = "mng"
  }
}

####################
# VPC Peering Route
####################
resource "aws_route" "public_mng_to_dev" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.terraform_remote_state.dev.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dev.id
}

resource "aws_route" "public_mng_to_prod" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.terraform_remote_state.prod.outputs.vpc_cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.prod.id
}

resource "aws_route" "public_dev_to_mng" {
  route_table_id            = data.terraform_remote_state.dev.outputs.route_table_public_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dev.id
}

resource "aws_route" "dmz_dev_to_mng" {
  route_table_id            = data.terraform_remote_state.dev.outputs.route_table_dmz_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dev.id
}

resource "aws_route" "private_dev_to_mng" {
  route_table_id            = data.terraform_remote_state.dev.outputs.route_table_private_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.dev.id
}

resource "aws_route" "public_prod_to_mng" {
  route_table_id            = data.terraform_remote_state.prod.outputs.route_table_public_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.prod.id
}

resource "aws_route" "dmz_prod_to_mng" {
  route_table_id            = data.terraform_remote_state.prod.outputs.route_table_dmz_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.prod.id
}

resource "aws_route" "private_prod_to_mng" {
  route_table_id            = data.terraform_remote_state.prod.outputs.route_table_private_id
  destination_cidr_block    = aws_vpc.vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.prod.id
}
