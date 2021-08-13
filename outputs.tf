# output of S3 bucket
output "id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.jaya-world-s3.id
}

output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.jaya-world-s3.arn
}