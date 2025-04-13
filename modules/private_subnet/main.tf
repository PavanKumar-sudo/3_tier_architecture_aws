resource "aws_subnet" "private_subnet_1" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr_1
  availability_zone = var.availability_zone_1

  tags = merge(
    var.common_tags,
    {
      Name = var.private_subnet_1_name
    }
  )
}

resource "aws_subnet" "private_subnet_2" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnet_cidr_2
  availability_zone = var.availability_zone_2

  tags = merge(
    var.common_tags,
    {
      Name = var.private_subnet_2_name
    }
  )
}
