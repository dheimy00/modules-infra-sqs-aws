output "main_queue_arn" {
  description = "The ARN of the main SQS queue"
  value       = aws_sqs_queue.main.arn
}

output "main_queue_url" {
  description = "The URL of the main SQS queue"
  value       = aws_sqs_queue.main.id
}

output "main_queue_name" {
  description = "The name of the main SQS queue"
  value       = aws_sqs_queue.main.name
}

output "dlq_arn" {
  description = "The ARN of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.arn
}

output "dlq_url" {
  description = "The URL of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.id
}

output "dlq_name" {
  description = "The name of the Dead Letter Queue"
  value       = aws_sqs_queue.dlq.name
} 