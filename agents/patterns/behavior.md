# Patterns — Behavior and Workflow

> Extends [agents/architecture.md](../architecture.md). Load for variable behavior, orchestration, and request processing.

## Use Cases

- Switching algorithms by runtime context.
- Managing state-dependent behavior.
- Sequencing request/command pipelines.

## Recommended Patterns

- Strategy: select behavior implementation at runtime.
- State: encode state-specific behavior without condition sprawl.
- Command: model executable actions with audit/retry potential.
- Template Method: standardize flow with overridable steps.
- Chain of Responsibility: compose request middleware/policies.

## Watch-outs

- Avoid deep inheritance when composition is enough.
- Avoid pattern stacking without measurable value.
