resource "aws_eip" "this" {
  domain = "vpc"

  tags = merge(
    var.common_tags,
    {
      Name = var.eip_name
    }
  )
}
