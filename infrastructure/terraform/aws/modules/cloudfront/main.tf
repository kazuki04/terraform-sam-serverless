locals {
  origin = [
    {
      domain_name              = var.s3_bucket_hosting_bucket_regional_domain_name
      origin_id                = var.s3_bucket_hosting_id
      origin_access_control_id = aws_cloudfront_origin_access_control.hosting.id
    }
  ]

  default_cache_behavior = {
    target_origin_id         = var.s3_bucket_hosting_id
    viewer_protocol_policy   = "redirect-to-https"
    allowed_methods          = ["GET", "HEAD"]
    cached_methods           = ["GET", "HEAD"]
    compress                 = true
    cache_policy_id          = aws_cloudfront_cache_policy.hosting.id
    origin_request_policy_id = aws_cloudfront_origin_request_policy.hosting.id
  }
}

resource "aws_cloudfront_distribution" "this" {
  comment             = "${var.service_name}-${var.environment_identifier}-cloudfront"
  default_root_object = var.default_root_object
  enabled             = true
  http_version        = "http2"
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = true
  # web_acl_id          = var.web_acl_id

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-cloudfront"
  }

  logging_config {
    bucket          = var.s3_bucket_cloudfront_log_id
    prefix          = "${var.service_name}-${var.environment_identifier}"
    include_cookies = false
  }

  dynamic "origin" {
    for_each = var.origin

    content {
      domain_name              = origin.value.domain_name
      origin_id                = lookup(origin.value, "origin_id", origin.key)
      origin_path              = lookup(origin.value, "origin_path", "")
      connection_attempts      = lookup(origin.value, "connection_attempts", null)
      connection_timeout       = lookup(origin.value, "connection_timeout", null)
      origin_access_control_id = lookup(origin.value, "origin_access_control_id", null)

      dynamic "origin_shield" {
        for_each = length(keys(lookup(origin.value, "origin_shield", {}))) == 0 ? [] : [lookup(origin.value, "origin_shield", {})]

        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }
    }
  }

  dynamic "default_cache_behavior" {
    for_each = [local.default_cache_behavior]
    iterator = i

    content {
      target_origin_id       = i.value["target_origin_id"]
      viewer_protocol_policy = i.value["viewer_protocol_policy"]

      allowed_methods           = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
      cached_methods            = lookup(i.value, "cached_methods", ["GET", "HEAD"])
      compress                  = lookup(i.value, "compress", null)
      field_level_encryption_id = lookup(i.value, "field_level_encryption_id", null)
      smooth_streaming          = lookup(i.value, "smooth_streaming", null)
      trusted_signers           = lookup(i.value, "trusted_signers", null)
      trusted_key_groups        = lookup(i.value, "trusted_key_groups", null)

      cache_policy_id            = lookup(i.value, "cache_policy_id", null)
      origin_request_policy_id   = lookup(i.value, "origin_request_policy_id", null)
      response_headers_policy_id = lookup(i.value, "response_headers_policy_id", null)
      realtime_log_config_arn    = lookup(i.value, "realtime_log_config_arn", null)

      min_ttl     = lookup(i.value, "min_ttl", null)
      default_ttl = lookup(i.value, "default_ttl", null)
      max_ttl     = lookup(i.value, "max_ttl", null)

      dynamic "forwarded_values" {
        for_each = lookup(i.value, "use_forwarded_values", true) ? [true] : []

        content {
          query_string            = lookup(i.value, "query_string", false)
          query_string_cache_keys = lookup(i.value, "query_string_cache_keys", [])
          headers                 = lookup(i.value, "headers", [])

          cookies {
            forward           = lookup(i.value, "cookies_forward", "none")
            whitelisted_names = lookup(i.value, "cookies_whitelisted_names", null)
          }
        }
      }

      dynamic "lambda_function_association" {
        for_each = lookup(i.value, "lambda_function_association", [])
        iterator = l

        content {
          event_type   = l.key
          lambda_arn   = l.value.lambda_arn
          include_body = lookup(l.value, "include_body", null)
        }
      }

      dynamic "function_association" {
        for_each = lookup(i.value, "function_association", [])
        iterator = f

        content {
          event_type   = f.key
          function_arn = f.value.function_arn
        }
      }
    }
  }

  # dynamic "ordered_cache_behavior" {
  #   for_each = var.ordered_cache_behavior
  #   iterator = i

  #   content {
  #     path_pattern           = i.value["path_pattern"]
  #     target_origin_id       = i.value["target_origin_id"]
  #     viewer_protocol_policy = i.value["viewer_protocol_policy"]

  #     allowed_methods           = lookup(i.value, "allowed_methods", ["GET", "HEAD", "OPTIONS"])
  #     cached_methods            = lookup(i.value, "cached_methods", ["GET", "HEAD"])
  #     compress                  = lookup(i.value, "compress", null)
  #     field_level_encryption_id = lookup(i.value, "field_level_encryption_id", null)
  #     smooth_streaming          = lookup(i.value, "smooth_streaming", null)
  #     trusted_signers           = lookup(i.value, "trusted_signers", null)
  #     trusted_key_groups        = lookup(i.value, "trusted_key_groups", null)

  #     cache_policy_id            = lookup(i.value, "cache_policy_id", null)
  #     origin_request_policy_id   = lookup(i.value, "origin_request_policy_id", null)
  #     response_headers_policy_id = lookup(i.value, "response_headers_policy_id", null)
  #     realtime_log_config_arn    = lookup(i.value, "realtime_log_config_arn", null)

  #     min_ttl     = lookup(i.value, "min_ttl", null)
  #     default_ttl = lookup(i.value, "default_ttl", null)
  #     max_ttl     = lookup(i.value, "max_ttl", null)

  #     dynamic "forwarded_values" {
  #       for_each = lookup(i.value, "use_forwarded_values", true) ? [true] : []

  #       content {
  #         query_string            = lookup(i.value, "query_string", false)
  #         query_string_cache_keys = lookup(i.value, "query_string_cache_keys", [])
  #         headers                 = lookup(i.value, "headers", [])

  #         cookies {
  #           forward           = lookup(i.value, "cookies_forward", "none")
  #           whitelisted_names = lookup(i.value, "cookies_whitelisted_names", null)
  #         }
  #       }
  #     }

  #     dynamic "lambda_function_association" {
  #       for_each = lookup(i.value, "lambda_function_association", [])
  #       iterator = l

  #       content {
  #         event_type   = l.key
  #         lambda_arn   = l.value.lambda_arn
  #         include_body = lookup(l.value, "include_body", null)
  #       }
  #     }

  #     dynamic "function_association" {
  #       for_each = lookup(i.value, "function_association", [])
  #       iterator = f

  #       content {
  #         event_type   = f.key
  #         function_arn = f.value.function_arn
  #       }
  #     }
  #   }
  # }

  viewer_certificate {
    acm_certificate_arn            = lookup(var.viewer_certificate, "acm_certificate_arn", null)
    cloudfront_default_certificate = lookup(var.viewer_certificate, "cloudfront_default_certificate", null)
    iam_certificate_id             = lookup(var.viewer_certificate, "iam_certificate_id", null)

    minimum_protocol_version = lookup(var.viewer_certificate, "minimum_protocol_version", "TLSv1")
    ssl_support_method       = lookup(var.viewer_certificate, "ssl_support_method", null)
  }

  dynamic "custom_error_response" {
    for_each = length(flatten([var.custom_error_response])[0]) > 0 ? flatten([var.custom_error_response]) : []

    content {
      error_code = custom_error_response.value["error_code"]

      response_code         = lookup(custom_error_response.value, "response_code", null)
      response_page_path    = lookup(custom_error_response.value, "response_page_path", null)
      error_caching_min_ttl = lookup(custom_error_response.value, "error_caching_min_ttl", null)
    }
  }

  restrictions {
    dynamic "geo_restriction" {
      for_each = [var.geo_restriction]

      content {
        restriction_type = lookup(geo_restriction.value, "restriction_type", "none")
        locations        = lookup(geo_restriction.value, "locations", [])
      }
    }
  }
}

resource "aws_cloudfront_origin_access_control" "hosting" {
  name                              = "${var.service_name}-${var.environment_identifier}-cloudfront-oac"
  description                       = "The OAC for ${var.service_name} in ${var.environment_identifier}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_cache_policy" "hosting" {
  name        = "${var.service_name}-${var.environment_identifier}-cloudfront-cache-policy-hosting"
  comment     = "The cache policy for ${var.service_name} in ${var.environment_identifier}."
  default_ttl = 3600
  max_ttl     = 86400
  min_ttl     = 1
  parameters_in_cache_key_and_forwarded_to_origin {
    cookies_config {
      cookie_behavior = "none"
    }
    headers_config {
      header_behavior = "none"
    }
    query_strings_config {
      query_string_behavior = "none"
    }
  }
}

resource "aws_cloudfront_origin_request_policy" "hosting" {
  name    = "${var.service_name}-${var.environment_identifier}-cloudfront-cache-policy-hosting"
  comment = "The origin request policy for ${var.service_name} in ${var.environment_identifier}."
  cookies_config {
    cookie_behavior = "none"
  }
  headers_config {
    header_behavior = "whitelist"
    headers {
      items = [
        "Origin",
        "Access-Control-Request-Headers",
        "Access-Control-Request-Method",
      ]
    }
  }
  query_strings_config {
    query_string_behavior = "none"
  }
}

resource "aws_cloudfront_response_headers_policy" "cors_security_header" {
  name    = "${var.service_name}-${var.environment_identifier}-cloudfront-response-header-policy-hosting"
  comment = "The response header policy for ${var.service_name} in ${var.environment_identifier}."

  cors_config {
    access_control_allow_credentials = true

    access_control_allow_headers {
      items = []
    }

    access_control_allow_methods {
      items = ["GET"]
    }

    access_control_allow_origins {
      items = [
        aws_cloudfront_distribution.this.domain_name
      ]
    }

    origin_override = true
  }

  security_headers_config {
    content_security_policy {
      override = true
      content_security_policy = (
        "default-src 'none'; script-src 'self'; connect-src 'self'; img-src 'self'; style-src 'self'; frame-ancestors 'self'; form-action 'self';"
      )
    }

    content_type_options {
      override = true
    }

    frame_options {
      override     = true
      frame_option = "DENY"
    }

    referrer_policy {
      override        = true
      referrer_policy = "strict-origin-when-cross-origin"
    }

    strict_transport_security {
      override                   = true
      access_control_max_age_sec = 63072000
      include_subdomains         = true
      preload                    = true
    }

    xss_protection {
      override   = true
      mode_block = true
      protection = true
    }
  }
}
