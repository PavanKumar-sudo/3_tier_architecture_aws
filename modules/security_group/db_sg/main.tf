resource "aws_security_group" "this" {
  name        = var.db_sg_name
  description = "Security group for Database Servers (Private Subnet)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow DB Traffic from App SG"
    from_port   = var.db_port
    to_port     = var.db_port
    protocol    = "tcp"
    security_groups = [var.app_sg_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.common_tags,
    {
      Name = var.db_sg_name
    }
  )
}
