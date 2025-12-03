variable "name" {
  description = "The name of the load balancer. This name must be unique within your AWS account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  type        = string

}

variable "vpc_id" {
  description = "The VPC ID to create the load balancer in."
  type        = string
}

variable "target_port" {
  type = number
}


variable "protocol" {
  type = string
}

variable "target_type" {
  type = string
  
}

variable "health_check" {
  type = object({
    healthy_threshold   = number
    unhealthy_threshold = number
    timeout             = number
    interval            = number
    path                = string
    matcher             = string
    protocol            = string
  })
}