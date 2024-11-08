terraform {
  backend "s3" {
    bucket         = "dzhelev-terraform-state-bucket"
    key            = "./terraform.tfstate"
    region         =  "eu-central-1"
    dynamodb_table = "dzhelev-tf-state-lock-db"
    encrypt        = true
  }
}
