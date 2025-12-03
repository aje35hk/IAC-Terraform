# Test Container - Simplified ECS Deployment Blueprint

A simplified Terraform blueprint for deploying a single container to AWS ECS with Fargate. This blueprint mirrors the architecture of the main infrastructure but focuses on deploying just one container for testing or learning purposes.

## 📋 Overview

This blueprint creates:
- **VPC** with public and private subnets across 3 availability zones
- **ECS Cluster** with Fargate capacity provider
- **Application Load Balancer** for HTTP traffic
- **Security Groups** for ECS tasks and load balancer
- **IAM Roles** with necessary permissions
- **CloudWatch Logs** for container logging

## 🎯 Use Cases

- Learning ECS deployment patterns
- Testing containerized applications
- Proof-of-concept deployments
- Development/staging environments

## 📁 Project Structure

```
IAC-Terraform/
├── main/
│   ├── provider.tf          # Terraform & AWS provider config
│   ├── variables.tf         # Variable definitions
│   ├── terraform.tfvars     # Variable values
│   ├── vpc.tf               # VPC configuration
│   ├── securityGroups.tf    # Security group rules
│   ├── iam.tf               # IAM roles and policies
│   ├── ecs.tf               # ECS cluster and service
│   ├── loadBalancer.tf      # ALB and target group
│   └── outputs.tf           # Output values
├── modules/                 # Reusable Terraform modules
│   ├── ecs/
│   ├── loadbalancer/
│   ├── security_groups/
│   └── vpc/
├── container-definitions/
│   └── test_container_def.json  # Container definition
└── README.md                # This file
```

## 🚀 Quick Start

### Prerequisites

1. **AWS Account** with appropriate permissions
2. **Terraform** >= 1.2 installed ([Download](https://www.terraform.io/downloads))
3. **AWS CLI** configured with credentials ([Setup Guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html))

### Step 1: Configure Variables

```bash
cd main

# Edit terraform.tfvars with your values
nano terraform.tfvars
```

**Key variables to configure:**

```hcl
# Use your own Docker image
container_image = "nginx:latest"  # or your ECR image

# Adjust resources as needed
cpu    = "256"   # 0.25 vCPU
memory = "512"   # 512 MB

# Container port
container_port = 80

# Number of tasks
desired_count = 1
```

### Step 2: Deploy

```bash
# Initialize Terraform
terraform init

# Preview changes
terraform plan

# Deploy infrastructure
terraform apply
```

After deployment completes, Terraform will output the load balancer URL and other details:

```
Outputs:

access_url = "http://test-container-1234567890.ap-south-1.elb.amazonaws.com"
alb_arn = "arn:aws:elasticloadbalancing:ap-south-1:123456789012:loadbalancer/app/test-container/..."
alb_dns_name = "test-container-1234567890.ap-south-1.elb.amazonaws.com"
container_image = "nginx:latest"
ecs_cluster_arn = "arn:aws:ecs:ap-south-1:123456789012:cluster/test-container"
ecs_cluster_name = "test-container"
vpc_id = "vpc-12345678"
```

### Step 3: Access Your Container

Open the `access_url` in your browser or use curl:

```bash
curl http://test-container-1234567890.ap-south-1.elb.amazonaws.com
```

## 🔧 Configuration Options

### Variables

| Variable | Description | Default | Example |
|----------|-------------|---------|---------|
| `aws_region` | AWS region for deployment | `ap-south-1` | `us-east-1` |
| `project` | Project name (resource prefix) | `test-container` | `my-app` |
| `container_image` | Docker image to deploy | `nginx:latest` | `123456.dkr.ecr.region.amazonaws.com/app:v1` |
| `container_port` | Port container listens on | `80` | `8000` |
| `desired_count` | Number of tasks to run | `1` | `2` |
| `cpu` | Task CPU units | `256` | `512`, `1024` |
| `memory` | Task memory (MB) | `512` | `1024`, `2048` |
| `health_check_path` | Health check endpoint | `/` | `/health` |
| `capacity_provider` | Fargate type | `FARGATE` | `FARGATE_SPOT` |

### CPU and Memory Combinations

Valid Fargate CPU/Memory combinations:

| CPU (vCPU) | Memory (MB) |
|------------|-------------|
| 256 (0.25) | 512, 1024, 2048 |
| 512 (0.5)  | 1024 - 4096 (1 GB increments) |
| 1024 (1)   | 2048 - 8192 (1 GB increments) |
| 2048 (2)   | 4096 - 16384 (1 GB increments) |
| 4096 (4)   | 8192 - 30720 (1 GB increments) |

## 🐳 Using Your Own Container

### Option 1: Public Docker Hub Image

```hcl
container_image = "nginx:latest"
container_port  = 80
```

### Option 2: AWS ECR Image

1. **Create ECR repository:**
   ```bash
   aws ecr create-repository --repository-name my-app --region ap-south-1
   ```

2. **Build and push your image:**
   ```bash
   # Login to ECR
   aws ecr get-login-password --region ap-south-1 | \
     docker login --username AWS --password-stdin 123456789.dkr.ecr.ap-south-1.amazonaws.com
   
   # Build image
   docker build -t my-app:latest .
   
   # Tag image
   docker tag my-app:latest 123456789.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest
   
   # Push image
   docker push 123456789.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest
   ```

3. **Update terraform.tfvars:**
   ```hcl
   container_image = "123456789.dkr.ecr.ap-south-1.amazonaws.com/my-app:latest"
   container_port  = 8000  # Your app's port
   health_check_path = "/health"  # Your health endpoint
   ```

## 🔍 Monitoring & Debugging

### View Container Logs

```bash
# Get log group name
aws logs describe-log-groups --log-group-name-prefix /ecs/test-container

# Tail logs
aws logs tail /ecs/test-container --follow
```

### Check ECS Service Status

```bash
# List services
aws ecs list-services --cluster test-container

# Describe service
aws ecs describe-services --cluster test-container --services test-container-task
```

### Check Task Status

```bash
# List running tasks
aws ecs list-tasks --cluster test-container

# Describe task (replace TASK_ID)
aws ecs describe-tasks --cluster test-container --tasks TASK_ID
```

## 💰 Cost Optimization

### Use Fargate Spot

Save up to 70% by using Fargate Spot for non-critical workloads:

```hcl
capacity_provider = "FARGATE_SPOT"
```

### Reduce Resources

For testing, use minimal resources:

```hcl
cpu           = "256"   # Minimum
memory        = "512"   # Minimum
desired_count = 1       # Single task
```

## 🧹 Cleanup

To destroy all resources:

```bash
cd main
terraform destroy
```

**Note:** This will delete:
- ECS cluster and service
- Load balancer and target group
- VPC and subnets
- Security groups
- IAM roles

## 🔐 Security Best Practices

1. **Use Private Subnets**: Containers run in private subnets (no direct internet access)
2. **Least Privilege IAM**: Execution role has minimal required permissions
3. **Security Groups**: Restrictive ingress/egress rules
4. **Secrets Management**: Use AWS SSM Parameter Store or Secrets Manager for sensitive data
5. **HTTPS**: Add ACM certificate for production (commented in `loadBalancer.tf`)

## 🤝 Contributing

This blueprint is based on the main infrastructure. When making changes:

1. Keep it simple and focused on single-container deployment
2. Document all configuration options
3. Test with both public and ECR images
4. Update this README with any changes

## 📚 Additional Resources

- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Terraform AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Fargate Pricing](https://aws.amazon.com/fargate/pricing/)
- [ECS Best Practices](https://docs.aws.amazon.com/AmazonECS/latest/bestpracticesguide/intro.html)
