locals {
  dmz_subnet_ids = [
    aws_subnet.dmz_1a.id,
    aws_subnet.dmz_1c.id
  ]
}

resource "aws_instance" "web" {
  count         = 1
  ami           = "ami-04560ec17deca7cc2"
  instance_type = "t3.micro"
  subnet_id     = element(local.dmz_subnet_ids, count.index)
  key_name      = data.terraform_remote_state.mng.outputs.key_pair_name
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }

  vpc_security_group_ids = [
    aws_security_group.ec2.id
  ]

  tags = {
    Name        = format("terraformer-prod-web%02d", count.index + 1)
    Environment = "prod"
  }

  volume_tags = {
    Name        = format("terraformer-prod-web%02d", count.index + 1)
    Environment = "prod"
  }
}
