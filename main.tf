provider "aws" {
  region = var.region
}

# Create a new bucket for logging and refer this resource in the original bucket creation to log the files. 
resource "aws_s3_bucket" "log_bucket" {
  bucket = "jaya-world-log-bucket-hello"
  acl = "log-delivery-write"
}
# Manage public access settings for the S3 log bucket. 
resource "aws_s3_bucket_public_access_block" "public_access_block" {
  bucket = aws_s3_bucket.log_bucket.id

  # S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs.
  block_public_acls = false

  # S3 will ignore all ACLs that grant public access to buckets and objects.
  ignore_public_acls = false
  
  # S3 will block new bucket and access point policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources
  block_public_policy = false

  # S3 will ignore public and cross-account access for buckets or access points with policies that grant public access to buckets and objects.
  restrict_public_buckets = false

}
resource "aws_s3_bucket" "jaya-world-s3" {
  bucket = var.bucket_name
  acl    = var.acl
  policy = var.policy
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


