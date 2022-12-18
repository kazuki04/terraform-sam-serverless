data "aws_caller_identity" "current" {}

resource "aws_kms_key" "this" {
  description  = "KMS key for ${var.service_name} in ${var.environment_identifier}"
  policy       = data.aws_iam_policy_document.kms.json

}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.service_name}-${var.environment_identifier}-kms"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "kms" {
  statement {
    sid = "Enable IAM User Permissions"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "kms:*",
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = "Allow CloudFront to use the key to deliver logs"

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    actions = [
      "kms:GenerateDataKey*",
    ]

    resources = [
      "*"
    ]
  }
}
