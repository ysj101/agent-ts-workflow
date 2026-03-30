# agent-ts-workflow

Codex と Claude Code の両方で使える TypeScript 開発用テンプレートです。`Tailwind CSS v4`、`Oxlint + Biome`、共有 hook、ExecPlan 運用、`agent-browser` を使ったフロントエンドのスクリーンショット運用を最初から入れています。アプリのパッケージ管理は `pnpm` 前提です。

## Quick Start

```bash
make bootstrap
make setup-codex   # or: make setup-claude
make quality
make build
```

## Included In This Template

- TypeScript の最小構成
- `Tailwind CSS v4` と CLI による最小 CSS build
- `Oxlint` による lint
- `Biome` による format + recommended lint
- `husky + lint-staged` による staged file 向け pre-commit チェック
- `scripts/agent-hooks/` による共有 hook 実装
- `.codex/hooks.json` と `.claude/settings.json` による repo-local agent hook 設定
- `.codex/config.toml` による Codex 向け repo-local MCP 同梱
- `CLAUDE.md` による Claude Code 向け project memory
- `scripts/setup-agent-tooling.sh` による共通 bootstrap と agent 別 setup
- `AGENTS.md` と `PLANS.md` による ExecPlan 運用
- `screenshots/` への保存を前提にしたフロントエンド確認フロー

## Shared Bootstrap

最初に共有依存を入れます。

```bash
make bootstrap
```

必要ならブラウザ依存物込みで:

```bash
make bootstrap-full
```

この bootstrap は次をまとめて実行します。

- `npm` の確認と不足時の install
- `pnpm` の確認と不足時の install
- repository dependencies の install
- `agent-browser` の global install
- `agent-browser install` の実行
- `--with-deps` 指定時の追加依存物 install

## Tailwind CSS

このテンプレートには `tailwindcss@4` と `@tailwindcss/cli` が入っています。

- 入力 CSS: `src/styles/tailwind.css`
- 出力 CSS: `dist/tailwind.css`

生成コマンド:

```bash
pnpm run build:css
```

watch モード:

```bash
pnpm run dev:css
```

`make build` / `pnpm run build` は TypeScript build に加えて Tailwind CSS の出力も行います。

## Codex Setup

Codex を使う場合は、共有 bootstrap の後に次を実行します。

```bash
make setup-codex
```

Codex setup では次を実行します。

- `codex` CLI の確認と `@openai/codex` の global install
- Codex 向け skill の user-level install
- repo-local の `.codex/config.toml` と `.codex/hooks.json` を利用

## Claude Code Setup

Claude Code を使う場合は、共有 bootstrap の後に次を実行します。

```bash
make setup-claude
```

Claude setup では次を実行します。

- `claude` CLI の確認と `@anthropic-ai/claude-code` の global install
- Claude Code 向け skill の user-level install
- repo-local の `CLAUDE.md` と `.claude/settings.json` を利用

## Agent Config Layout

- `AGENTS.md`: agent 共通の repository conventions
- `PLANS.md`: ExecPlan のフォーマット
- `scripts/agent-hooks/`: startup context と quality automation の共有実装
- `.codex/hooks.json`: Codex 用 hook 設定
- `.codex/config.toml`: Codex 用 MCP / hook 設定
- `CLAUDE.md`: Claude Code 用 project memory entrypoint
- `.claude/settings.json`: Claude Code 用 project settings / hooks

## Quality Commands

```bash
make quality
pnpm run lint
pnpm run format
pnpm run format:check
pnpm run build:css
pnpm run typecheck
pnpm run quality
```

repo-local の自動品質 hook は agent ごとに反応する tool が異なります。

- Codex: `PostToolUse` は `Bash` にしか反応しません
- Claude Code: `PostToolUse` は `Edit` / `Write` にしか反応しません

そのため、実際の運用では最後に `pnpm run quality` を明示実行してください。

## Lint Baseline

このテンプレートでは、最初から次の lint 基準を有効にしています。

- `Biome`: recommended lint ルールセット
- `Oxlint`: `correctness` と `suspicious` カテゴリを error として有効化
- `Oxlint`: 未使用の disable directive を error 扱い

`Oxlint` は `.oxlintrc.json`、`Biome` は `biome.json` で調整できます。厳しすぎる場合は、ここを起点にルールを段階的に緩める前提です。

## Git Hooks

`pnpm install` 時に `husky` が有効化され、`pre-commit` では staged file に対して次だけを実行します。

- `biome check --write`
- `oxlint`
- `pnpm run typecheck`

`quality` は `format:check + lint + typecheck` の非破壊な最終チェックとして残し、pre-commit では staged file 向けの修正と `typecheck` のみを実行します。

## Frontend Screenshot Workflow

フロントエンドを編集したら、最終応答の前に `agent-browser` で画面確認し、`screenshots/` に保存します。

例:

```bash
agent-browser open http://127.0.0.1:3000
agent-browser wait --load networkidle
agent-browser screenshot --full screenshots/2026-03-28-home-page.png
```

必要であれば、モバイル幅でも追加で撮ります。
