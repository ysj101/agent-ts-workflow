#!/usr/bin/env bash

set -euo pipefail

PNPM_VERSION="10.30.2"
CODEX_PACKAGE="@openai/codex"
CLAUDE_PACKAGE="@anthropic-ai/claude-code"
SKILLS_PACKAGE="skills@latest"

usage() {
  cat <<'EOF'
Usage:
  ./scripts/setup-agent-tooling.sh bootstrap [--with-deps]
  ./scripts/setup-agent-tooling.sh setup codex
  ./scripts/setup-agent-tooling.sh setup claude
EOF
}

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

ensure_claude() {
  if has_cmd claude; then
    return
  fi

  echo "claude not found. Installing ${CLAUDE_PACKAGE}..."
  npm install -g "${CLAUDE_PACKAGE}"

  if ! has_cmd claude; then
    echo "claude installation did not succeed." >&2
    exit 1
  fi
}

install_codex_skills() {
  install_skills_for_agent codex
}

install_claude_skills() {
  install_skills_for_agent claude
}

install_skills_for_agent() {
  local agent="${1:?agent is required}"

  echo "Installing ${agent} skills..."
  npx --yes "${SKILLS_PACKAGE}" add \
    "https://github.com/vercel-labs/agent-browser/tree/main/skills/agent-browser" \
    -g \
    -a "${agent}" \
    -y
  npx --yes "${SKILLS_PACKAGE}" add \
    "https://github.com/anthropics/claude-code/tree/main/plugins/frontend-design/skills/frontend-design" \
    -g \
    -a "${agent}" \
    -y
}

ensure_agent_browser() {
  if has_cmd agent-browser; then
    return
  fi

  echo "Installing agent-browser globally..."
  npm install -g agent-browser
}

install_agent_browser_runtime() {
  echo "Installing agent-browser runtime..."
  agent-browser install
}

bootstrap() {
  local with_deps="false"
  if [[ "${1:-}" == "--with-deps" ]]; then
    with_deps="true"
  elif [[ -n "${1:-}" ]]; then
    usage >&2
    exit 1
  fi

  ensure_npm
  ensure_pnpm

  echo "Installing repository dependencies..."
  pnpm install

  ensure_agent_browser
  install_agent_browser_runtime

  if [[ "${with_deps}" == "true" ]]; then
    echo "Installing agent-browser system dependencies..."
    agent-browser install --with-deps
  fi

  echo "Shared agent tooling bootstrap completed."
}

setup_agent() {
  local agent="${1:-}"

  ensure_npm
  ensure_pnpm

  case "${agent}" in
    codex)
      ensure_codex
      install_codex_skills
      echo "Codex setup completed."
      ;;
    claude)
      ensure_claude
      install_claude_skills
      echo "Claude Code setup completed."
      ;;
    *)
      usage >&2
      exit 1
      ;;
  esac
}

command_name="${1:-}"

case "${command_name}" in
  bootstrap)
    shift || true
    bootstrap "$@"
    ;;
  setup)
    shift || true
    setup_agent "${1:-}"
    ;;
  *)
    usage >&2
    exit 1
    ;;
esac
