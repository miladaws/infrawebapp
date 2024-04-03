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

variable "db_password" {
  description = "Password of the database"
  type        = string
}

resource "aws_db_subnet_group" "postgres_subnet_group" {
  name       = "infrawebapp-postgres-subnet-group"
  subnet_ids = [var.subnet_id_a, var.subnet_id_b] 

  tags = {
    Name = "InfraWebAppPostgresSubnetGroup"
  }
}

resource "aws_security_group" "postgres_sg" {
  name        = "postgres-sg"
  description = "Allow inbound PostgreSQL traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "InfraWebAppPostgresSecurityGroup"
  }
}

resource "aws_db_instance" "postgres" {
  identifier             = "postgres"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "postgres"
  engine_version         = "16.1"
  instance_class         = "db.t3.micro"
  username               = "edu"
  password               = var.db_password
  parameter_group_name   = aws_db_parameter_group.postgres.name
  db_subnet_group_name   = aws_db_subnet_group.postgres_subnet_group.name
  vpc_security_group_ids = [aws_security_group.postgres_sg.id]
  skip_final_snapshot    = true
  tags = {
    Name = "InfraWebAppPostgresInstance"
  }
}

resource "aws_db_parameter_group" "postgres" {
  name   = "postgres"
  family = "postgres16"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}
