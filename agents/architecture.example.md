# Architecture — Agent Instructions

> Extends [agents.md](../agents.md). Apply when defining boundaries, choosing patterns, or refactoring system design.

---

## Architecture Rules

- Keep transport, domain, and infrastructure concerns separated.
- Keep domain code independent from framework and storage details.
- Keep module boundaries explicit and dependency direction one-way.

## Pattern Selection

- Use simple patterns first; add complexity only when justified.
- Use Strategy for runtime-selectable behavior.
- Use Repository + Unit of Work for persistence boundaries.
- Use Factory only for complex object creation flows.

## Design Decisions

- Propose at least one alternative for non-trivial design choices.
- Explain tradeoffs (complexity, coupling, testability, performance).
- Record assumptions, constraints, and rejected options.

## Anti-Patterns

- Reject god objects/services.
- Reject hidden side effects and implicit shared state.
- Reject circular dependencies across modules.
- Reject leaking infrastructure concerns into domain logic.

## Validation

- Validate design changes with tests at module boundaries.
- Validate backward compatibility for public APIs and schemas.
- Validate observability impact for critical flows.
