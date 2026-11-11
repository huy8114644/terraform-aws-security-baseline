variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "prod"
}

variable "account_id" {
  type        = string
  description = "AWS Account ID for globally unique S3 bucket naming"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Customer Managed Key ARN for Server-Side Encryption (SSE-KMS)"
}
