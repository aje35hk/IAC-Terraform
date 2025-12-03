variable "cidr_block" {
  description = "cidr block"
  type        = string
}

variable "igw" {
  type = bool
  description = "Create Internet gateway"
}

variable "project" {
  description = "Project name"
  type        = string
}

variable "subnet_cidrs_private" {
  type        = list(string)
  description = "private subnet cidrs"
}

variable "subnet_cidrs_public" {
  type        = list(string)
  description = "public subnet cidrs"
}

variable "availability_zone" {
  type        = list(string)
  description = "AZ common for public and private subnets"
}
variable "ngw" {
  type        = bool
  description = "Create NAT gateway"
  default     = true
  
}