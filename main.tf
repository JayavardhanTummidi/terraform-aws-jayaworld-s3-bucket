provider "aws" {
  region = var.region
}
# New resource for KMS Key creation if you want it to be created by this module. if yes, change kms_master_key_id parameter below 
# right now it's currently set to input the KMS key manually. 
resource "aws_kms_key" "jaya-world-kms-key" {
  description = "for s3 buckets encryption"
  deletion_window_in_days = "7"
  tags   = merge(var.tags)
}
# Create a new bucket for logging and refer this resource in the original bucket creation to log the files. 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "jaya-world-log-bucket-hello"
  acl = "log-delivery-write"
  policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
     ]
   }
  POLICY
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


