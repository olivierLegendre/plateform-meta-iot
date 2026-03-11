# BDD Use Cases

This directory contains V1 behavior specifications in Gherkin format.

## Tag Convention

- `@v1`: scenario or feature is in V1 scope.
- `@waveN`: primary migration wave that validates the behavior.

## Feature List And Wave Mapping

1. `tenancy-and-access.feature` (`@wave1 @wave2`)
2. `api-versioning-and-deprecation.feature` (`@wave0 @wave2`)
3. `command-execution-and-fallback.feature` (`@wave4`)
4. `queue-and-idempotency.feature` (`@wave3 @wave4`)
5. `incidents-and-notifications.feature` (`@wave4 @wave5`)
6. `scenario-governance.feature` (`@wave5`)
7. `data-governance-and-security.feature` (`@wave1 @wave6`)

## Explicit Scenario Coverage For Core Migration Waves

## Wave 2 (`reference-api-service` extraction)

File: `api-versioning-and-deprecation.feature`

1. Deprecated endpoint returns standard deprecation headers.
2. Deprecated endpoint returns structured warning payload.
3. Deprecation warning also appears on 4xx responses.
4. Deprecation warning is omitted on 5xx responses.
5. Deprecated endpoint is removed after overlap.
6. Migration docs URL is versioned per major release.

## Wave 3 (`device-ingestion-service` extraction)

File: `queue-and-idempotency.feature`

1. Idempotency deduplicates within one hour per site.

## Wave 4 (command and safety plane)

File: `command-execution-and-fallback.feature`

1. Safety critical command uses API only.
2. Interactive control falls back to MQTT after API timeout.
3. Routine automation falls back after two API attempts.
4. Bulk non critical remains API-only.
5. Safety critical success requires observed state.
6. SLA breach on safety critical triggers immediate action.
7. Command is immutable after accepted.
8. Cancel is allowed only before dispatch.
9. Channel override is restricted and audited.
10. Safety critical missing idempotency key is rejected.
11. Safety critical missing correlation id is rejected.

File: `queue-and-idempotency.feature`

1. New command is queued when point has in-flight command.
2. Queue overflow fails with 503 and Retry-After header.
3. FIFO execution within normal priority flow.
4. Safety command is prioritized in queued items.
5. In-flight non-safety command is not preempted by safety command.
6. Fail-safe mode blocks new commands on persistence outage.
7. Platform generates idempotency key for non-safety command when missing.
8. Correlation id uniqueness is enforced per site for 24h.
9. Reissue creates new command identity and lineage.

Scope note:

- Partner integration features are intentionally excluded from V1 and should be added post-V1.
