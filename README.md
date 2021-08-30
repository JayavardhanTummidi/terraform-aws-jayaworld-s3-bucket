> **Thanks for using jaya-world modules** 

> **Example to Create Simple S3 bucket with the versioning enabled**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"

  # insert required variables here

  bucket_name     = "jaya-world.com"

}


> **Example to Create S3 bucket with the SSE S3**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"

  # insert required variables here

  bucket_name     = "jaya-world.com"

  server_side_encryption_configuration = [

    {

      rule = {

        apply_server_side_encryption_by_default = {

          sse_algorithm = "AES256"

        }

      }

    }

  ]

}

> **Example to Create S3 bucket with the SSE KMS with the bucket key enabled (I highly recommend to lower the KMS calls)**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"

  # insert required variables here

  bucket_name     = "jaya-world.com"

  server_side_encryption_configuration = [

    {

      rule = {

        bucket_key_enabled = "true"

        apply_server_side_encryption_by_default = {

          sse_algorithm = "aws:kms"

          kms_master_key_id = "kms key arn"  # Use jayaworld-kms-key module from terraform registry modules to create kms key

        }

      }

    }
    
  ]

}

> **Example to Create S3 bucket with the statis website hosting**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"

  # insert required variables here

  bucket_name     = "jaya-world.com"

  website = [
    
    {

    index_document = "welcome.html"

    error_document = "error.html"

    redirect_all_requests_to = "provide redirect rules if any"

    routing_rules = "provide routing rules if any"


    }
    
  ]

}

> **Example to Create S3 bucket with the replication configuration**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"

  # insert required variables here

  bucket_name     = "jaya-world.com"

  replication_configuration = [

    {

      role = "arn of iam role"

      rules = {

        id     = "specify id here"

        status = "Enabled"

        destination = {

          bucket = "destination bucket arn"

        source_selection_criteria = {

          sse_kms_encrypted_objects = {

            enabled = true
          }

        }

        }

      }

    }

  ]

}

> **Example to Create S3 bucket with the CORS**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"
  # insert required variables here

  bucket_name     = "jaya-world.com"

  cors_inputs = [

    {

      allowed_headers = "Specifies which headers are allowed"

      allowed_methods = "Can be GET, PUT, POST, DELETE or HEAD"

      allowed_origins = "Example, https://jaya-world.com"

      expose_headers  = "Specifies expose header in the response"

      max_age_seconds = "Specifies the seconds"

    }

  ]

}

> **Example to Create S3 bucket with the server access logging**

module "jayaworld-s3-bucket" {

  source  = "app.terraform.io/jaya-world/jayaworld-s3-bucket/aws"
  # insert required variables here

  log_bucket_name = "logs bucket id" # Use jayaworld-s3-logs-bucket module from terraform registry modules to create log bucket 

  bucket_name     = "jaya-world.com" 

}