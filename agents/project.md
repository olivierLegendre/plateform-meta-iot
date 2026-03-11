# Project-Specific — Agent Instructions

## Architecture

- Use Hexagonal Architecture.
- Keep business logic in domain/services, not controllers.
- Keep domain code framework-agnostic.

## Patterns

- Use Repository + Unit of Work at persistence boundaries.
- Use Strategy for pluggable algorithms.

## Anti-Patterns

- Reject god services and mutable global state.
- Reject direct DB access from transport layers.
- Reject hidden constructor side effects.

## Quality Gates

- Require lint, typecheck, unit tests, and integration tests before merge.
- Require rollback checks for schema and migration changes.

## Done Criteria

- Cover happy, edge, and failure paths.
- Add observability for critical flows.
- Document API/schema compatibility impact.

## Decision Policy

- Prefer simple, readable solutions first.
- Use advanced patterns only when justified by reuse/change frequency.
- Explain non-standard design choices in PR notes.
