variable "project" {
  description = "project name"
  type = string
}

variable "name" {
  description = "security group name"
  type = string  
}

variable "ingress_ports" {
  description = "ingress ports"
  type = list(number)
  # default = [ 443 ]
}
variable "ingress_cidrs" {
  description = "ingress cidr"
  type = list(string)
  default = []
}

variable "egress_cidrs" {
  description = "egress cidrs"
  type = list(string)
  default = []  
}

# variable "custom_ports" {
#   description = "custom tcp ports"
#   type = list(number)  
# }

variable "vpc_id" {
  type =  string 
}

variable "ingress_security_groups" {
  description = "List of security group IDs to allow in ingress rules"
  type        = list(string)
  default     = []
}

variable "egress_security_groups" {
  description = "List of security group IDs to allow in egress rules"
  type        = list(string)
  default     = []
}