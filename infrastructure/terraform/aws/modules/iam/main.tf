################################################################################
# IAM resources for CodeBuild
################################################################################
data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codebuild_inline" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "logs:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "${var.service_name}-${var.environment_identifier}-role-cbproject"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-role-cbproject"
  }
}

resource "aws_iam_policy" "codebuild" {
  name   = "${var.service_name}-${var.environment_identifier}-policy-cbproject"
  policy = data.aws_iam_policy_document.codebuild_inline.json
}

resource "aws_iam_role_policy_attachment" "codebuild" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild.arn
}

################################################################################
# IAM resources for CodePipeline
################################################################################
data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "codepipeline_inline" {

  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codecommit:CancelUploadArchive",
      "codecommit:GetBranch",
      "codecommit:GetCommit",
      "codecommit:GetUploadArchiveStatus",
      "codecommit:UploadArchive",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "codebuild:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "kms:*"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "cloudformation:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "${var.service_name}-${var.environment_identifier}-role-codepipeline"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-role-codepipeline"
  }
}

resource "aws_iam_policy" "codepipeline" {
  name   = "${var.service_name}-${var.environment_identifier}-policy-codepipeline"
  policy = data.aws_iam_policy_document.codepipeline_inline.json
}

resource "aws_iam_role_policy_attachment" "codepipeline" {
  role       = aws_iam_role.codepipeline.name
  policy_arn = aws_iam_policy.codepipeline.arn
}

################################################################################
# IAM resources for CloudFormation
################################################################################
data "aws_iam_policy_document" "cloudformation_assume" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["cloudformation.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cloudformation_inline" {

  statement {
    actions = [
      "iam:PassRole"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "apigateway:*",
      "cloudformation:*",
      "execute-api:*",
      "iam:*",
      "lambda:*",
      "s3:*"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "cloudformation" {
  name               = "${var.service_name}-${var.environment_identifier}-role-cloudformation"
  assume_role_policy = data.aws_iam_policy_document.cloudformation_assume.json

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-role-cloudformation"
  }
}

resource "aws_iam_policy" "cloudformation" {
  name   = "${var.service_name}-${var.environment_identifier}-policy-cloudformation"
  policy = data.aws_iam_policy_document.cloudformation_inline.json
}

resource "aws_iam_role_policy_attachment" "cloudformation" {
  role       = aws_iam_role.cloudformation.name
  policy_arn = aws_iam_policy.cloudformation.arn
}
