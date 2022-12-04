output "codebuild_project_frontend_arn" {
  description = "ARN of the frontend CodeBuild project."
  value       = aws_codebuild_project.frontend.arn
}
