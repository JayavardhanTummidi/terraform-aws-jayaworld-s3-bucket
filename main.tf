provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = "private"
  tags = merge(var.tags)
}