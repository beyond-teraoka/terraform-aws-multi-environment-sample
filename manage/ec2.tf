####################
# Bastion Instance
####################
resource "aws_key_pair" "common" {
  key_name   = "terraformer-common-key"
  public_key = file("./keys/id_rsa.pub")
}

resource "aws_eip" "bastion" {
  vpc      = true
  instance = aws_instance.bastion.id

  tags = {
    Name = "terraformer-bastion"
  }
}

resource "aws_instance" "bastion" {
  ami           = "ami-0f310fced6141e627"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_1c.id
  key_name      = aws_key_pair.common.key_name
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  tags = {
    Name        = "terraformer-bastion"
    Environment = "mng"
  }

  volume_tags = {
    Name        = "terraformer-bastion"
    Environment = "mng"
  }
}
