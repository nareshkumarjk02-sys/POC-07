provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "tf_backend" {
  bucket = "my-terraform-backend-poc"
  force_destroy = true
}

resource "aws_dynamodb_table" "tf_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
