provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = "private" # available are public, public-read
  tags   = merge(var.tags)
  # enable version control on objects
  versioning = {
    enabled = true
  }
  # To encrypt the data, creating KMS key 
  resource "aws_kms_key" "jaya-world-kms-s3" {
    description              = "kms key for s3"
    key_usage                = "ENCRYPT_DECRYPT"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    tags = {
      resource = "s3"
    }
  }
  # Passing the KMS key to encrypt the data 
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_defualt {
        kms_master_key_id = aws_kms_key.jaya-world-kms-s3.arn
        sse_algorithm     = "aws::kms"
        tags              = merge(var.tags)
      }
    }

  }

}