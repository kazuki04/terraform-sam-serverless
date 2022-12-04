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
