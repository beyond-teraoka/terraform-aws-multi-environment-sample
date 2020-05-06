output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

output "route_table_public_id" {
  value = aws_route_table.public.id
}

output "route_table_dmz_id" {
  value = aws_route_table.dmz.id
}

output "route_table_private_id" {
  value = aws_route_table.private.id
}
