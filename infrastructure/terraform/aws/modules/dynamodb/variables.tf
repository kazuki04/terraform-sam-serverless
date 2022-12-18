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

variable "ddb_survey_table_attributes" {
  description = "The attributes for survey ddb table."
  type        = list(map(string))
  default     = ""
}

variable "ddb_question_table_attributes" {
  description = "The attributes for question ddb table."
  type        = list(map(string))
  default     = ""
}

variable "ddb_result_table_attributes" {
  description = "The attributes for result ddb table."
  type        = list(map(string))
  default     = ""
}
