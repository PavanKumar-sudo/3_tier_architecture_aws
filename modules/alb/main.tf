resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.web_sg_id]
  subnets            = var.public_subnet_ids

  tags = var.common_tags
}

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
  health_check {
    path                = var.health_check_path
    protocol            = var.health_check_protocol
    interval            = var.health_check_interval
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = var.common_tags
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}