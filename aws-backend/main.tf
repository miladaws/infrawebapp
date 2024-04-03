terraform {    
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

resource "aws_kms_key" "infrawebapp_encryption_key" {
    description = "This key is used to encrypt the objects in terraform state bucket"
    deletion_window_in_days = 10

    tags = {
        Name = "InfraWebAppTerraformStateEncryptionKey"
        Environment = "Production"
        Project = "InfraWebApp"
    }
}

resource "aws_s3_bucket" "terraform_state_bucket" {
    bucket = "infrawebapp-tf-state-03042024" 

    tags = {
        Name = "InfraWebAppTerraformStateBucket"
        Environment = "Production"
        Project = "InfraWebApp"
    }
}

// Enable server side encryption for bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.terraform_state_bucket.id

  rule {
    apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.infrawebapp_encryption_key.arn
        sse_algorithm     = "aws:kms"
    }
  }
}

// Enable versioning for bucket
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

// Block all public access for bucket
resource "aws_s3_bucket_public_access_block" "bucket_policy" {
  bucket = aws_s3_bucket.terraform_state_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "terraform-state-locking"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }

    tags = {
        Name = "InfraWebAppTerraformStateLocks"
        Environment = "Production"
        Project = "InfraWebApp"
    }    
}