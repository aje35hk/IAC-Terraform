variable "listener_arn" {
  description = "ARN of the load balancer listener"
  type        = string  
}
variable "priority" {
  description = "Priority of the listener rule"
  type        = number
}
variable "tg_arn" {
  description = "ARN of the target group to forward traffic to"
  type        = string
}
variable "host" {
  description = "Host header value to match for the listener rule"
  type        = list(string)
}
variable "name" {
  description = "Name of the listener rule"
  type        = string  
}