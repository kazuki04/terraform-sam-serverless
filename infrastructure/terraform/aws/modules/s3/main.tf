################################################################################
# Hosting
################################################################################
resource "aws_s3_bucket" "hosting" {
  bucket        = "${var.service_name}-${var.environment_identifier}-s3-hosting"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-hosting"
  }
}

resource "aws_s3_bucket_policy" "hosting" {
  bucket = aws_s3_bucket.hosting.id
  policy = data.aws_iam_policy_document.hosting.json
}

data "aws_iam_policy_document" "hosting" {
  statement {
    sid = "PublicReadGetObject"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::${aws_s3_bucket.hosting.id}/*",
    ]
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
