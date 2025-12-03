resource "aws_lb_target_group" "tg" {
  name     = var.name
  port     = var.target_port
  protocol = var.protocol
  vpc_id   = var.vpc_id
  target_type = var.target_type
  deregistration_delay = "60"
  health_check {
    healthy_threshold   = var.health_check.healthy_threshold
    unhealthy_threshold = var.health_check.unhealthy_threshold
    timeout             = var.health_check.timeout
    interval            = var.health_check.interval
    path                = var.health_check.path
    matcher             = var.health_check.matcher
    protocol            = var.health_check.protocol
  }
}