provider "aws" {
    region = "us-east-1"
    shared_credentials_file = "/Users/jayavardhantummidi/.aws/credentials"
    profile = "jayaworld"
}

resource "aws_s3_bucket" "jaya_world_s3" {
  bucket = var.bucket_name
  acl    = "private"
}