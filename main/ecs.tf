resource "aws_ecs_cluster" "test_cluster" {
  name = var.project
  
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "test_cluster_capacity_providers" {
  cluster_name = aws_ecs_cluster.test_cluster.name

  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  default_capacity_provider_strategy {
    base              = 0
    weight            = 1
    capacity_provider = var.capacity_provider
  }
}

module "ecs" {
  source            = "../modules/ecs"
  ecs_cluster_id    = aws_ecs_cluster.test_cluster.id

  ########service########
  subnet_ids        = module.vpc.private_subnet_ids
  security_group_id = module.sg-ecs.security_group_id

  #### task definitions ####
  task_definitions = [
    {
      family                      = "${var.project}-task"
      network_mode                = "awsvpc"
      requires_compatibilities    = ["FARGATE"]
      cpu                         = var.cpu
      memory                      = var.memory
      runtimePlatform = {
        cpuArchitecture       = "X86_64"
        operatingSystemFamily = "LINUX"
      }
      ecs_execution_role_arn      = aws_iam_role.test_container_execution_role.arn
      ecs_task_execution_role_arn = aws_iam_role.test_container_execution_role.arn
      container_definitions       = local.container_definitions_content
      
      #### service ####
      desired_count = var.desired_count
      capacity_provider_strategy = [
        {
          base              = 0
          weight            = 1
          capacity_provider = var.capacity_provider
        }
      ]
      load_balancer = [
        {
          target_group_arn = module.test-tg.target_group_arn
          container_name   = "test"
          container_port   = var.container_port
        }
      ]
    }
  ]
  
  depends_on = [module.test-tg]
}

locals {
  container_definitions_content = templatefile("${path.module}/../container-definitions/test_container_def.json", {
    container_image = var.container_image
    container_port  = var.container_port
    aws_region      = var.aws_region
  })
}
