variable "vpc_id" {
  description = "VPC ID for the database"
  type        = string
}

variable "subnet_id_a" {
  description = "First subnet ID for the database"
  type        = string
}

variable "subnet_id_b" {
  description = "Second subnet ID for the database"
  type        = string
}

variable "db_username" {
  description = "username of the database"
  type        = string
}

variable "db_password" {
  description = "Password of the database"
  type        = string
}

variable "db_name" {
  description = "Name of the database"
  type        = string
}

variable "db_endpoint" {
  description = "Endpoint of the database"
  type        = string
}

locals {
  database_url = "postgresql://${var.db_username}:${var.db_password}@${var.db_endpoint}/${var.db_name}"
}

# Define the ECS Cluster
resource "aws_ecs_cluster" "InfraWebAppCluster" {
  name = "infrawebapp-cluster"
}

# Create an IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Effect = "Allow",
      Sid = ""
    }]
  })
}

# Attach the ECS Task Execution Role Policy to the IAM Role
resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Define the ECS Task Definition
resource "aws_ecs_task_definition" "InfraWebAppTask" {
  family                   = "my-task-family"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256" 
  memory                   = "512"  
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([{
    name      = "infrawebapp-container",
    image     = "ghcr.io/sosafe-cloud-engineering/pg-connect:arm64",  
    cpu       = 256,
    memory    = 512,
    essential = true,
    portMappings = [{
      containerPort = 8000,  
      hostPort      = 8000
    }],
    environment = [
      { name = "DATABASE_URL", value = local.database_url }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group"         = "/ecs/infrawebapp-container",
        "awslogs-region"        = "eu-central-1",  
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])
}

resource "aws_security_group" "ecs_sg" {
  name        = "ecs-http-sg"
  description = "Security group for ECS to allow HTTP traffic"
  vpc_id      = var.vpc_id  

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-http-sg"
  }
}

# Create the ECS Service
resource "aws_ecs_service" "InfraWebAppService" {
  name            = "infrawebapp-service"
  cluster         = aws_ecs_cluster.InfraWebAppCluster.id
  task_definition = aws_ecs_task_definition.InfraWebAppTask.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [var.subnet_id_a, var.subnet_id_b]  
    security_groups  = [aws_security_group.ecs_sg.id]      
    assign_public_ip = true
  }
}
