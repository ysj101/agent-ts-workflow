# Codex Execution Plans (ExecPlans)

This document defines the repository standard for an execution plan ("ExecPlan"). Treat the reader as a complete beginner to this repository: they have only the current working tree and the single ExecPlan file you provide. There is no memory of prior plans and no external context.

## How To Use ExecPlans And PLANS.md

When authoring an ExecPlan, follow `PLANS.md` exactly. Re-read it before producing or revising a plan. Start from the skeleton in this document, then fill it in with repository-specific research, implementation detail, commands, and expected observations.

When implementing an ExecPlan, continue from the next milestone without asking the user for "next steps" when the plan is already clear. Keep all required sections current as progress is made. If you stop midway, the `Progress` section must say exactly what is done and what remains.

When discussing or revising an ExecPlan, record every material decision in the plan itself. An ExecPlan must always be sufficient for another contributor to restart from the document alone.

When the task has major uncertainty, de-risk it with explicit prototyping or spike milestones. Record the scope, how to run the prototype, how to judge the result, and how that result changes the main implementation path.

## Requirements

Non-negotiable requirements:

- Every ExecPlan must be fully self-contained. In practice, that means the current version contains all knowledge and instructions needed for a novice to succeed.
- Every ExecPlan is a living document. As progress, discoveries, and decisions happen, the plan must be updated and must remain self-contained.
- Every ExecPlan must let a complete novice implement the change end to end without prior knowledge of this repository.
- Every ExecPlan must describe demonstrably working behavior, not merely code edits.
- Every ExecPlan must define any non-obvious term in plain language, or avoid the term.

Purpose and user-visible intent come first. Begin by explaining what someone can do after the change that they could not do before, and how to see it working.

Assume the implementing agent can list files, read files, search, run the project, and run tests, but has no prior context. Repeat assumptions the plan relies on. Do not send the reader to outside docs for required implementation context; if the knowledge matters, restate it inside the ExecPlan in your own words.

If an ExecPlan depends on a prior checked-in ExecPlan, reference its path explicitly. If it is not checked in, copy the necessary context into the current plan.

## Formatting

Each ExecPlan must be written as a single Markdown document. If the ExecPlan is shared inline, wrap it in one fenced code block labeled `md`. If the ExecPlan is written to its own `.md` file and the file contains nothing except the plan, omit the outer fence.

Use proper Markdown headings with two blank lines after each heading. Use plain prose for narrative sections. Avoid tables and long enumerations unless they improve clarity. Checklists are mandatory only in `Progress`; other sections should remain prose-first.

If you need to show commands, transcripts, snippets, or diffs inside an inline fenced ExecPlan, present them as indented blocks rather than nested fenced blocks.

## Guidelines

Self-containment and plain language are the top priority. If you use a term such as "daemon", "migration", "adapter", or "gateway", define it immediately and tie it to the exact repository files or commands where it appears.

Resolve ambiguity in the plan instead of pushing it to the next contributor. Choose the path you want implemented, explain why, and bias toward observable user outcomes over incidental implementation detail.

Anchor the plan in behavior a human can verify. Explain what to run, where to run it, and what should happen. For internal-only work, explain how the impact is still proven, such as failing tests that pass after the change.

Specify repository context explicitly. Use repository-relative paths everywhere. Name functions, modules, commands, and directories precisely. If multiple areas are involved, include a short orientation paragraph that explains how they connect.

Write steps so they are safe to repeat. If a step can fail halfway, explain how to retry it or recover. If a step is destructive, spell out the backup or fallback.

Validation is required. Describe the exact test commands, startup commands, manual checks, and expected output that prove the change works.

Capture concise evidence in the plan when it matters, such as a short terminal transcript, focused diff excerpt, or error message that distinguishes success from failure.

## Milestones

Milestones are narrative, not bureaucracy. Each milestone should explain its scope, what will exist when it completes, how to exercise it, and what evidence proves it is done.

Progress and milestones serve different purposes. Milestones tell the implementation story. `Progress` tracks the current granular state. Both must exist.

Each milestone must be independently verifiable and incrementally advance the overall goal.

## Living Plans And Design Decisions

Every ExecPlan must contain and maintain these sections:

- `Progress`
- `Surprises & Discoveries`
- `Decision Log`
- `Outcomes & Retrospective`

When implementation changes direction, update the `Decision Log` and reflect the new state in `Progress`. When unexpected behavior, performance tradeoffs, or bugs influence the implementation, record them in `Surprises & Discoveries` with concise evidence.

At major milestones and at completion, update `Outcomes & Retrospective` with what shipped, what remains, and what was learned.

When revising an ExecPlan, make sure the revision is reflected consistently across every affected section. Add a short revision note at the bottom explaining what changed and why.

## Prototyping Milestones And Parallel Implementations

Prototype milestones are encouraged when they reduce risk. Keep them additive, testable, and clearly labeled as prototypes. State the criteria for either promoting the prototype into the final implementation or discarding it.

Parallel implementations are acceptable when they let tests continue to pass or let a migration proceed safely. If you use one, explain how both paths are validated and how the old path is retired.

If a task spans multiple new libraries or feature areas, consider separate spikes that prove each dependency or capability in isolation before merging them into the main path.

## Skeleton Of A Good ExecPlan

```md
# <Short, action-oriented description>

This ExecPlan is a living document. The sections `Progress`, `Surprises & Discoveries`, `Decision Log`, and `Outcomes & Retrospective` must be kept up to date as work proceeds.

This document must be maintained in accordance with `PLANS.md`.

## Purpose / Big Picture

Explain in a few sentences what someone gains after this change and how to see it working. State the user-visible behavior this work enables.

## Progress

- [x] (YYYY-MM-DD HH:MMZ) Example completed step.
- [ ] (YYYY-MM-DD HH:MMZ) Example incomplete step.
- [ ] (YYYY-MM-DD HH:MMZ) Example partially completed step (completed: X; remaining: Y).

Use timestamps. Every stopping point must be reflected here.

## Surprises & Discoveries

Document unexpected behaviors, bugs, optimizations, or insights discovered during implementation. Provide concise evidence.

- Observation: ...
  Evidence: ...

## Decision Log

Record every material decision made while working on the plan.

- Decision: ...
  Rationale: ...
  Date/Author: ...

## Outcomes & Retrospective

Summarize outcomes, gaps, and lessons learned at major milestones or at completion. Compare the result against the original purpose.

## Context And Orientation

Describe the current repository state relevant to this task as if the reader knows nothing. Name the key files and modules by full repository-relative path. Define any non-obvious term you will use. Do not rely on prior plans.

## Plan Of Work

Describe, in prose, the sequence of edits and additions. For each edit, name the file and location (module, function, command, or directory) and what to change.

## Concrete Steps

State the exact commands to run and where to run them. When a command produces important output, include a short expected transcript so the reader can compare.

## Validation And Acceptance

Describe how to exercise the system and what to observe. Phrase acceptance as behavior with specific inputs and outputs. If tests are involved, state the exact command and how to interpret the result.

## Idempotence And Recovery

State which steps are safe to repeat. If a step is risky, describe the safe retry, rollback, cleanup, or fallback path.

## Artifacts And Notes

Include the most important transcripts, diffs, or snippets as short indented examples. Keep them focused on what proves success.

## Interfaces And Dependencies

Be prescriptive. Name the libraries, modules, services, types, traits, interfaces, and function signatures that must exist at the end of the work, and explain why they are required.

Revision note: <what changed in this revision and why>
```
