
output "s3_bucket_hosting_id" {
  description = "The name of the hosting bucket."
  value       = aws_s3_bucket.hosting.id
}

output "s3_bucket_artifact_id" {
  description = "The name of the artifact bucket."
  value       = aws_s3_bucket.artifact.id
}
