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
  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration == null ? [] : var.server_side_encryption_configuration

    content {

      dynamic "rule" {
        for_each = try(server_side_encryption_configuration.value.rule, null) == null ? [] : [server_side_encryption_configuration.value.rule]

        content {

          bucket_key_enabled = try(rule.value.bucket_key_enabled, null)

          dynamic "apply_server_side_encryption_by_default" {
            for_each = try(rule.value.apply_server_side_encryption_by_default, null) == null ? [] : [rule.value.apply_server_side_encryption_by_default]

            content {
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
              kms_master_key_id = try(apply_server_side_encryption_by_default.value.kms_master_key_id, null)
            }
          }
        }
      }
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
  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration == null ? [] : var.server_side_encryption_configuration

    content {

      dynamic "rule" {
        for_each = try(server_side_encryption_configuration.value.rule, null) == null ? [] : [server_side_encryption_configuration.value.rule]

        content {

          bucket_key_enabled = try(rule.value.bucket_key_enabled, null)

          dynamic "apply_server_side_encryption_by_default" {
            for_each = try(rule.value.apply_server_side_encryption_by_default, null) == null ? [] : [rule.value.apply_server_side_encryption_by_default]

            content {
              sse_algorithm     = apply_server_side_encryption_by_default.value.sse_algorithm
              kms_master_key_id = try(apply_server_side_encryption_by_default.value.kms_master_key_id, null)
            }
          }
        }
      }
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
  /* Replication S3*/
  dynamic "replication_configuration" {
    for_each = var.replication_configuration == null ? [] : var.replication_configuration

    content {
      role = replication_configuration.value.role

      dynamic "rules" {
        for_each = try(replication_configuration.value.rules, null) == null ? [] : [replication_configuration.value.rules]

        content {
          delete_marker_replication_status = try(rules.value.delete_marker_replication_status, null)
          priority                         = try(rules.value.priority, null)
          status                           = rules.value.status
          id                               = rules.value.id
          prefix                           = try(rules.value.prefix, null)

          dynamic "destination" {
            for_each = try(rules.value.destination, null) == null ? [] : [rules.value.destination]

            content {
              bucket             = destination.value.bucket
              storage_class      = try(destination.value.storage_class, "STANDARD")
              replica_kms_key_id = try(destination.value.replica_kms_key_id, null)
              account_id         = try(destination.value.account_id, null)

              dynamic "access_control_translation" {
                for_each = try(rules.value.destination.access_control_translation.owner, null) == null ? [] : [rules.value.destination.access_control_translation.owner]

                content {
                  owner = access_control_translation.value
                }

              }
            }
          }

          dynamic "filter" {
            for_each = try(rules.value.filter, null) == null ? [] : [rules.value.filter]

            content {
              prefix = try(filter.value.prefix, null)
              tags   = try(filter.value.tags, {})
            }
          }

          dynamic "source_selection_criteria" {
            for_each = try(rules.value.source_selection_criteria, null) == null ? [] : [rules.value.source_selection_criteria]

            content {

              dynamic "sse_kms_encrypted_objects" {
                for_each = try(rules.value.source_selection_criteria.sse_kms_encrypted_objects.enabled, null) == null ? [] : [rules.value.source_selection_criteria.sse_kms_encrypted_objects.enabled]

                content {

                  enabled = source_selection_criteria.value

                }

              }

            }
          }
        }
      }
    }
  }
  /* CORS Configuration */
  dynamic "cors_rule" {
    for_each = var.cors_inputs == null ? [] : var.cors_inputs

    content {
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      allowed_methods = cors_rule.value.allowed_methods # Can be GET, PUT, POST, DELETE or HEAD
      allowed_origins = cors_rule.value.allowed_origins # Example, https://jaya-world.com
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }

  /* grant configuration (it conflicts with ACL) */
  dynamic "grant" {
    for_each = var.grant_inputs == null ? [] : var.grant_inputs

    content {
      id          = try(grant.value.id, null)          # Canonical user id to grant for. Used only when type is CanonicalUser
      type        = grant.value.type                   # Valid values are CanonicalUser and Group. AmazonCustomerByEmail is not supported
      permissions = try(grant.value.permissions, null) # Valid values are READ, WRITE, READ_ACP, WRITE_ACP, FULL_CONTROL
      uri         = try(grant.value.uri, null)         # Uri address to grant for. Used only when type is Group

    }

  }

}

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

