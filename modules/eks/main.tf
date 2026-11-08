resource "aws_eks_cluster" "main" {
  name     = "${var.environment}-hardened-eks"
  role_arn = var.cluster_role_arn
  version  = "1.29"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false # CIS: Disable public API endpoint
  }

  # CIS Benchmark: KMS Envelope Encryption for Kubernetes Secrets
  encryption_config {
    provider {
      key_arn = var.kms_key_arn
    }
    resources = ["secrets"]
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  tags = {
    Environment = var.environment
    Compliance  = "CIS-EKS-Benchmark"
  }
}

