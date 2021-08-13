variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_kms_key_arn" {
   description = "The customer managed(CMK) to encrypt the bucket"
   type = string
}
variable "bucket_name" {
  description = "please provide bucket name"
  type        = string
}

variable "acl" {
  description = "choose who wants to access. options are private, public, public-read"
  type = string
}

variable "tags" {
  description = "please provide tags for S3 bucket"
  type        = map(string)
  default     = {}
}