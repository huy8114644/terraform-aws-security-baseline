resource "aws_s3_bucket" "audit" {
  bucket        = "${var.environment}-audit-logs-${var.account_id}"
  force_destroy = false

  tags = {
    Environment = var.environment
    Compliance  = "CIS-Benchmark-S3"
  }
}

# CIS Benchmark: Block all public access
resource "aws_s3_bucket_public_access_block" "audit" {
  bucket = aws_s3_bucket.audit.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CIS Benchmark: Require versioning
resource "aws_s3_bucket_versioning" "audit" {
  bucket = aws_s3_bucket.audit.id
  versioning_configuration {
    status = "Enabled"
  }
}

# CIS Benchmark: KMS Server-Side Encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "audit" {
  bucket = aws_s3_bucket.audit.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

