# AWS SQS Terraform Module

This Terraform module creates an AWS SQS (Simple Queue Service) queue with a Dead Letter Queue (DLQ) and configurable settings.

## Features

- Creates a main SQS queue with configurable settings
- Creates a Dead Letter Queue (DLQ) for failed message handling
- Configurable queue policies
- Server-side encryption support
- Customizable message retention and visibility timeout
- Tagging support

## Usage

```hcl
module "my_sqs_queue" {
  source = "./modules/modules-infra-sqs-aws"

  # Required parameters
  queue_name   = "my-application"
  project_name = "my-project"

  # Optional parameters
  visibility_timeout_seconds = 60
  message_retention_seconds  = 345600  # 4 days
  max_message_size          = 131072   # 128 KB
  delay_seconds             = 30
  receive_wait_time_seconds = 20
  max_receive_count        = 3

  # Enable SSE with SQS managed keys
  sqs_managed_sse_enabled = true

  # Optional: Custom queue policy
  queue_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "sns.amazonaws.com"
        }
        Action = "sqs:SendMessage"
        Resource = "arn:aws:sqs:*:*:my-application-sqs"
        Condition = {
          ArnLike = {
            "aws:SourceArn": "arn:aws:sns:*:*:my-topic"
          }
        }
      }
    ]
  })

  # Optional: Custom tags
  tags = {
    Environment = "production"
    Owner       = "DevOps"
    Service     = "MessageQueue"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region to deploy the SQS queues | `string` | `"us-east-1"` | no |
| queue_name | The name of the SQS queue | `string` | n/a | yes |
| project_name | The name of the project | `string` | n/a | yes |
| visibility_timeout_seconds | The visibility timeout for the queue | `number` | `30` | no |
| message_retention_seconds | The number of seconds Amazon SQS retains a message | `number` | `86400` | no |
| dlq_message_retention_seconds | The number of seconds Amazon SQS retains a message in the DLQ | `number` | `1209600` | no |
| max_message_size | The limit of how many bytes a message can contain | `number` | `262144` | no |
| delay_seconds | The time in seconds that the delivery of all messages in the queue will be delayed | `number` | `0` | no |
| receive_wait_time_seconds | The time for which a ReceiveMessage call will wait for a message to arrive | `number` | `10` | no |
| max_receive_count | The number of times a message is delivered to the source queue before being moved to the dead-letter queue | `number` | `5` | no |
| kms_key_id | The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK | `string` | `null` | no |
| sqs_managed_sse_enabled | Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys | `bool` | `true` | no |
| queue_policy | The JSON policy for the SQS queue. Overrides the default policy if provided | `string` | `null` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| main_queue_url | The URL of the created main SQS queue |
| dlq_url | The URL of the created Dead Letter Queue |
| main_queue_arn | The ARN of the created main SQS queue |
| dlq_arn | The ARN of the created Dead Letter Queue |
| main_queue_name | The name of the created main SQS queue |
| dlq_name | The name of the created Dead Letter Queue |

## Default Values

- Visibility Timeout: 30 seconds
- Message Retention: 1 day (86400 seconds)
- DLQ Message Retention: 14 days (1209600 seconds)
- Max Message Size: 256 KB (262144 bytes)
- Delay Seconds: 0
- Receive Wait Time: 10 seconds
- Max Receive Count: 5
- SSE Enabled: true

## Default Queue Policy

If no custom queue policy is provided, the module creates a default policy that allows the `sqs:SendMessage` action from any service principal.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| aws | >= 3.0 |

## License

This module is released under the MIT License.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request 