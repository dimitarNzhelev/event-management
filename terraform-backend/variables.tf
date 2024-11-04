variable "s3_bucket_name" {
  description = "The name of the S3 bucket for Terraform state"
  type        = string
  default     = "dzhelev-terraform-state-bucket"
}

variable "dynamodb_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default     = "dzhelev-tf-state-lock-db"
}

variable "dynamodb_read_capacity" {
  description = "The read capacity for the DynamoDB table"
  type        = number
  default     = 8
}

variable "dynamodb_write_capacity" {
  description = "The write capacity for the DynamoDB table"
  type        = number
  default     = 8
}

variable "aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "eu-central-1"
}