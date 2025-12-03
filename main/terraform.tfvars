# Terraform Variables Configuration
# Copy this file to terraform.tfvars and customize as needed

# AWS Region
aws_region = "ap-south-1"

# Project name (used for resource naming)
project = "test-container"

# Docker image for the test container
# Examples:
#   - "nginx:latest" (public Docker Hub image)
#   - "232026663825.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest" (ECR image)
container_image = "app:latest"

# Container port
container_port = 8000

# Number of tasks to run
desired_count = 1

# Task resources
cpu    = "256"  # 0.25 vCPU
memory = "512"  # 512 MB

# Health check path
health_check_path = "/"

# Capacity provider (FARGATE or FARGATE_SPOT)
capacity_provider = "FARGATE"
