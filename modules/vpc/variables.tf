variable "cidr_block" {
  type        = string
  description = "The CIDR block for the hardened VPC"
  default     = "10.0.0.0/16"
}

variable "environment" {
  type        = string
  description = "Target deployment environment (e.g., prod, staging)"
  default     = "prod"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Customer Managed Key ARN for VPC Flow Logs CloudWatch encryption"
}
