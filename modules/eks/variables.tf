variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "prod"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM Role ARN for the EKS control plane"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Existing private subnet IDs for the EKS control plane across at least two availability zones"
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Customer Managed Key ARN for envelope encryption of Kubernetes secrets"
}
