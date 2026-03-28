#!/usr/bin/env bash

set -euo pipefail

PNPM_VERSION="10.30.2"
CODEX_PACKAGE="@openai/codex"
with_deps=false

if [[ "${1:-}" == "--with-deps" ]]; then
  with_deps=true
fi

has_cmd() {
  command -v "$1" >/dev/null 2>&1
}

run_with_sudo() {
  if [[ "$(id -u)" -eq 0 ]]; then
    "$@"
    return
  fi

  if has_cmd sudo; then
    sudo "$@"
    return
  fi

  echo "This step requires elevated privileges, but sudo is not available." >&2
  exit 1
}

ensure_npm() {
  if has_cmd npm; then
    return
  fi

  echo "npm not found. Installing Node.js and npm..."

  if has_cmd brew; then
    brew install node
  elif has_cmd apt-get; then
    run_with_sudo apt-get update
    run_with_sudo apt-get install -y nodejs npm
  elif has_cmd dnf; then
    run_with_sudo dnf install -y nodejs npm
  elif has_cmd yum; then
    run_with_sudo yum install -y nodejs npm
  elif has_cmd pacman; then
    run_with_sudo pacman -Sy --noconfirm nodejs npm
  else
    echo "Unable to install npm automatically. Install Node.js manually, then rerun this script." >&2
    exit 1
  fi

  if ! has_cmd npm; then
    echo "npm installation did not succeed." >&2
    exit 1
  fi
}

ensure_pnpm() {
  if has_cmd pnpm; then
    return
  fi

  echo "pnpm not found. Installing pnpm@${PNPM_VERSION}..."

  if has_cmd corepack; then
    corepack enable
    corepack prepare "pnpm@${PNPM_VERSION}" --activate
  else
    npm install -g "pnpm@${PNPM_VERSION}"
  fi

  if ! has_cmd pnpm; then
    echo "pnpm installation did not succeed." >&2
    exit 1
  fi
}

ensure_codex() {
  if has_cmd codex; then
    return
  fi

  echo "codex not found. Installing ${CODEX_PACKAGE}..."
  npm install -g "${CODEX_PACKAGE}"

  if ! has_cmd codex; then
    echo "codex installation did not succeed." >&2
    exit 1
  fi
}

ensure_npm
ensure_pnpm
ensure_codex

echo "Installing agent-browser globally..."
npm install -g agent-browser

echo "Installing agent-browser runtime..."
agent-browser install

if [[ "$with_deps" == "true" ]]; then
  echo "Installing agent-browser system dependencies..."
  agent-browser install --with-deps
fi

echo "Codex local tooling bootstrap completed."
