resource "aws_nat_gateway" "this" {
  allocation_id = var.eip_allocation_id
  subnet_id     = var.public_subnet_id

  tags = merge(
    var.common_tags,
    {
      Name = var.nat_gateway_name
    }
  )
}
