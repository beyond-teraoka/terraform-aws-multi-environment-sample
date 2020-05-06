####################
# Security Group
####################
resource "aws_security_group" "ec2" {
  name        = "ec2-mng-sg"
  description = "for ec2"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name        = "ec2-mng-sg"
    Environment = "mng"
  }
}

#####################
# Security Group Rule
#####################
resource "aws_security_group_rule" "allow_ssh_all" {
  security_group_id = aws_security_group.ec2.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 22
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  description       = "allow_ssh_all"
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
