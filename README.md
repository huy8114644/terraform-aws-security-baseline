# Terraform AWS Security Baseline (CIS Benchmark 3.0)

[![Terraform Security Scan](https://github.com/huy8114644/terraform-aws-security-baseline/actions/workflows/tf-security-scan.yml/badge.svg)](https://github.com/huy8114644/terraform-aws-security-baseline/actions/workflows/tf-security-scan.yml)
[![CIS AWS Benchmark v3.0](https://img.shields.io/badge/CIS%20Benchmark-v3.0.0%20Compliant-success.svg)](https://www.cisecurity.org/benchmark/amazon_web_services)
[![Checkov: Verified](https://img.shields.io/badge/Checkov-Passed-blue.svg)](https://checkov.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

Production-grade **Terraform / OpenTofu Modules for AWS** engineered for strict compliance with the **CIS AWS Foundations Benchmark v3.0.0**, validated automatically via Checkov, tfsec, and tflint in CI/CD.

---

## 🏛️ Hardened Infrastructure Modules

### 1. Hardened VPC Module (`modules/vpc/`)
- **VPC Flow Logs:** Enabled for all traffic, streaming directly to encrypted CloudWatch Log Groups.
- **Subnet Tiering:** Isolated database tiers with zero Internet Gateway egress.
- **VPC Endpoints:** S3 and DynamoDB gateway endpoints enabled to prevent traffic from leaving the AWS private backbone.

### 2. Hardened EKS Cluster (`modules/eks/`)
- **Private API Endpoint:** `endpoint_public_access = false` with private Bastion / VPN access only.
- **KMS Envelope Encryption:** All Kubernetes secrets are encrypted at rest using dedicated Customer Managed Keys (CMK).
- **Cluster Logging:** API server, audit logs, and authenticator logs streamed to CloudWatch with retention policies.

### 3. Secure S3 Bucket Baseline (`modules/s3/`)
- **Block Public Access:** All 4 public access block settings enforced globally.
- **Encryption:** Server-Side Encryption with Customer Managed KMS Keys (SSE-KMS).
- **Audit & Versioning:** Object versioning enabled with S3 Server Access Logging.

---

## 🔒 Automated CI/CD Compliance Gates

Every Pull Request runs automated security scans:
- **Checkov:** Scans 200+ security policies across AWS IAM, S3, EKS, and VPC.
- **tfsec:** Secondary rule validation for misconfigurations.
- **SARIF Upload:** All security results are posted directly into GitHub Code Scanning.

---

## 📄 License
This project is licensed under the MIT License.

