SHELL := /bin/bash

.PHONY: help bootstrap bootstrap-full deps setup-codex setup-claude build lint format format-check typecheck quality

help:
	@echo "Available targets:"
	@echo "  make bootstrap         Install shared tooling (npm, pnpm, repo deps, agent-browser runtime)"
	@echo "  make bootstrap-full    Same as bootstrap, with agent-browser system dependencies"
	@echo "  make deps              Install repository dependencies with pnpm"
	@echo "  make setup-codex       Install the Codex CLI and Codex-specific skills"
	@echo "  make setup-claude      Install the Claude Code CLI"
	@echo "  make build             Run the TypeScript build"
	@echo "  make lint              Run oxlint"
	@echo "  make format            Run Biome format"
	@echo "  make format-check      Run Biome check"
	@echo "  make typecheck         Run TypeScript typecheck"
	@echo "  make quality           Run the full quality gate"

bootstrap:
	./scripts/setup-agent-tooling.sh bootstrap

bootstrap-full:
	./scripts/setup-agent-tooling.sh bootstrap --with-deps

deps:
	pnpm install

setup-codex:
	./scripts/setup-agent-tooling.sh setup codex

setup-claude:
	./scripts/setup-agent-tooling.sh setup claude

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
