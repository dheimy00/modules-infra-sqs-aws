# Main SQS Queue
resource "aws_sqs_queue" "main" {
  name                       = "${var.queue_name}-sqs"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  delay_seconds              = var.delay_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  kms_master_key_id          = var.kms_key_id
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = var.max_receive_count
  })

  tags = merge(
    var.tags,
    {
      Name    = "${var.queue_name}-sqs"
      Project = var.project_name
    }
  )
}

# Dead Letter Queue (DLQ)
resource "aws_sqs_queue" "dlq" {
  name                       = "${var.queue_name}-dlq"
  visibility_timeout_seconds = var.visibility_timeout_seconds
  message_retention_seconds  = var.dlq_message_retention_seconds
  kms_master_key_id          = var.kms_key_id
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled

  tags = merge(
    var.tags,
    {
      Name    = "${var.queue_name}-dlq"
      Project = var.project_name
    }
  )
}

# Queue Policy
resource "aws_sqs_queue_policy" "main" {
  queue_url = aws_sqs_queue.main.id
  policy    = var.queue_policy != null ? var.queue_policy : data.aws_iam_policy_document.sqs_policy.json
}

# Default IAM Policy Document
data "aws_iam_policy_document" "sqs_policy" {
  statement {
    effect    = "Allow"
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.main.arn]
    principals {
      type        = "Service"
      identifiers = ["*"]
    }
  }
} 