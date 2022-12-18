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
