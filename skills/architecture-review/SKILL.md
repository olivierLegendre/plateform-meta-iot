---
name: architecture-review
description: Use this skill when the user asks for architecture guidance, design pattern selection, boundary definition, or refactoring plans. It reviews current structure, flags anti-patterns, proposes alternatives with tradeoffs, and outputs a concrete incremental implementation plan.
---

# Architecture Review

## When to use

- Use this skill for system design, module boundaries, design pattern choices, and architecture refactors.
- Use this skill when a task has multiple valid design options and tradeoffs must be explicit.

## Inputs to gather

- Current architecture shape (layers, modules, ownership).
- Constraints (team size, delivery time, performance, reliability, compliance).
- Non-functional requirements (latency, scalability, operability, security).

## Workflow

1. Map current boundaries and dependency directions.
2. Identify architecture risks and anti-patterns.
3. Propose 2-3 viable design options.
4. Compare options by complexity, coupling, testability, performance, and migration risk.
5. Recommend one option with rationale.
6. Produce an incremental rollout plan with checkpoints and rollback points.

## Output format

- Current-state risks.
- Options and tradeoffs.
- Recommended option.
- Step-by-step migration plan.
- Validation plan (tests, metrics, compatibility checks).

## References

- Load [`agents/architecture.md`](../../agents/architecture.md) for project architecture defaults.
- Load domain-specific files (`agents/backend.md`, `agents/frontend.md`, `agents/security.md`) only when relevant.
