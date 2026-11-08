resource "aws_wafv2_web_acl" "main" {
  name        = "${var.environment}-enterprise-waf"
  description = "Enterprise WAF protecting ALB ingress with rate limiting & OWASP rules"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  # Rule 1: IP Rate Limiting (Anti-DDoS / Brute Force)
  rule {
    name     = "IPRateLimit"
    priority = 1

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 1000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.environment}WAFRateLimit"
      sampled_requests_enabled   = true
    }
  }

  # Rule 2: AWS Managed Core Rule Set
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.environment}WAFCommonRules"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.environment}MainWAFACL"
    sampled_requests_enabled   = true
  }

  tags = {
    Environment = var.environment
    Compliance  = "CIS-AWS-Benchmark-WAF"
  }
}
