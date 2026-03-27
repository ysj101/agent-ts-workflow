const lines = [
  "Read AGENTS.md before editing.",
  "Use an ExecPlan from PLANS.md for complex work.",
  "Run pnpm run quality before finishing any change.",
  "After frontend edits, capture screenshots into screenshots/ with agent-browser before the final reply.",
  "The PostToolUse hook only observes Bash, so edits made via apply_patch still need an explicit pnpm run quality."
]

process.stdout.write(
  JSON.stringify({
    hookSpecificOutput: {
      hookEventName: "SessionStart",
      additionalContext: lines.join(" ")
    }
  })
)
