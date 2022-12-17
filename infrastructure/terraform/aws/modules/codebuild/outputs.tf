output "codebuild_project_frontend_arn" {
  description = "ARN of the frontend CodeBuild project."
  value       = aws_codebuild_project.frontend.arn
}

output "codebuild_project_sam_package_arn" {
  description = "ARN of the sam package CodeBuild project."
  value       = aws_codebuild_project.sam_package.arn
}

output "codebuild_project_sam_deploy_arn" {
  description = "ARN of the sam deploy CodeBuild project."
  value       = aws_codebuild_project.sam_deploy.arn
}
