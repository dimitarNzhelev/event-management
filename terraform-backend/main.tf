provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform-state-bucket" {
  bucket = var.s3_bucket_name

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = var.s3_bucket_name
  }
}

resource "aws_s3_bucket_versioning" "terraform-state-bucket-versioning" {
  bucket = var.s3_bucket_name
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf-state-db" {
  name         = var.dynamodb_table_name
  hash_key     = "LockID"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity

  attribute {
    name = "LockID"
    type = "S"
  }
  
  tags = {
    Name = "tfStateLock"
  }
  
  depends_on = [
    aws_s3_bucket.terraform-state-bucket
  ]
}