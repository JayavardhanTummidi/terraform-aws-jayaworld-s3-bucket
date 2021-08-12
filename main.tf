provider "aws" {
  region = "${var.region}"
  access_key = var.aws_access_key_id
  secret_key = var.aws_secret_access_key
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  acl    = "private"
}