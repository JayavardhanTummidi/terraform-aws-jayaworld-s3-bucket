# output of S3 bucket
output "id" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.jaya-world-s3.id
}

output "arn" {
  description = "The ARN of the bucket. Will be of format arn:aws:s3:::bucketname."
  value       = aws_s3_bucket.jaya-world-s3.arn
}
# output of KMS key for S3 bucket data encryption
output "key_id" {
  description = "KMS Key ID"
  value       = aws_kms_key.jaya-world-kms-s3.key_id
}

output "kms_arn" {
  description = "KMS Key ARN"
  value       = aws_kms_key.jaya-world-kms-s3.arn
}