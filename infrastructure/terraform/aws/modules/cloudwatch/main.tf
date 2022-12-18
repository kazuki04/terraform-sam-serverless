resource "aws_cloudwatch_log_group" "codebuild_frontend" {
  name              = "/aws/codebuild/${var.service_name}-${var.environment_identifier}-codebuild-frontend"
  retention_in_days = 90
}
