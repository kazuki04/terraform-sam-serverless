################################################################################
# Hosting
################################################################################
resource "aws_s3_bucket" "hosting" {
  bucket = "${var.service_name}-${var.environment_identifier}-s3-hosting"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-hosting"
  }
}

resource "aws_s3_bucket_public_access_block" "hosting" {
  bucket = aws_s3_bucket.hosting.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "hosting" {
  bucket = aws_s3_bucket.hosting.id
  policy = data.aws_iam_policy_document.hosting.json
}

data "aws_iam_policy_document" "hosting" {
  statement {
    principals {
      type = "Service"
      identifiers = [
        "cloudfront.amazonaws.com"
      ]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.hosting.arn}/*",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values = [
        var.cloudfront_distribution_arn
      ]
    }
  }
}

resource "aws_s3_bucket_website_configuration" "hosting" {
  bucket = aws_s3_bucket.hosting.bucket

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404/index.html"
  }

  # routing_rule {
  #   condition {
  #     key_prefix_equals = "docs/"
  #   }
  #   redirect {
  #     replace_key_prefix_with = "documents/"
  #   }
  # }
}

################################################################################
# Log
################################################################################
resource "aws_s3_bucket" "cloudfront_log" {
  bucket = "${var.service_name}-${var.environment_identifier}-s3-cloudfront-log"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-cloudfront_log"
  }
}

resource "aws_s3_bucket" "hosting_log" {
  bucket = "${var.service_name}-${var.environment_identifier}-s3-hosting-log"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-hosting-log"
  }
}

resource "aws_s3_bucket_logging" "hosting_log" {
  bucket = aws_s3_bucket.hosting.id

  target_bucket = aws_s3_bucket.hosting_log.id
  target_prefix = "log/"
}

################################################################################
# CodePipeline Artifact
################################################################################
data "aws_iam_policy_document" "artifact" {
  statement {
    principals {
      type = "AWS"
      identifiers = [
        var.iam_role_codebuild_arn,
        var.iam_role_codepipeline_arn
      ]
    }

    actions = [
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.artifact.arn,
      "${aws_s3_bucket.artifact.arn}/*",
    ]
  }

  statement {
    principals {
      type = "AWS"
      identifiers = [
        var.iam_role_codebuild_arn,
        var.iam_role_codepipeline_arn
      ]
    }

    actions = [
      "s3:Get*",
      "s3:Put*"
    ]

    resources = [
      "${aws_s3_bucket.artifact.arn}/*",
    ]
  }
}

resource "aws_s3_bucket" "artifact" {
  bucket = "${var.service_name}-${var.environment_identifier}-s3-artifact"

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-artifact"
  }
}

resource "aws_s3_bucket_public_access_block" "artifact" {
  bucket = aws_s3_bucket.artifact.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "artifact" {
  bucket = aws_s3_bucket.artifact.bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "artifact" {
  bucket = aws_s3_bucket.artifact.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "artifact" {
  bucket = aws_s3_bucket.artifact.id
  policy = data.aws_iam_policy_document.artifact.json
}
