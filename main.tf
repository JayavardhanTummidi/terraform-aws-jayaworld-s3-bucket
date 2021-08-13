provider "aws" {
  region = var.region
}
# for managing custom managed KMS key
data "aws_kms_key" "this" {
  key_id = var.aws_kms_key_arn
}
# New resource for KMS Key creation
resource "aws_kms_key" "jaya-world-kms-key" {
  description = "for s3 buckets encryption"
  deletion_window_in_days = "7"
  tags   = merge(var.tags)
}
resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = var.acl
  tags   = merge(var.tags)
  # enable version control on objects
  versioning  {
    enabled = true
  }
  # making server side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        #kms_master_key_id = aws_kms_key.jaya-world-kms-key.arn
        kms_master_key_id = data.aws_kms_key.this.id == null ? "KMS key is not valid" : var.aws_kms_key_arn
        sse_algorithm = "aws:kms"
      }
    }
  }
}
