module "loadbalancer" {
  source                     = "../modules/loadbalancer"
  name                       = var.project
  subnet_ids                 = module.vpc.public_subnet_ids
  security_group_ids         = [module.sg-lb.security_group_id]
  enable_deletion_protection = false

  tags = {
    Environment = "test"
    Project     = var.project
  }

  vpc_id = module.vpc.vpc_id
}

##########Default Listener##########
resource "aws_lb_listener" "http" {
  load_balancer_arn = module.loadbalancer.load_balancer_arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = module.test-tg.target_group_arn
  }
}

# Uncomment and configure if you need HTTPS
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = module.loadbalancer.load_balancer_arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-2016-08"
#   certificate_arn   = "arn:aws:acm:REGION:ACCOUNT:certificate/CERTIFICATE_ID"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = module.test-tg.target_group_arn
#   }
# }

##### Target Group #########
module "test-tg" {
  source      = "../modules/loadbalancer/target-group"
  name        = "${var.project}-tg"
  vpc_id      = module.vpc.vpc_id
  target_port = var.container_port
  protocol    = "HTTP"
  target_type = "ip"
  
  health_check = {
    healthy_threshold   = 3
    unhealthy_threshold = 3
    timeout             = 5
    interval            = 30
    path                = var.health_check_path
    matcher             = "200-299"
    protocol            = "HTTP"
  }
}
