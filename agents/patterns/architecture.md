# Patterns — Architecture and Boundaries

> Extends [agents/architecture.md](../architecture.md). Load for module boundaries, layering, and system decomposition.

## Use Cases

- Splitting monolith domains or modules.
- Defining layer boundaries and dependency direction.
- Isolating framework and infrastructure concerns.

## Recommended Patterns

- Hexagonal Architecture: isolate domain from adapters.
- Clean Architecture: enforce inward dependency direction.
- Modular Monolith: keep strong module boundaries before microservices.
- Anti-Corruption Layer: isolate legacy/external model mismatches.

## Watch-outs

- Avoid circular module dependencies.
- Avoid leaking transport/persistence concerns into domain logic.
- Avoid premature microservice splits.
