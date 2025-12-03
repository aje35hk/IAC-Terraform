#### task definitions

resource "aws_ecs_task_definition" "ecs_task" {
  for_each                 = { for task in var.task_definitions : task.family => task }
  family                   = each.value.family
  network_mode             = each.value.network_mode
  requires_compatibilities = each.value.requires_compatibilities
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  container_definitions    = each.value.container_definitions
  execution_role_arn       = each.value.ecs_execution_role_arn
  task_role_arn            = each.value.ecs_task_execution_role_arn
  runtime_platform {
    cpu_architecture       = each.value.runtimePlatform.cpuArchitecture
    operating_system_family = each.value.runtimePlatform.operatingSystemFamily
  }
}

#### services

resource "aws_ecs_service" "ecs_service" {
  for_each = aws_ecs_task_definition.ecs_task

  name            = each.key
  task_definition = each.value.arn

  cluster         = var.ecs_cluster_id

  
  desired_count   = var.task_definitions[index(var.task_definitions[*].family, each.key)].desired_count
  
  
  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.security_group_id]
    assign_public_ip = true
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.task_definitions[index(var.task_definitions[*].family, each.key)].capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  # lifecycle {
  #   ignore_changes = [task_definition]
  # }

  dynamic "load_balancer" {
    for_each = var.task_definitions[index(var.task_definitions[*].family, each.key)].load_balancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }
  depends_on = [ aws_ecs_task_definition.ecs_task ]
}
