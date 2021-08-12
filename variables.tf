variable "region" {
  type    = string
  default = "us-east-1"
}


variable "bucket_name" {
  description = "please provide bucket name"
  type        = string
}

variable "tags" {
  description = "please provide tags for S3 bucket"
  type        = map(string)
  default     = {}
}

variable "aws_access_key_id" {
  type    = string
  default = "AKIAVGLA7FRWMSC4D7GD"
}
variable "aws_secret_access_key" {
  type    = string
  default = "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"
} 