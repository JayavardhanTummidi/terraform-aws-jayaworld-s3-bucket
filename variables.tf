variable "region" {
  type    = string
  default = "us-east-1"
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