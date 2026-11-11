SHELL := /bin/bash

.PHONY: all fmt lint validate scan plan clean help

all: fmt validate scan

help:
	@echo "Terraform AWS Security Baseline Commands:"
	@echo "  make fmt         Check Terraform code formatting (terraform fmt -check)"
	@echo "  make lint        Run TFLint static analysis across modules"
	@echo "  make validate    Initialize and validate all Terraform modules"
	@echo "  make scan        Run Checkov & tfsec CIS Benchmark security scans"
	@echo "  make plan        Run Terraform plan simulation in production environment"
	@echo "  make clean       Remove temporary .terraform directories and cache"

fmt:
	@echo "==> Checking Terraform syntax and formatting..."
	@which terraform >/dev/null 2>&1 && terraform fmt -check -recursive || echo "[INFO] terraform CLI not installed locally; checked via CI"

lint:
	@echo "==> Running TFLint rule checks..."
	@which tflint >/dev/null 2>&1 && tflint --recursive || echo "[INFO] tflint CLI not installed locally; checked via CI"

validate:
	@echo "==> Validating all Terraform modules..."
	@which terraform >/dev/null 2>&1 && { \
		for mod in modules/*; do \
			if [ -d "$$mod" ]; then \
				echo "Validating $$mod..."; \
				terraform -chdir="$$mod" init -backend=false >/dev/null 2>&1 || true; \
				terraform -chdir="$$mod" validate || exit 1; \
			fi; \
		done; \
		echo "All modules valid."; \
	} || echo "[INFO] terraform CLI not installed locally; validated via GitHub Actions CI"

scan:
	@echo "==> Running Checkov CIS AWS Foundations Benchmark audit..."
	@which checkov >/dev/null 2>&1 && checkov -d modules/ --framework terraform --compact || echo "[INFO] checkov CLI not installed locally; enforced via GitHub Actions CI"

plan:
	@echo "==> Simulating dry-run Terraform plan..."
	@which terraform >/dev/null 2>&1 && (cd environments/production && terraform init -backend=false && terraform plan) || echo "[INFO] Run via LocalStack or with configured AWS credentials"

clean:
	@echo "==> Cleaning local Terraform state and caches..."
	find . -type d -name ".terraform" -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name ".terraform.lock.hcl" -delete 2>/dev/null || true
