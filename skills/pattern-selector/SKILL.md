---
name: pattern-selector
description: Use this skill when the user asks for design patterns, architecture choices, or refactoring approaches. It classifies the task domain, loads the relevant pattern group, proposes options with tradeoffs, and recommends an incremental implementation path.
---

# Pattern Selector

## When to use

- Use for pattern choice, architecture alternatives, and refactor planning.
- Use when multiple valid design options exist.

## Domain selection

1. If task is about layering/modules/boundaries, load `agents/patterns/architecture.md`.
2. If task is about algorithm variation/state/workflow, load `agents/patterns/behavior.md`.
3. If task is about persistence/queries/transactions, load `agents/patterns/data-access.md`.
4. If task is about external APIs/messaging/fault tolerance, load `agents/patterns/integration.md`.

## Workflow

1. Classify task domain and constraints.
2. Present 2-3 candidate patterns.
3. Compare tradeoffs: complexity, coupling, testability, performance, migration risk.
4. Recommend one option with rationale.
5. Output a stepwise rollout plan with validation checkpoints.

## Output format

- Selected domain and why.
- Candidate patterns and tradeoffs.
- Recommended pattern set.
- Incremental implementation plan.
