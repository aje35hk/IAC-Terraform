
resource "aws_lb_listener_rule" "https" {
  listener_arn = var.listener_arn
  priority     = var.priority

  action {
    type             = "forward"
    target_group_arn = var.tg_arn
  }

  condition {
    host_header {
      values = var.host
    }
  }
  tags = {
    Name = var.name
  }
}