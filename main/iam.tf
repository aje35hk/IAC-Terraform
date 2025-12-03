####IAM ROLES####

resource "aws_iam_role" "test_container_execution_role" {
  name        = "TestContainerExecutionRole"
  description = "Role for ECS task execution for test container"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

####### IAM Policy ########

resource "aws_iam_policy" "cloudwatch_log_group_create" {
  name        = "TestContainerCloudWatchLogGroupCreation"
  description = "Allows creating and writing to CloudWatch log groups"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_policy" "ssm_parameter_access" {
  name = "TestContainerSSMParameterAccess"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "ssm:GetParameter",
          "ssm:GetParameters",
          "ssm:GetParametersByPath"
        ],
        Resource = "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/ecs/test-container/*"
      }
    ]
  })
}

####### IAM Role Policy Attachment ####

resource "aws_iam_policy_attachment" "ecs_execution_role_policy" {
  name       = "test_container_ecs_execution_role_policy_attachment"
  roles      = [aws_iam_role.test_container_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_log_group_create_attach" {
  role       = aws_iam_role.test_container_execution_role.name
  policy_arn = aws_iam_policy.cloudwatch_log_group_create.arn
}

resource "aws_iam_role_policy_attachment" "ssm_parameter_access_attach" {
  role       = aws_iam_role.test_container_execution_role.name
  policy_arn = aws_iam_policy.ssm_parameter_access.arn
}
