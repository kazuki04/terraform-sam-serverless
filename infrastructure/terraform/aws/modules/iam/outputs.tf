output "iam_role_codebuild_arn" {
  description = "The Amazon Resource Name (ARN) of the CodeBuild."
  value       = aws_iam_role.codebuild.arn
}

output "iam_role_codepipeline_arn" {
  description = "The Amazon Resource Name (ARN) of the CodePipelilne."
  value       = aws_iam_role.codepipeline.arn
}

output "iam_role_cloudformation_arn" {
  description = "The Amazon Resource Name (ARN) of the CloudFormation."
  value       = aws_iam_role.cloudformation.arn
}
