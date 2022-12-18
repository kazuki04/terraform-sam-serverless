output "dynamodb_table_survey_arn" {
  description = "ARN of the ddb table for survey"
  value       = aws_dynamodb_table.survey.arn
}

output "dynamodb_table_question_arn" {
  description = "ARN of the ddb table for question"
  value       = aws_dynamodb_table.question.arn
}

output "dynamodb_table_result_arn" {
  description = "ARN of the ddb table for result"
  value       = aws_dynamodb_table.result.arn
}
