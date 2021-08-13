provider "aws" {
  region = var.region
}
resource "aws_kms_key" "jaya-world-kms" {
  description = "reference from jaya-world-kms resource"
}
resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = var.acl
  tags   = merge(var.tags)
  # enable version control on objects
  versioning  {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.jaya-world-kms.arn
        sse_algorithm = "aws:kms"
      }
    }
  }
}
