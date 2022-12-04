################################################################################
# IAM resources for CodeBuild
################################################################################
resource "aws_iam_role" "codebuild" {
  name = "${var.service_name}-${var.environment_identifier}-role-cbproject"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  managed_policy_arns = [ aws_iam_policy.codebuild.id ]

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-role-cbproject"
  }
}

resource "aws_iam_policy" "codebuild" {
  name = "${var.service_name}-${var.environment_identifier}-policy-cbproject"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = ["s3:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["logs:*"]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = ["kms:*"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
