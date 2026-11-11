SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := help

TERRAFORM ?= terraform
TFLINT ?= tflint
CHECKOV ?= checkov
TFSEC ?= tfsec
ROOT_DIR ?=
MODULES := modules/eks modules/guardduty modules/s3 modules/vpc modules/waf

.PHONY: help fmt lint validate test scan plan clean

help: ## Show local commands and prerequisites
	@echo 'Install Terraform >=1.6 <2, TFLint, Checkov and tfsec; see README.md.'
	@echo 'fmt       Check Terraform formatting (no writes)'
	@echo 'lint      Run formatting checks and TFLint on every module'
	@echo 'validate  Initialize without a backend and validate every module'
	@echo 'test      Run formatting and provider-schema validation (no AWS calls)'
	@echo 'scan      Run Checkov and tfsec; findings fail the target'
	@echo 'plan      Require ROOT_DIR=/path/to/your/root with .tf configuration and AWS access'
	@echo 'clean     Remove module provider caches; retain dependency lock files'

fmt:
	@command -v $(firstword $(TERRAFORM)) >/dev/null || { echo 'ERROR: Terraform is required' >&2; exit 127; }
	$(TERRAFORM) fmt -check -recursive

lint: fmt
	@command -v $(firstword $(TFLINT)) >/dev/null || { echo 'ERROR: TFLint is required' >&2; exit 127; }
	@for module in $(MODULES); do $(TFLINT) --chdir="$$module"; done

validate:
	@command -v $(firstword $(TERRAFORM)) >/dev/null || { echo 'ERROR: Terraform is required' >&2; exit 127; }
	@for module in $(MODULES); do \
		echo "Validating $$module"; \
		$(TERRAFORM) -chdir="$$module" init -backend=false -input=false; \
		$(TERRAFORM) -chdir="$$module" validate; \
	done

test: fmt validate

scan:
	@command -v $(firstword $(CHECKOV)) >/dev/null || { echo 'ERROR: Checkov is required' >&2; exit 127; }
	@command -v $(firstword $(TFSEC)) >/dev/null || { echo 'ERROR: tfsec is required' >&2; exit 127; }
	$(CHECKOV) -d modules --framework terraform --compact
	$(TFSEC) modules

plan:
	@test -n "$(ROOT_DIR)" || { echo 'ERROR: set ROOT_DIR to a configured deployment root; none is included' >&2; exit 2; }
	@test -d "$(ROOT_DIR)" && compgen -G "$(ROOT_DIR)/*.tf" >/dev/null || { echo 'ERROR: ROOT_DIR must contain Terraform configuration' >&2; exit 2; }
	@command -v $(firstword $(TERRAFORM)) >/dev/null || { echo 'ERROR: Terraform is required' >&2; exit 127; }
	$(TERRAFORM) -chdir="$(ROOT_DIR)" init -input=false
	$(TERRAFORM) -chdir="$(ROOT_DIR)" plan -input=false

clean:
	@for module in $(MODULES); do rm -rf "$$module/.terraform"; done
