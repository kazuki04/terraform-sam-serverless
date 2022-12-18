resource "aws_dynamodb_table" "survey" {
  name           = "${var.service_name}-${var.environment_identifier}-ddb-table-survey"
  billing_mode   = "PROVISIONED"
  hash_key       = "SurveyId"
  read_capacity  = 1
  write_capacity = 1
  table_class    = "STANDARD"

  dynamic "attribute" {
    for_each = var.survey_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-ddb-table-survey"
  }
}

resource "aws_dynamodb_table" "question" {
  name           = "${var.service_name}-${var.environment_identifier}-ddb-table-question"
  billing_mode   = "PROVISIONED"
  hash_key       = "QuestionId"
  read_capacity  = 1
  write_capacity = 1
  table_class    = "STANDARD"

  dynamic "attribute" {
    for_each = var.question_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-ddb-table-question"
  }
}

resource "aws_dynamodb_table" "result" {
  name           = "${var.service_name}-${var.environment_identifier}-ddb-table-result"
  billing_mode   = "PROVISIONED"
  hash_key       = "ResultId"
  read_capacity  = 1
  write_capacity = 1
  table_class    = "STANDARD"

  dynamic "attribute" {
    for_each = var.result_attributes

    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name = "${var.service_name}-${var.environment_identifier}-ddb-table-result"
  }
}
