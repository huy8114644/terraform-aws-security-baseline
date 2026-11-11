variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "prod"
}

variable "cluster_role_arn" {
  type        = string
  description = "IAM Role ARN for the EKS control plane"
  default     = "arn:aws:iam::123456789012:role/eks-cluster-role"
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for EKS cluster nodes"
  default     = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
}

variable "kms_key_arn" {
  type        = string
  description = "KMS Customer Managed Key ARN for envelope encryption of Kubernetes secrets"
  default     = "arn:aws:kms:us-east-1:123456789012:key/eks-envelope-key"
}
