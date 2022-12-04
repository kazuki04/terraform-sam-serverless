output "iam_role_codebuild_arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  value       = aws_iam_role.codebuild.arn
}
