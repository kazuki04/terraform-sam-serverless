terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.45.0"
    }
  }
}

resource "aws_wafv2_web_acl" "ip_restriction" {
  name        = "${var.service_name}-${var.environment_identifier}-waf-ip-restriction"
  description = "This rule blocks requests from all IPs except the specific IPs."
  scope       = "CLOUDFRONT"

  default_action {
    block {}
  }

  rule {
    name     = "allow-specific-ipv4-ips"
    priority = 1

    action {
      allow {}
    }

    statement {
      ip_set_reference_statement {
        arn = aws_wafv2_ip_set.ipv4.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.service_name}-${var.environment_identifier}-waf-ip-restriction-ipv4"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-waf-ip-restriction"
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.service_name}-${var.environment_identifier}-waf-ip-restriction"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_ip_set" "ipv4" {
  name               = "${var.service_name}-${var.environment_identifier}-waf-ipset-v4"
  description        = "IP set for IPV4"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = []

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-waf-ipset-v4"
  }
}
