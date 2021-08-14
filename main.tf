provider "aws" {
  region = var.region
}

# Create a new bucket for logging and refer this resource in the original bucket creation to log the files. 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "jaya-world-log-bucket-hello"
  acl = "log-delivery-write"
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
         kms_master_key_id = var.aws_kms_key_arn
         sse_algorithm = "aws:kms"
      }
    }
  }
  # enable logging 
  logging {
    target_bucket = aws_s3_bucket.log_bucket.id
    target_prefix = "log/"
  }
}


