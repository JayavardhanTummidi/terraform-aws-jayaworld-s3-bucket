variable "region" {
  type    = string
  default = "us-east-1"
}


variable "bucket_name" {
  description = "please provide bucket name"
  type    = string
}

variable "tags" {
  type    = map(string)
  default = {}
}