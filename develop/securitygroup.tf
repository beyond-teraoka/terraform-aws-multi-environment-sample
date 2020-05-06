####################
# Security Group
####################
resource "aws_security_group" "alb" {
  name        = "alb-dev-sg"
  description = "for ALB"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "alb-dev-sg"
    Environment = "dev"
  }
}

resource "aws_security_group" "ec2" {
  name        = "ec2-dev-sg"
  description = "for ec2"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "ec2-dev-sg"
    Environment = "dev"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-dev-sg"
  description = "for RDS"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "rds-dev-sg"
    Environment = "dev"
  }
}

#####################
# Security Group Rule
#####################
resource "aws_security_group_rule" "allow_http_for_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_http_for_alb"
}

resource "aws_security_group_rule" "from_alb_to_ec2" {
  security_group_id        = aws_security_group.ec2.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb.id
  description              = "from_alb_to_ec2"
}

resource "aws_security_group_rule" "from_bastion_to_ec2" {
  security_group_id        = aws_security_group.ec2.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 22
  to_port                  = 22
  source_security_group_id = data.terraform_remote_state.mng.outputs.seucirty_group_bastion_id
  description              = "from_bastion_to_ec2"
}

resource "aws_security_group_rule" "from_ec2_to_rds" {
  security_group_id        = aws_security_group.rds.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3306
  to_port                  = 3306
  source_security_group_id = aws_security_group.ec2.id
  description              = "from_ec2_to_rds"
}

resource "aws_security_group_rule" "egress_alb" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

resource "aws_security_group_rule" "egress_ec2" {
  security_group_id = aws_security_group.ec2.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}

resource "aws_security_group_rule" "egress_rds" {
  security_group_id = aws_security_group.rds.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "Outbound ALL"
}
