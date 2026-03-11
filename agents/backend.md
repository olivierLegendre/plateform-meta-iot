# Backend — Agent Instructions

> Extends [agents.md](../agents.md). Apply when building APIs, services, workers, or pipelines.

---

## API Design

- Use one API style per bounded context.
- Use noun-based REST paths and explicit action endpoints when needed.
- Version APIs from the start.
- Return correct HTTP status codes.
- Return a consistent structured error body.
- Paginate collection endpoints.

## Request Handling

- Validate headers, params, and bodies at entry points.
- Use schema validation libraries.
- Enforce request size limits.
- Apply rate limiting at gateway or middleware.

## Domain and Data

- Keep business logic out of transport layers.
- Keep side effects at boundaries.
- Model domain types and domain errors explicitly.
- Use migrations for every schema change.
- Keep migrations reversible.
- Use transactions for atomic operations.
- Prevent N+1 access patterns.

## Async and Reliability

- Offload long-running work to queues.
- Make jobs idempotent.
- Use dead-letter queues for exhausted retries.
- Emit structured domain events.

## Configuration and Ops

- Load all environment-specific values from env vars.
- Validate env vars at startup and fail fast.
- Propagate correlation IDs across requests and downstream calls.
- Emit latency, error-rate, and saturation metrics.
- Expose readiness and liveness health endpoints.
- Handle graceful shutdown on `SIGTERM`/`SIGINT`.

## Cross-References

- Use [agents/security.md](./security.md) for data and auth security controls.
- Use [agents/testing.md](./testing.md) for all testing standards.
