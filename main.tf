provider "aws" {
  region = var.region
}
# Create a new bucket server logging
resource "aws_s3_bucket" "jaya_world_log_bucket" {
  bucket        = var.log_bucket_name
  acl           = "log-delivery-write"
  policy        = var.log_bucket_policy
  force_destroy = var.log_bucket_force_destroy
  tags          = merge(var.tags)
  # enable version control on objects
  versioning {
    enabled = true
  }
  # making server side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.aws_kms_key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = "true"
    }
  }

  # Lifecyle rule for logs
  lifecycle_rule {
    id      = "log"
    prefix  = "log/"
    enabled = true
    tags = {
      rule      = "log"
      autoclean = "true"
    }

    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }

    transition {
      days          = 60
      storage_class = "GLACIER"
    }

    expiration {
      days = 90
    }
  }

}
# Create a new bucket
resource "aws_s3_bucket" "jaya-world-s3" {
  bucket              = var.bucket_name
  acl                 = var.acl
  policy              = var.policy
  force_destroy       = var.force_destroy
  request_payer       = var.request_payer
  acceleration_status = var.acceleration_status
  tags                = merge(var.tags)
  # enable version control on objects
  versioning {
    enabled = true
  }
  # making server side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.aws_kms_key_arn
        sse_algorithm     = "aws:kms"
      }
      bucket_key_enabled = "true"
    }
  }

  # static website hosting
  dynamic "website" {
    for_each = var.website

    content {
      index_document           = lookup(website.value, "index_document", null)
      error_document           = lookup(website.value, "error_document", null)
      redirect_all_requests_to = lookup(website.value, "redirect_all_requests_to", null)
      routing_rules            = lookup(website.value, "routing_rules", null)
    }
  }

  # enable server logging 
  logging {
    target_bucket = aws_s3_bucket.jaya_world_log_bucket.id
    target_prefix = "log/"
  }

  # Dynamic Lifecycle rule for incomplete multipart upload objects and expired object delete markers.
  lifecycle_rule {
    id                                     = "Abort_multipart_and_expired_object_delete_marker"
    enabled                                = "true"
    abort_incomplete_multipart_upload_days = var.abort_incomplete_multipart_upload_days
    expiration {
      expired_object_delete_marker = "true"
    }
  }

  # Dynamic lifecycle rule for noncurrent version transition. previous version. 
  lifecycle_rule {
    id      = "Rule_for_previous_versions"
    enabled = "true"

    dynamic "noncurrent_version_transition" {
      for_each = var.noncurrent_version_transitions

      content {
        days          = noncurrent_version_transition.value.days
        storage_class = noncurrent_version_transition.value.storage_class
      }
    }
    noncurrent_version_expiration {
      days = var.previous_version_expiration_days
    }

  }
  # Dynamic lifecycle rule for current versions with the filter option
  lifecycle_rule {
    id      = var.lifecycle_rule_id
    prefix  = var.lifecycle_rule_prefix
    enabled = "true"
    expiration {
      days = var.expiration_days
    }

    dynamic "transition" {
      for_each = var.transitions

      content {
        days          = transition.value.days
        storage_class = transition.value.storage_class
      }
    }

  }
  # For replication configuration
  replication_configuration {
    role = var.replica_role
    dynamic "rules" {
      for_each = var.rules
      content {
        status = rules.value.status
        dynamic "destination" {
          for_each = lookup(rules.value, "destination", null)
          content {
            bucket = destination.value.bucket
          }
        }
      }
    }
  }
}










/*
  dynamic "replication_configuration" {
    for_each = var.replication_configuration

    content {
      role = replication_configuration.value.role

      dynamic "rules" {
        for_each = replication_configuration.value.rules

        content {
          delete_marker_replication_status = lookup(rules.value, "delete_marker_replication_status", null)
          priority                         = lookup(rules.value, "priority", null)
          status                           = rules.value.status
          id                               = lookup(rules.value, "id", null)
          prefix                           = lookup(rules.value, "prefix", null)

          dynamic "destination" {
            for_each = lookup(rules.value, "destination", null)

            content {
              bucket             = destination.value.bucket
              storage_class      = lookup(destination.value, "storage_class", null)
              replica_kms_key_id = lookup(destination.value, "replica_kms_key_id", null)
              account_id         = lookup(destination.value, "account_id", null)

              dynamic "access_control_translation" {
                for_each = lookup(destination.value, "access_control_translation", null)

                content {
                  owner = access_control_translation.value.owner
                }

              }
            }
          }

          dynamic "filter" {
            for_each = lookup(rules.value, "filter", null)

            content {
              prefix = lookup(filter.value, "prefix", null)
              tags   = lookup(filter.value, "tags", null)
            }
          }

          dynamic "source_selection_criteria" {
            for_each = lookup(rules.value, "source_selection_criteria", null)

            content {

              dynamic "sse_kms_encrypted_objects" {
                for_each = lookup(source_selection_criteria.value, "sse_kms_encrypted_objects", null)

                content {

                  enabled = lookup(sse_kms_encrypted_objects.value, "enabled", null)

                }

              }

            }
          }
        }
      }
    }
  }
}
*/




# Manage public access settings for the S3 log bucket. 
resource "aws_s3_bucket_public_access_block" "jaya-world-s3" {
  bucket = aws_s3_bucket.jaya-world-s3.id

  # S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs.
  block_public_acls = var.block_public_acls

  # S3 will ignore all ACLs that grant public access to buckets and objects.
  ignore_public_acls = var.ignore_public_acls

  # S3 will block new bucket and access point policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources
  block_public_policy = var.block_public_policy

  # S3 will ignore public and cross-account access for buckets or access points with policies that grant public access to buckets and objects.
  restrict_public_buckets = var.restrict_public_buckets

}
resource "aws_s3_bucket_public_access_block" "jaya_world_log_bucket" {
  bucket = aws_s3_bucket.jaya_world_log_bucket.id

  # S3 will block public access permissions applied to newly added buckets or objects, and prevent the creation of new public access ACLs for existing buckets and objects. This setting doesn’t change any existing permissions that allow public access to S3 resources using ACLs.
  block_public_acls = true

  # S3 will ignore all ACLs that grant public access to buckets and objects.
  ignore_public_acls = true

  # S3 will block new bucket and access point policies that grant public access to buckets and objects. This setting doesn't change any existing policies that allow public access to S3 resources
  block_public_policy = true

  # S3 will ignore public and cross-account access for buckets or access points with policies that grant public access to buckets and objects.
  restrict_public_buckets = true

}

