variable "ecs_cluster_id" {
  description = "The ID of the ECS cluster"
  type        = string
  
}

variable "enable_load_balancer" {
  description = "Enable load balancer"
  type        = bool
  default     = false  
}

variable "subnet_ids" {
  description = "The subnet IDs to launch the ECS service into"
  type        = list(string)
}

variable "security_group_id" {
  description = "The security group ID to launch the ECS service into"
  type        = string
}


variable "capacity_providers" {
  description = "List of capacity providers for the ECS cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}


variable "task_definitions" {
  description = "List of ECS task definitions"
  type = list(object({
    family                   = string
    network_mode             = string
    requires_compatibilities = list(string)
    cpu                      = string
    memory                   = string
    container_definitions    = string
    desired_count            = number
    ecs_execution_role_arn = string
    ecs_task_execution_role_arn = string
    runtimePlatform = object({
      cpuArchitecture       = string
      operatingSystemFamily = string
    })
    capacity_provider_strategy = list(object({
      base              = number
      weight            = number
      capacity_provider = string
    }))
    load_balancer = list(object({
      target_group_arn = string
      container_port   = number
      container_name   = string
    }))
  }))
}
