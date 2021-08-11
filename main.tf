provider "aws" {
  region = "${var.region}"
}

resource "aws_s3_bucket" "jaya_world_s3" {
  bucket = var.bucket_name
  acl    = "private"
}