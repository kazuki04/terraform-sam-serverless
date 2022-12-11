variable "service_name" {
  description = "The service name."
  type        = string
  default     = ""
}

variable "environment_identifier" {
  description = "The environment identifier."
  type        = string
  default     = ""
}

variable "default_root_object" {
  description = "The defalut root object."
  type        = string
  default     = ""
}

variable "s3_bucket_hosting_id" {
  description = "The name of the hosting bucket."
  type        = string
  default     = ""
}

variable "s3_bucket_cloudfront_log_id" {
  description = "The name of the CloudFront log bucket."
  type        = string
  default     = ""
}

variable "s3_bucket_hosting_bucket_regional_domain_name" {
  description = "The bucket region-specific domain name."
  type        = string
  default     = ""
}

variable "origin" {
  description = "One or more origins for this distribution (multiples allowed)."
  type        = any
  default     = null
}

variable "origin_group" {
  description = "One or more origin_group for this distribution (multiples allowed)."
  type        = any
  default     = {}
}

variable "custom_error_response" {
  description = "One or more custom error response elements"
  type        = any
  default     = {}
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution (maximum one)."
  type        = map(any)
  default     = {}
}

variable "geo_restriction" {
  description = "The restriction configuration for this distribution (geo_restrictions)"
  type        = any
  default     = {}
}
