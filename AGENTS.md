# Repository Conventions

## Quality Gate

- Run `pnpm run quality` before you finish any code change.
- The repo-local `PostToolUse` hook automatically runs Biome formatting and Oxlint for changed files after Bash commands.
- The hook does not observe `apply_patch`, so manual edits still require an explicit `pnpm run quality`.

## ExecPlans

When writing complex features or significant refactors, use an ExecPlan from `PLANS.md` from design to implementation.

Keep the ExecPlan up to date while you work. Do not ask for "next steps" between milestones when the plan is already clear.

## Frontend Workflow

- After editing frontend code, run the app locally and capture at least one screenshot into `screenshots/` with `agent-browser`.
- Use a descriptive filename such as `screenshots/2026-03-28-home-page.png`.
- Mention the captured screenshots in the final user-facing response and summarize what changed visually.
- If the page is responsive, capture both desktop and mobile states when the change materially affects layout.
