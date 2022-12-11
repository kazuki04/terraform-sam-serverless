
output "s3_bucket_hosting_id" {
  description = "The name of the hosting bucket."
  value       = aws_s3_bucket.hosting.id
}

output "s3_bucket_artifact_id" {
  description = "The name of the artifact bucket."
  value       = aws_s3_bucket.artifact.id
}

output "s3_bucket_cloudfront_log_id" {
  description = "The name of the CloudFront log bucket."
  value       = aws_s3_bucket.cloudfront_log.id
}

output "s3_bucket_hosting_bucket_regional_domain_name " {
  description = "The bucket region-specific domain name."
  value       = aws_s3_bucket.hosting.id
}
