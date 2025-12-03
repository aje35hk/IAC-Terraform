output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = module.loadbalancer.load_balancer_dns_name
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = module.loadbalancer.load_balancer_arn
}

output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.test_cluster.name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.test_cluster.arn
}

output "container_image" {
  description = "Docker image being used"
  value       = var.container_image
}

output "access_url" {
  description = "URL to access the test container"
  value       = "http://${module.loadbalancer.load_balancer_dns_name}"
}
