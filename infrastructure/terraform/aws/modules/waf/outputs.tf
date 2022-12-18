output "wafv2_web_acl_ip_restriction_arn" {
  description = "The ARN of the WAF WebACL."
  value       = aws_wafv2_web_acl.ip_restriction.arn
}
