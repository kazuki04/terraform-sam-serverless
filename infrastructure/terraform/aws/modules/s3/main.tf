################################################################################
# Hosting
################################################################################
resource "aws_s3_bucket" "hosting" {
  bucket        = "${var.service_name}-${var.environment_identifier}-s3-hosting"

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-s3-hosting"
  }
}

# resource "aws_s3_bucket_policy" "hosting" {
#   bucket = aws_s3_bucket.hosting.id
#   policy = data.aws_iam_policy_document.combined[0].json
# }

# data "aws_iam_policy_document" "combined" {
#   source_policy_documents = compact([
#     var.attach_elb_log_delivery_policy ? data.aws_iam_policy_document.elb_log_delivery[0].json : "",
#     var.attach_lb_log_delivery_policy ? data.aws_iam_policy_document.lb_log_delivery[0].json : "",
#     var.attach_require_latest_tls_policy ? data.aws_iam_policy_document.require_latest_tls[0].json : "",
#     var.attach_deny_insecure_transport_policy ? data.aws_iam_policy_document.deny_insecure_transport[0].json : "",
#     var.attach_inventory_destination_policy ? data.aws_iam_policy_document.inventory_destination_policy[0].json : "",
#     var.attach_policy ? var.policy : ""
#   ])
# }

resource "aws_s3_bucket_website_configuration" "example" {
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
