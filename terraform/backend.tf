terraform {
  backend "s3" {
    bucket         = "my-terraform-backend-poc"
    key            = "eks/node-app/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
