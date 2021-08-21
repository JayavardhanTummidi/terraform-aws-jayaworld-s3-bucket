variable "region" {
  type    = string
  default = "us-east-1"
}
variable "log_bucket_name" {
  description = "please provide bucket name to create s3 log bucket"
  type        = string
}
variable "aws_kms_key_arn" {
   description = "The customer managed(CMK) to encrypt the bucket. Please create KMS Key if you haven't done already"
   type = string
}
variable "bucket_name" {
  description = "please provide bucket name"
  type        = string
}

variable "acl" {
  description = "The canned ACL to apply. Valid values are private, public-read, public-read-write, aws-exec-read, authenticated-read, and log-delivery-write. Defaults to private. Conflicts with grant"
  type = string
  default = "private"
}

variable "policy" {
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan"
  type = string
  default = ""
}

variable "log_bucket_policy" {
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan"
  type = string
  default = ""
}

variable "force_destroy" {
  description = "Whether to allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
  type = bool
  default = "false"
}

variable "log_bucket_force_destroy" {
  description = "Whether to allow the object to be deleted by removing any legal hold on any object version. Default is false. This value should be set to true only if the bucket has S3 object lock enabled."
  type = bool
  default = "false" 
}

variable "acceleration_status" {
  description = "Transfer Acceleration takes advantage of the globally distributed edge locations in Amazon CloudFront. As the data arrives at an edge location, the data is routed to Amazon S3 over an optimized network path."
  type = string
  default = "Suspended"
}

variable "request_payer" {
  description = "Specifies who should bear the cost of Amazon S3 data transfer. Can be either BucketOwner or Requester. By default, the owner of the S3 bucket would incur the costs of any data transfer. "
  type = string
  default = "BucketOwner"
}

variable "abort_incomplete_multipart_upload_days" {
  description = "Specifies the number of days after initiating a multipart upload when the multipart upload must be completed."
  type = number
  default = 7
}

variable "expiration_days" {
  description = "Specifies the number of days after object creation when the specific rule action takes effect. This is for current version"
  type = number
  default = "365"
}

variable "previous_version_expiration_days" {
  description = "Specifies the number of days after object becomes non-current"
  type = number
  default = "90"
}

variable "noncurrent_version_transitions" {
  description = "Specifies the number of days noncurrent object versions transition and Specifies the Amazon S3 storage class to which you want the noncurrent object versions to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE."
  type = list
  default = [
    { 
     days= "30"
     storage_class = "STANDARD_IA"
   }
  ]
}

variable "transitions" {
  description = "Specifies the number of days after object creation when the specific rule action takes effect and Specifies the Amazon S3 storage class to which you want the object to transition. Can be ONEZONE_IA, STANDARD_IA, INTELLIGENT_TIERING, GLACIER, or DEEP_ARCHIVE."
  type = list
  default = [
    {
      days = "30"
      storage_class = "STANDARD_IA"
    }
  ]
}

variable "lifecycle_rule_id" {
  description = "Unique identifier for the lifecycle rule. Must be less than or equal to 255 characters in length."
  type = string
  default = "Rule_for_current_versions"
}

variable "lifecycle_rule_prefix" {
  description = "Object key prefix identifying one or more objects to which the rule applies."
  type = string
  default = ""
}

variable "website_rules" {
  description = "provide following optional inputs - 'index_document', 'error_document' and 'redirect_all_requests_to' to enable statis website"
  type = map(string) 
  default = {}
}

variable "tags" {
  description = "please provide tags for S3 bucket"
  type        = map(string)
  default     = {}
}