terraform {
  backend "s3" {
    bucket         = "infrawebapp-tf-state-03042024"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-state-locking"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

module "networking" {
  source = "./modules/networking"
}

module "database" {
  source = "./modules/database"

  # Input Variables
  vpc_id      = module.networking.vpc_id
  subnet_id_a = module.networking.subnet_id_a
  subnet_id_b = module.networking.subnet_id_b

  db_password = var.db_password  
}

module "ecs_container" {
  source = "./modules/ecs_container"

  # Input Variables
  vpc_id      = module.networking.vpc_id
  subnet_id_a = module.networking.subnet_id_a
  subnet_id_b = module.networking.subnet_id_b

  db_username = module.database.db_username
  db_password = module.database.db_password
  db_name     = module.database.db_name
  db_endpoint = module.database.db_endpoint
}