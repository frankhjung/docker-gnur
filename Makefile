#!/usr/bin/make

.PHONY: build-image clean help run-container test-container version

.DEFAULT_GOAL := test-container

PROJECT_NAME := gnur
R_VERSION := $(shell awk -F= '/^ARG R_VERSION=/{print $$2; exit}' Dockerfile)
DOCKER ?= docker

help: ## Show this help message
	@echo Available targets:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  %-15s %s\n", $$1, $$2}'

build-image: ## Build the Docker image
	@$(DOCKER) build --build-arg R_VERSION=$(R_VERSION) -t $(PROJECT_NAME):$(R_VERSION) .
	@$(DOCKER) tag $(PROJECT_NAME):$(R_VERSION) $(PROJECT_NAME):latest

test-container: build-image ## Test the Docker image (sanity check)
	@mkdir -p public
	@$(DOCKER) run --rm -v $(PWD):/workspace $(PROJECT_NAME):latest make.R test.Rmd public/test.html

images: ## List local images for this project
	@$(DOCKER) image ls $(PROJECT_NAME)

doctor: ## Show Docker context, builder, and project images
	@echo "== Docker context =="
	@$(DOCKER) context show
	@echo
	@echo "== Docker contexts =="
	@$(DOCKER) context ls
	@echo
	@echo "== Buildx builders =="
	@$(DOCKER) buildx ls
	@echo
	@echo "== Project images =="
	@$(DOCKER) image ls $(PROJECT_NAME)

version: build-image ## Show container version
	@$(DOCKER) run --rm $(PROJECT_NAME) --version

clean: ## Remove generated files
	@$(RM) -rf public
