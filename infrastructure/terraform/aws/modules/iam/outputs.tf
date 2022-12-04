output "iam_role_codebuild_arn" {
  description = "The Amazon Resource Name (ARN) of the CodeBuild."
  value       = aws_iam_role.codebuild.arn
}

output "iam_role_codepipeline_arn" {
  description = "The Amazon Resource Name (ARN) of the CodePipelilne."
  value       = aws_iam_role.codepipeline.arn
}
