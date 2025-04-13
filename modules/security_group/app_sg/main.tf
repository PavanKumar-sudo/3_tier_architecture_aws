resource "aws_security_group" "this" {
  name        = var.app_sg_name
  description = "Security group for App Servers (Private Subnet)"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow App Traffic from Web SG"
    from_port   = var.app_port
    to_port     = var.app_port
    protocol    = "tcp"
    security_groups = [var.web_sg_id]
  }

  ingress {
    description = "Allow SSH access from Web SG"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [var.web_sg_id]
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
      Name = var.app_sg_name
    }
  )
}
