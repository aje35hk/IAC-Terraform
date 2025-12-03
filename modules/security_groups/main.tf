# Main Security Group Resource
resource "aws_security_group" "sg" {
  name        = var.name
  description = "${var.name} security group"
  vpc_id      = var.vpc_id

  # Dynamic Ingress for Custom Ports
  dynamic "ingress" {
    for_each = var.ingress_ports
    content {
      description = "Allow custom port ${ingress.value}"
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.ingress_cidrs
      security_groups = var.ingress_security_groups
    }
  }

  # Allow all outbound traffic
  egress {
    # description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.egress_cidrs
    security_groups = var.egress_security_groups
  }

  tags = {
    Name = "${var.name}-sg"
  }
}