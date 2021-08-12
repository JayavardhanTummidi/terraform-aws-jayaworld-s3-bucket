provider "aws" {
  region = var.region
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

resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = var.acl
  tags   = merge(var.tags)
  # enable version control on objects
  versioning  {
    enabled = true
  }
  # Passing the KMS key to encrypt the data 
  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_defualt {
          kms_master_key_id = aws_kms_key.jaya-world-kms-s3.kms_arn
          sse_algorithm     = "aws:kms"
      }
    }
  }
}
