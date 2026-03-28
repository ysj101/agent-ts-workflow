SHELL := /bin/bash

.PHONY: help bootstrap bootstrap-full deps setup-codex setup-codex-full build lint format format-check typecheck quality

help:
	@echo "Available targets:"
	@echo "  make bootstrap         Install npm/pnpm/codex if needed, install repo deps, and set up Codex tooling"
	@echo "  make bootstrap-full    Same as bootstrap, with agent-browser system dependencies"
	@echo "  make deps              Install repository dependencies with pnpm"
	@echo "  make setup-codex       Install npm/pnpm/codex if needed and set up Codex tooling"
	@echo "  make setup-codex-full  Same as setup-codex, with agent-browser system dependencies"
	@echo "  make build             Run the TypeScript build"
	@echo "  make lint              Run oxlint"
	@echo "  make format            Run Biome format"
	@echo "  make format-check      Run Biome check"
	@echo "  make typecheck         Run TypeScript typecheck"
	@echo "  make quality           Run the full quality gate"

bootstrap:
	./scripts/setup-codex-tooling.sh && pnpm install

bootstrap-full:
	./scripts/setup-codex-tooling.sh --with-deps && pnpm install

deps:
	pnpm install

setup-codex:
	./scripts/setup-codex-tooling.sh

setup-codex-full:
	./scripts/setup-codex-tooling.sh --with-deps

build:
	pnpm run build

lint:
	pnpm run lint

format:
	pnpm run format

format-check:
	pnpm run format:check

typecheck:
	pnpm run typecheck

quality:
	pnpm run quality
