const lines = [
  "Read AGENTS.md before editing.",
  "Use an ExecPlan from PLANS.md for complex work.",
  "Run pnpm run quality before finishing any change.",
  "After frontend edits, capture screenshots into screenshots/ with agent-browser before the final reply.",
  "Codex PostToolUse hooks only observe Bash, and Claude Code PostToolUse hooks only observe Edit/Write, so manual edits still need an explicit pnpm run quality.",
]

const mode = process.argv[2] ?? "plain"
const message = lines.join(" ")

if (mode === "codex") {
  process.stdout.write(
    JSON.stringify({
      hookSpecificOutput: {
        hookEventName: "SessionStart",
        additionalContext: message,
      },
    }),
  )
  process.exit(0)
}

process.stdout.write(message)
