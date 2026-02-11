#!/usr/bin/make

.PHONY: build-image help run-container test-container version

.DEFAULT_GOAL := test-container

PROJECT_NAME := gnur

help: ## Show this help message
	@echo Available targets:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

# Docker targets
build-image: ## Build the Docker image
	@docker build -t $(PROJECT_NAME) .

test-container: build-image ## Test the Docker image (sanity check)
	@docker run --rm $(PROJECT_NAME)

version: build-image ## Show container version
	@docker run --rm $(PROJECT_NAME) --version
