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

variable "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  type        = string
  default     = ""
}

variable "iam_role_codebuild_arn" {
  description = "The Amazon Resource Name (ARN) of the CodeBuild."
  type        = string
  default     = ""
}

variable "iam_role_codepipeline_arn" {
  description = "The Amazon Resource Name (ARN) of the CodePipelilne."
  type        = string
  default     = ""
}
