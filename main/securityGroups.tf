module "sg-lb" {
  source        = "../modules/security_groups"
  project       = var.project
  name          = "${var.project}-lb"
  vpc_id        = module.vpc.vpc_id
  ingress_ports = [80, 443]
  ingress_cidrs = ["0.0.0.0/0"]
  egress_cidrs  = ["0.0.0.0/0"]
  ingress_security_groups = []
  egress_security_groups  = []
}

module "sg-ecs" {
  source        = "../modules/security_groups"
  project       = var.project
  name          = "${var.project}-ecs"
  vpc_id        = module.vpc.vpc_id
  ingress_ports = [var.container_port]
  ingress_cidrs = []
  egress_cidrs  = ["0.0.0.0/0"]
  ingress_security_groups = [module.sg-lb.security_group_id]
  egress_security_groups  = []
  
  depends_on = [module.sg-lb]
}
