variable "aws_region" {
  description = "AWS Region for deployment"
  type        = string
  default     = "ap-south-1"
}

variable "project" {
  description = "Project name used for resource naming"
  type        = string
  default     = "test-container"
}

variable "container_image" {
  description = "Docker image for the test container (e.g., nginx:latest or ECR repository URL)"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of container tasks to run"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "CPU units for the task (256 = 0.25 vCPU, 512 = 0.5 vCPU, 1024 = 1 vCPU)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for the task in MB"
  type        = string
  default     = "512"
}

variable "health_check_path" {
  description = "Health check endpoint path"
  type        = string
  default     = "/"
}

variable "capacity_provider" {
  description = "ECS capacity provider (FARGATE or FARGATE_SPOT)"
  type        = string
  default     = "FARGATE"
}
