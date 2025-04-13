resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = merge(
    var.common_tags,
    {
      Name = var.vpc_name
    }
  )
}
