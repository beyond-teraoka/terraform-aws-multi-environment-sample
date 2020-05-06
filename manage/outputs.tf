output "key_pair_name" {
  value = aws_key_pair.common.key_name
}

output "seucirty_group_bastion_id" {
  value = aws_security_group.ec2.id
}
