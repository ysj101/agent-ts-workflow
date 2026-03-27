#!/usr/bin/env bash

set -euo pipefail

with_deps=false

if [[ "${1:-}" == "--with-deps" ]]; then
  with_deps=true
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "npm is required to install agent-browser." >&2
  exit 1
fi

echo "Installing agent-browser globally..."
npm install -g agent-browser

echo "Installing agent-browser runtime..."
agent-browser install

if [[ "$with_deps" == "true" ]]; then
  echo "Installing agent-browser system dependencies..."
  agent-browser install --with-deps
fi

echo "Codex local tooling bootstrap completed."
