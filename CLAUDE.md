# full-stack-agentic

This is a full-stack web application with a Python backend and TypeScript/Node 22 frontend.

**Read `.agents/rules/base.md` first.** It is the single source of truth for project conventions, available commands, architecture overview, testing instructions, and the SpecKit workflow. Do not proceed with any task until you have read that file.

## Session Blocking Requirements

**BLOCKING:** When the user asks to build, design, or add something that involves multiple files/components, ambiguous requirements, architectural decisions, or new domain concepts — suggest `/speckit.specify` BEFORE writing any code or creating any files. Do not auto-invoke it; suggest it and wait for the user's decision.

**BLOCKING:** When `specs/<feature>/tasks.md` exists with pending tasks (`[ ]`) — suggest `/speckit.implement` BEFORE implementing anything described in those tasks. Do not auto-invoke it; suggest it and wait for the user's decision.

These rules do not apply to simple, clearly scoped changes (bug fixes, small edits, single-file changes with no architectural impact).

## Praxis Skills

Four Praxis skills are available as commands for engineering discipline:

- `/praxis.complexity-review` — challenge a technical proposal against 30 complexity dimensions before committing to a design
- `/praxis.test-desiderata` — analyze test quality using Kent Beck's 12 properties
- `/praxis.expand-contract` — plan zero-downtime breaking changes (DB columns, API fields, service replacements)
- `/praxis.event-modeling` — design complex features as independently testable vertical slices

**When to suggest them:**
- Suggest `/praxis.complexity-review` when a plan involves Kafka, microservices, event sourcing, or any component that feels over-engineered — run it before `/speckit.plan`
- Suggest `/praxis.test-desiderata` during `/speckit.retro` when test quality feels low
- Suggest `/praxis.expand-contract` whenever a task involves renaming DB columns, changing API response shapes, or replacing a service
- Suggest `/praxis.event-modeling` when a feature has complex multi-step flows or asynchronous domain logic — run it as input to `/speckit.plan`
