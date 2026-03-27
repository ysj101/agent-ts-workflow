# codex-ts-workflow

Codex で TypeScript を使って開発するための標準リポジトリです。`Oxlint + Biome`、Codex hooks、ExecPlan 運用、`agent-browser` を使ったフロントエンドのスクリーンショット運用を最初から入れています。アプリのパッケージ管理は `pnpm` 前提です。

## Quick Start

```bash
pnpm install
pnpm run quality
pnpm run build
```

## Included In This Template

- TypeScript の最小構成
- `Oxlint` による lint
- `Biome` による format
- `.codex/hooks.json` の `PostToolUse` による Bash 実行後の自動品質チェック
- `AGENTS.md` と `PLANS.md` による ExecPlan 運用
- `screenshots/` への保存を前提にしたフロントエンド確認フロー

## Codex Setup

このリポジトリには repo-local の Codex 設定を最初から同梱しています。

### Included By Default

- `.codex/config.toml` で `codex_hooks = true`
- `.codex/hooks.json` で `SessionStart` と `PostToolUse` を有効化
- `.codex/hooks/session-start-context.mjs` で開始時に作業ルールを補足
- `.codex/hooks/post-tool-use-quality.mjs` で Bash 実行後に変更ファイルへ Biome/Oxlint を適用

### Optional Local Tooling

```bash
# agentic browser
npm install -g agent-browser
agent-browser install
agent-browser install --with-deps
npx skills add vercel-labs/agent-browser

# context7
claude mcp add context7 -- npx --yes @upstash/context7-mcp

# frontend design
npx skills add anthropics/claude-code
```

## Quality Commands

```bash
pnpm run lint
pnpm run format
pnpm run format:check
pnpm run typecheck
pnpm run quality
```

`PostToolUse` hook は公式仕様上 `Bash` にしか反応しません。`apply_patch` で編集した内容は自動検知されないため、実際の運用では最後に `pnpm run quality` を明示実行してください。

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
- `AGENTS.md`
- `PLANS.md`

## Suggested Next Additions

- GitHub Actions で `pnpm run quality` を回す CI
- フロントエンド採用後の `pnpm run dev` とスクリーンショット用 URL の固定
- `requirements.toml` で sandbox / approval policy を固定
- テストランナー導入後の `pnpm test` または `pnpm run test:watch`
