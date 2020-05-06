####################
# Parameter Group
####################
resource "aws_db_parameter_group" "rds" {
  name        = "terraformer-prod-pg"
  family      = "mysql5.7"
  description = "for RDS"

  tags = {
    Environment = "prod"
  }
}

####################
# Subnet Group
####################
resource "aws_db_subnet_group" "rds" {
  name        = "terraformer-prod-sg"
  description = "for RDS"
  subnet_ids = [
    aws_subnet.private_1a.id,
    aws_subnet.private_1c.id
  ]

  tags = {
    Environment = "prod"
  }
}

####################
# Instance
####################
resource "aws_db_instance" "rds" {
  identifier                = "terraformer-prod-db01"
  engine                    = "mysql"
  engine_version            = "5.7"
  instance_class            = "db.t3.micro"
  storage_type              = "gp2"
  allocated_storage         = "50"
  max_allocated_storage     = "100"
  username                  = "root"
  password                  = "password"
  final_snapshot_identifier = "terraformer-prod-db01-final"
  db_subnet_group_name      = aws_db_subnet_group.rds.name
  parameter_group_name      = aws_db_parameter_group.rds.name
  multi_az                  = false
  vpc_security_group_ids = [
    aws_security_group.rds.id
  ]
  backup_retention_period = "7"
  apply_immediately       = true

  tags = {
    Environment = "prod"
  }
}
