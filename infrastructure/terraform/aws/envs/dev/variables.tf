################################################################################
# Common
################################################################################
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

variable "region" {
  description = "The region for AWS services."
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "The name of repository."
  type        = string
  default     = ""
}

################################################################################
# CloudFront
################################################################################
variable "default_root_object" {
  description = "The defalut root object."
  type        = string
  default     = ""
}

variable "viewer_certificate" {
  description = "The SSL configuration for this distribution (maximum one)."
  type        = map(any)
  default     = {}
}

################################################################################
# CodeBuild
################################################################################
variable "build_timeout" {
  description = " Number of minutes, from 5 to 480 (8 hours), for AWS CodeBuild to wait until timing out any related build that does not get marked as completed. The default is 60 minutes."
  type        = string
  default     = ""
}

variable "frontend_app_name" {
  description = "The name of frontend app"
  type        = string
  default     = ""
}

variable "runtime_version_for_frontend" {
  description = "Then run time version for frontend."
  type        = string
  default     = ""
}

################################################################################
# DynamoDB
################################################################################
variable "ddb_question_table_attributes" {
  description = "The attributes for question ddb table."
  type        = string
  default     = ""
}

variable "ddb_result_table_attributes" {
  description = "The attributes for result ddb table."
  type        = string
  default     = ""
}
