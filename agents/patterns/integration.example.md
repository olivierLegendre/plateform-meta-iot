# Patterns — Integration and Resilience

> Extends [agents/devops.md](../devops.md). Load for external APIs, async messaging, and failure handling.

## Use Cases

- Calling unreliable external services.
- Integrating heterogeneous systems and contracts.
- Protecting core flows from cascading failures.

## Recommended Patterns

- Adapter: normalize third-party interfaces.
- Facade: present a narrow integration surface.
- Circuit Breaker: fail fast during downstream outages.
- Retry with Backoff: recover transient failures safely.
- Bulkhead: isolate resources to contain blast radius.
- Outbox: guarantee event publication with DB writes.

## Watch-outs

- Avoid unbounded retries.
- Avoid synchronous coupling for non-critical workflows.
- Avoid missing idempotency keys in retry paths.
