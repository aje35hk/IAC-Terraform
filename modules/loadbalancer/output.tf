output "load_balancer_arn" {
  description = "The ARN of the load balancer."
  value       = aws_lb.alb.arn
}

output "load_balancer_dns_name" {
  description = "The DNS name of the load balancer."
  value       = aws_lb.alb.dns_name
}

# output "target_group_arn" {
#   description = "The ARN of the target group."
#   value       = aws_lb_target_group.tg.arn  
# }