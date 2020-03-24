# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Make will use bash instead of sh
SHELL := /usr/bin/env bash

# The .PHONY directive tells make that this isn't a real target and so
# the presence of a file with that name won't cause this target to stop
.PHONY: test
test: ## Test constraint templates via OPA
	@echo "Running OPA tests..."
	@opa test --timeout 30s -v lib/ validator/ --explain=notes

.PHONY: debug
debug: ## Show debugging output from OPA
	@opa eval --data=lib/ --data=validator/ --format=pretty "data.validator.gcp"

.PHONY: build_templates
build_templates: ## Inline Rego rules into constraint templates
	@python3 scripts/inline_rego.py

.PHONY: format
format: ## Format Rego rules
	@opa fmt -w lib/ validator/

.PHONY: build
build: format build_templates ## Format and build

.PHONY: check_sample_files
check_sample_files: ## Make sure each template in policies/templates has one sample file using it in samples/
	@python3 scripts/check_samples.py

.PHONY: check_format
check_format: ## Check that files have been formatted using opa fmt
	@test $$(opa fmt -l lib/ validator/ | wc -l) -eq '0'

.PHONY: audit
audit: ## Run audit against real CAI dump data
	@echo "Running config-validator audit ..."
	@bash scripts/cft.sh -o "$(ORG_ID)" -f "$(FOLDER_ID)" -p "$(PROJECT_ID)" -b "$(BUCKET_NAME)" -e "$(EXPORT)"

help: ## Prints help for targets with comments
	@grep -E '^[a-zA-Z._-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "make \033[36m%- 30s\033[0m %s\n", $$1, $$2}'


# Cloudbuild doesn't allow us to use the Dockerfile "ARG" feature so we have to
# template the dockerfile, expand for each version then build.
REGO_VERSIONS := v0.15.0 v0.16.0 v0.17.0
CI_IMAGES := $(foreach v,$(REGO_VERSIONS),ci-image-$v)
.PHONY: ci-images
ci-images: $(CI_IMAGES)

ci-image-%: build/rego-%/Dockerfile
	@cd $(dir $^) \
	&& gcloud builds submit --project=config-validator --tag gcr.io/config-validator/rego-$* .

build/rego-%/Dockerfile: cloudbuild/Dockerfile
	@mkdir -p $(dir $@)
	@sed -e 's/__REGO_VERSION__/$*/' $^ > $@
