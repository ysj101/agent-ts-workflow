# codex-ts-workflow

Codex で TypeScript を使って開発するための標準リポジトリです。`Oxlint + Biome`、Codex hooks、ExecPlan 運用、`agent-browser` を使ったフロントエンドのスクリーンショット運用を最初から入れています。アプリのパッケージ管理は `pnpm` 前提です。

## Quick Start

```bash
make bootstrap
make quality
make build
```

## Included In This Template

- TypeScript の最小構成
- `Oxlint` による lint
- `Biome` による format
- `husky + lint-staged` による staged file 向け pre-commit チェック
- `.codex/hooks.json` の `PostToolUse` による Bash 実行後の自動品質チェック
- `.codex/config.toml` による `context7` の repo-local MCP 同梱
- `scripts/setup-codex-tooling.sh` による Codex tooling と skill bootstrap
- `AGENTS.md` と `PLANS.md` による ExecPlan 運用
- `screenshots/` への保存を前提にしたフロントエンド確認フロー

## Codex Setup

このリポジトリには repo-local の Codex 設定を最初から同梱しています。

### Included By Default

- `.codex/config.toml` で `codex_hooks = true`
- `.codex/config.toml` で `context7` を repo-local MCP として定義
- `.codex/hooks.json` で `SessionStart` と `PostToolUse` を有効化
- `.codex/hooks/session-start-context.mjs` で開始時に作業ルールを補足
- `.codex/hooks/post-tool-use-quality.mjs` で Bash 実行後に変更ファイルへ Biome/Oxlint を適用

### Installed By Setup Command

- `vercel-labs/agent-browser` の skill
- `anthropics/claude-code` の `frontend-design` skill
- `make setup-codex` は `npx skills add ... -g -a codex` を使って user-level に install します
- repo には skill 本体を vendoring しません

### Included Local Tooling Bootstrap

```bash
make setup-codex
```

必要ならブラウザ依存物込みで:

```bash
make setup-codex-full
```

この bootstrap は次をまとめて実行します。

- `npm` の確認と不足時の install
- `pnpm` の確認と不足時の install
- `codex` CLI の確認と `@openai/codex` の global install
- Codex 向け skill の user-level install
- `agent-browser` の global install
- `agent-browser install` の実行
- `--with-deps` 指定時の追加依存物 install

リポジトリ依存物までまとめて入れるなら:

```bash
make bootstrap
```

## Quality Commands

```bash
make quality
pnpm run lint
pnpm run format
pnpm run format:check
pnpm run typecheck
pnpm run quality
```

`PostToolUse` hook は公式仕様上 `Bash` にしか反応しません。`apply_patch` で編集した内容は自動検知されないため、実際の運用では最後に `pnpm run quality` を明示実行してください。

## Git Hooks

`pnpm install` 時に `husky` が有効化され、`pre-commit` では staged file に対して次だけを実行します。

- `biome check --write`
- `oxlint`

重い `typecheck` や full quality gate は commit hook に入れず、明示的に `make quality` または `pnpm run quality` で回す前提です。

## Frontend Screenshot Workflow

フロントエンドを編集したら、最終応答の前に `agent-browser` で画面確認し、`screenshots/` に保存します。

例:

```bash
agent-browser open http://127.0.0.1:3000
agent-browser wait --load networkidle
agent-browser screenshot --full screenshots/2026-03-28-home-page.png
```

必要であれば、モバイル幅でも追加で撮ります。

## Hooks And Files

- `.codex/config.toml`
- `.codex/hooks.json`
- `.codex/hooks/session-start-context.mjs`
- `.codex/hooks/post-tool-use-quality.mjs`
- `scripts/setup-codex-tooling.sh`
- `AGENTS.md`
- `PLANS.md`

## Suggested Next Additions

- GitHub Actions で `pnpm run quality` を回す CI
- フロントエンド採用後の `pnpm run dev` とスクリーンショット用 URL の固定
- `requirements.toml` で sandbox / approval policy を固定
- テストランナー導入後の `pnpm test` または `pnpm run test:watch`
