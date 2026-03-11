# Patterns — Data Access and Persistence

> Extends [agents/backend.md](../backend.md). Load for repositories, transactions, queries, and model mapping.

## Use Cases

- Isolating persistence from business logic.
- Coordinating transactional write workflows.
- Managing read/write model complexity.

## Recommended Patterns

- Repository: hide storage concerns behind domain-oriented interfaces.
- Unit of Work: coordinate atomic changes across repositories.
- Data Mapper: decouple domain models from storage models.
- Specification: compose reusable query predicates.
- CQRS: split read/write paths when models diverge significantly.

## Watch-outs

- Avoid CQRS when read/write complexity is low.
- Avoid anemic repositories that leak query details everywhere.
