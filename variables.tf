variable "region" {
  type    = string
  default = "us-east-1"
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
}

variable "log_bucket" {
  description = "Random name for creating log bucket to enable logs"
  type = string
}

variable "policy" {
  description = "A valid bucket policy JSON document. Note that if the policy document is not specific enough (but still valid), Terraform may view the policy as constantly changing in a terraform plan"
  type = string
  default = ""
}

variable "tags" {
  description = "please provide tags for S3 bucket"
  type        = map(string)
  default     = {}
}