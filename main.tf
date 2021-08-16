provider "aws" {
  region = var.region
}
# Create a new bucket
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
  # enable server logging 
  logging {
    target_bucket = var.s3_logs_bucket_id
    target_prefix = "log/"
  }
}
# Lifecyle rule for logs 
  lifecycle_rule {
    id = "log"
    prefix = "log/"
    enabled = "true"
    tags = {
     rule = "log"
     autoclean = "true"
    } 
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 90
    }
  }
# Lifecycle rule for non version objects
  lifecycle_rule {
    id = "noncurrent_version_transitioning"
    enabled = "true"
    tags = {
      rule = "apply to all objects"
    }
    noncurrent_version_transitioning {
     days = 30
     storage_class = "STANDARD_IA"     
    }
    noncurrent_version_transitioning {
     days = 60
     storage_class = "GLACIER"
    }
    noncurrent_version_expiration {
     days = 90
    }
  }
# Lifecycle rule for all the objects
  lifecycle_rule {
    id = "apply to all the objects"
    enabled = "true"
    tags = {
      apply = "all the objects"
    }
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }    
    transition {
      days = 60
      storage_class = "GLACIER"
    }
    expiration {
      days = 90
    }
  }

}

# Manage public access settings for the S3 log bucket. 
resource "aws_s3_bucket_public_access_block" "jaya-world-s3" {
  bucket = aws_s3_bucket.jaya-world-s3.id

  # S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs.
  block_public_acls = true

  # S3 will ignore all ACLs that grant public access to buckets and objects.
  ignore_public_acls = true
  
  # S3 will block new bucket and access point policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources
  block_public_policy = true

  # S3 will ignore public and cross-account access for buckets or access points with policies that grant public access to buckets and objects.
  restrict_public_buckets = true

}

