# Codex Execution Plans

This document defines the repository standard for an execution plan ("ExecPlan"). Every ExecPlan is a living document that a new contributor must be able to follow without prior context.

## When To Use It

Use an ExecPlan for complex features, multi-step refactors, risky migrations, or any task that may take long enough that another person or another Codex run may need to resume from the plan alone.

## Non-Negotiable Requirements

- Every ExecPlan must be self-contained.
- Every ExecPlan must stay current as work progresses.
- Every ExecPlan must describe user-visible behavior or another concrete way to prove success.
- Every ExecPlan must define unfamiliar terms in plain language.
- Every ExecPlan must include exact files, commands, and expected outcomes.

## Required Sections

Every ExecPlan must contain these sections and keep them current:

1. `Purpose / Big Picture`
2. `Progress`
3. `Surprises & Discoveries`
4. `Decision Log`
5. `Outcomes & Retrospective`
6. `Context and Orientation`
7. `Plan of Work`
8. `Concrete Steps`
9. `Validation and Acceptance`

## Authoring Rules

- Start by explaining why the work matters and how someone can verify the result.
- Name files by repository-relative path.
- Record progress with timestamped checkboxes.
- Document changed decisions and unexpected findings as they happen.
- Prefer milestones that can be validated independently.
- Treat prototypes as explicit, testable milestones when uncertainty is high.

## ExecPlan Skeleton

```md
# <Short, action-oriented title>

This ExecPlan is a living document. Maintain it according to `PLANS.md`.

## Purpose / Big Picture

Explain what changes for the user and how to see it working.

## Progress

- [ ] (YYYY-MM-DD HH:MMZ) Initial milestone description.

## Surprises & Discoveries

- Observation: ...
  Evidence: ...

## Decision Log

- Decision: ...
  Rationale: ...
  Date/Author: ...

## Outcomes & Retrospective

Summarize what shipped, what remains, and what you learned.

## Context and Orientation

Describe the current code paths, files, and assumptions needed to understand the work.

## Plan of Work

Describe the exact edits and additions in order.

## Concrete Steps

List the commands to run, the working directory, and the expected results.

## Validation and Acceptance

State the checks, outputs, screenshots, or behavior that prove the work is complete.
```
