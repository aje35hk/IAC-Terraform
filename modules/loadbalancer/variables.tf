variable "name" {
  description = "The name of the load balancer. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  type        = string

}

variable "vpc_id" {
  description = "The VPC ID to create the load balancer in."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs to attach to the LB."
  type        = list(string)

}

variable "security_group_ids" {
  description = "The security group ID to assign to the LB."
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "If true, deletion of the load balancer will be disabled via the AWS API."
  type        = bool
  default     = false
}

# variable "access_logs" {
#   description = "An access logs block."
#   type        = object({
#     bucket  = string
#     prefix  = string
#     enabled = bool
#   })
# }

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}
