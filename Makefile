#!/usr/bin/make

.PHONY: build-image clean help run-container test-container version

.DEFAULT_GOAL := test-container

PROJECT_NAME := gnur
R_VERSION := 4.5.2

help: ## Show this help message
	@echo Available targets:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

# Docker targets
build-image: ## Build the Docker image
	@docker build --build-arg R_VERSION=$(R_VERSION) -t $(PROJECT_NAME):$(R_VERSION) .
	@docker tag $(PROJECT_NAME):$(R_VERSION) $(PROJECT_NAME):latest

test-container: build-image ## Test the Docker image (sanity check)
	@mkdir -p public
	@docker run --rm -v $(PWD):/workspace $(PROJECT_NAME):latest make.R test.Rmd public/test.html

version: build-image ## Show container version
	@docker run --rm $(PROJECT_NAME) --version

clean: ## Remove generated files
	@rm -rf public
