# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.public_route_table_name
    }
  )
}

# Private Route Table
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.private_route_table_name
    }
  )
}

# Associate Public Subnet 1
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = var.public_subnet_id_1
  route_table_id = aws_route_table.public.id
}

# Associate Public Subnet 2
resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = var.public_subnet_id_2
  route_table_id = aws_route_table.public.id
}

# Associate Private Subnet 1
resource "aws_route_table_association" "private_subnet_1" {
  subnet_id      = var.private_subnet_id_1
  route_table_id = aws_route_table.private.id
}

# Associate Private Subnet 2
resource "aws_route_table_association" "private_subnet_2" {
  subnet_id      = var.private_subnet_id_2
  route_table_id = aws_route_table.private.id
}
