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
  description = "Then run time version for CodeBuild."
  type        = string
  default     = ""
}

variable "iam_role_codebuild_arn" {
  description = "Amazon Resource Name (ARN) specifying the role."
  type        = string
  default     = ""
}

variable "dynamodb_table_survey_arn" {
  description = "ARN of the ddb table for survey"
  type        = string
  default     = ""
}

variable "dynamodb_table_question_arn" {
  description = "ARN of the ddb table for question"
  type        = string
  default     = ""
}

variable "dynamodb_table_result_arn" {
  description = "ARN of the ddb table for result"
  type        = string
  default     = ""
}
