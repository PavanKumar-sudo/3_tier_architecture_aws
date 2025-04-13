resource "aws_db_subnet_group" "this" {
  name       = var.db_subnet_group_name
  subnet_ids = var.subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = var.db_subnet_group_name
    }
  )
}

resource "aws_db_instance" "this" {
  identifier              = var.db_identifier
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  allocated_storage       = var.allocated_storage
  db_name                 = var.db_name
  username                = var.username
  password                = var.password
  db_subnet_group_name    = aws_db_subnet_group.this.name
  vpc_security_group_ids  = [var.security_group_id]

  skip_final_snapshot     = true # No snapshot on destroy (for learning/demo)
  publicly_accessible     = false # Must be false for private DB

  tags = merge(
    var.common_tags,
    {
      Name = var.db_identifier
    }
  )
}
