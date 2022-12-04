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

variable "repository_name" {
  description = "The name of the repository."
  type        = string
  default     = ""
}

variable "kms_key_arn" {
  description = "The Amazon Resource Name (ARN) of the key."
  type        = string
  default     = ""
}

variable "s3_bucket_hosting_id" {
  description = "The name of the hosting bucket."
  type        = string
  default     = ""
}

variable "s3_bucket_artifact_id" {
  description = "The name of the artifact bucket."
  type        = string
  default     = ""
}

variable "iam_role_codepipeline_arn" {
  description = "The Amazon Resource Name (ARN) of role for CodePipelilne."
  type        = string
  default     = ""
}

variable "codebuild_project_frontend_arn" {
  description = "ARN of the frontend CodeBuild project."
  type        = string
  default     = ""
}
