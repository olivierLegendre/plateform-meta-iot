# Target Architecture And Migration Plan

Status: Draft v0.4
Date: 2026-03-13  
Baseline: `/home/olivier/Public/poc`

Companion documents:

1. Detailed V1 specification: `docs/v1-system-specification.md`
2. BDD use-case suite: `docs/bdd/README.md`
3. Multi-repo setup and governance: `docs/multi-repo-operating-model.md`
4. Fast context anchor: `docs/baseline-snapshot.md`
5. Wave 4 closure evidence: `docs/wave-4-closure-checkpoint.md`
6. Wave 5 closure evidence: `docs/wave-5-closure-checkpoint.md`
7. Forward alignment guardrails: `docs/wave-forward-alignment-audit.md`
8. Container image/tag governance: `docs/container-image-tagging-policy.md`
9. Wave 7 kickoff checkpoint: `docs/wave-7-kickoff-checkpoint.md`
10. Wave 7 execution backlog: `docs/wave-7-execution-backlog.md`
11. Wave 7 Schneider BACnet contract freeze: `docs/wave-7-schneider-bacnet-contract.md`
12. Wave 7 Tandem Connect planning packet: `docs/wave-7-tandem-connect-planning.md`
13. Wave 7 Siemens Building X planning packet: `docs/wave-7-siemens-buildingx-planning.md`
14. Wave 7 scale-hardening baseline: `docs/wave-7-scale-hardening-baseline.md`
15. Wave 7 closure sign-off: `docs/wave-7-closure-signoff.md`
16. Wave 8 kickoff checkpoint: `docs/wave-8-kickoff-checkpoint.md`
17. Wave 8 execution backlog: `docs/wave-8-execution-backlog.md`
18. Wave 8 closure sign-off: `docs/wave-8-closure-signoff.md`

## 0. Locked Decisions Snapshot

1. V1 includes all core platform capabilities except partner runtime integrations.
2. Node-RED is migration-only integration or edge glue and cannot host core logic at V1 GA.
3. Stack choices are fixed: Python services, `paho-mqtt`, Vue.js (Vue 3 + Vite) operator UI, Camunda with TypeScript integration layer, Keycloak IAM, Grafana OSS.
4. Vault is mandatory in V1 and blocks first production go-live if missing.
5. DB-level tenant isolation in PostgreSQL is required in V1.
6. API path versioning with 90-day overlap and deprecation warnings is required.
7. API is primary channel; MQTT is optional fallback by policy and must be handled in separate components.
8. Post-V1 partner rollout order is Schneider BACnet first, Tandem Connect second, Siemens Building X API third.

## 1. Pattern-Driven Architecture Frame

This plan uses pattern guidance from:

- `agents/patterns/architecture.md`
- `agents/patterns/integration.md`
- `agents/patterns/data-access.md`
- `agents/architecture.md`

### 1.1 Selected pattern set

1. Boundary and module design:
- Hexagonal Architecture + Clean dependency direction.
- Anti-Corruption Layer for legacy/external model mismatch.

2. External integration and resilience:
- Adapter + Facade for protocol/provider isolation.
- Circuit Breaker + Retry with Backoff + Bulkhead for fault containment.
- Outbox for reliable event publication tied to DB commits.

3. Persistence:
- Repository + Unit of Work + Data Mapper as default in Python services.

### 1.2 Patterns explicitly deferred

1. Full event sourcing in V1.
2. Full CQRS split in V1 (activate only when read/write divergence becomes a measured bottleneck).
3. Premature microservice split of low-change shared utilities.

## 2. Target Topology And Ownership

Canonical service boundaries:

1. `plateform-meta-iot`
- Orchestration, standards, ADRs, contract governance, integration CI.

2. `platform-foundation`
- Runtime infrastructure, networking baseline, secret and operational baseline.

3. `identity-access`
- Keycloak realm/client/role/policy governance.

4. `reference-api-service` (Python)
- Canonical API contracts and domain services for references, mappings, links, command API surface.

5. `device-ingestion-service` (Python)
- MQTT intake, normalization, deduplication, write-path ownership for ingestion data.

6. `automation-scenario-service`
- Camunda orchestration plus TypeScript integration workers.

7. `channel-policy-router`
- Command channel strategy and fallback execution policy (API primary, MQTT optional fallback).

8. `operator-ui` (Vue.js)
- Operational and governance workflows.

9. `partner-integration-layer` (post-V1)
- Schneider BACnet adapter, Tandem Connect adapter, Siemens Building X API adapter.

Boundary rules:

1. Transport adapters never embed business rules.
2. Domain services own validation and orchestration decisions.
3. Repositories own SQL and transaction boundaries.
4. Cross-service interactions use versioned contracts only.
5. UI and external clients never bypass service ownership with direct DB access.

## 3. Migration Strategy

Strategy is strangler-first with progressive extraction and reversible cutovers.

Execution rules:

1. Each wave has explicit entry criteria, acceptance criteria, and rollback.
2. No wave starts before prior wave acceptance is fully green.
3. All high-risk switches are feature-flagged.

## 4. Wave Plan (Structured V2)

## 4.1 Wave Status Matrix

| Wave | Name | Status | Notes |
| --- | --- | --- | --- |
| 0 | Contract And Boundary Freeze | completed | Core governance docs and BDD baseline in place. |
| 1 | Foundation And Security Baseline | pending | Platform foundation hardening not yet fully implemented. |
| 2 | `reference-api-service` Extraction | completed | Service scaffold and API contract/testing baseline delivered. |
| 3 | `device-ingestion-service` Extraction | completed | MQTT ingestion and persistence baseline delivered. |
| 4 | Command And Safety Plane | completed | Frozen on 2026-03-13; see docs/wave-4-closure-checkpoint.md. |
| 5 | Automation And Operator UI Decoupling | completed | Closed on 2026-03-17 for workflow+UI+auth+e2e slice; see docs/wave-5-closure-checkpoint.md. |
| 6 | Node-RED Retirement And Hardening | completed | Closed on 2026-03-18; see docs/wave-6-closure-signoff.md. |
| 7 | Partner Integration Rollout (Post-V1) | completed | Closed and approved on 2026-03-18; see docs/wave-7-closure-signoff.md. |
| 8 | Production Hardening And Org Migration | completed | Closed on 2026-03-18; hardened image pipeline baseline, namespace normalization (`ghcr.io/olivierlegendre`), and `v0.2.0` pullability/readiness evidence are recorded (see docs/wave-8-closure-signoff.md). |


## Wave 0: Contract And Boundary Freeze

Scope:

- Freeze observed PoC behavior and define ownership boundaries.

Deliverables:

1. Contract inventory for API endpoints, MQTT topics, payload shapes, DB objects.
2. Golden dataset and golden response/event fixtures.
3. ADR pack for selected pattern set and rejected alternatives.
4. Ownership matrix by service and aggregate.

Acceptance criteria:

1. Contract inventory is complete and versioned.
2. Golden smoke suite passes in clean environment.
3. Ownership matrix has no unresolved aggregate.

Rollback:

- Not applicable (documentation and governance wave).

## Wave 1: Foundation And Security Baseline

Scope:

- Stand up shared runtime and mandatory security controls.

Deliverables:

1. `platform-foundation` baseline runtime and networking.
2. Keycloak realm, clients, role model and token validation baseline.
3. Vault operational baseline (go-live blocker).
4. PostgreSQL tenant isolation baseline (organization-level isolation).
5. Grafana OSS baseline dashboards and alert scaffolding.

Acceptance criteria:

1. Authn/authz checks pass at service boundary tests.
2. Secrets are not stored in code or plain env files outside approved bootstrap path.
3. Isolation tests prove cross-organization read/write denial.

Rollback:

- Keep PoC runtime path as temporary operational path while foundation hardening continues.

## Wave 2: `reference-api-service` Extraction (Python)

Pattern focus:

- Hexagonal boundaries + Repository/UoW/Data Mapper.

Scope:

- Move reference/mapping/link core logic out of Node-RED.

Deliverables:

1. Service skeleton with explicit domain/application/adapter boundaries.
2. Repository/UoW implementation for owned aggregates.
3. Compatibility adapter so existing flows call new service.
4. Backward-compatible error and validation contract behavior.

Acceptance criteria:

1. Regression parity for create/update/link/mapping workflows.
2. Existing clients run without breaking change unless versioned explicitly.
3. Known destructive mapping edge case is covered by tests and resolved.

Rollback:

- Feature flag route back to legacy path.

## Wave 3: `device-ingestion-service` Extraction (Python + `paho-mqtt`)

Pattern focus:

- Adapter/ACL for protocol normalization + Outbox for reliable publication.

Scope:

- Move ingestion and normalization from Node-RED to dedicated service.

Deliverables:

1. Protocol adapters for current ingestion sources.
2. Deterministic dedup and idempotent write path.
3. Structured logs, ingest metrics, and dead-letter handling policy.

Acceptance criteria:

1. Telemetry parity against golden baseline within agreed tolerance.
2. Duplicate suppression behavior is deterministic.
3. Ingestion latency budget is met for pilot load.

Rollback:

- Disable new consumer path and re-enable Node-RED ingest path.

## Wave 4: Command And Safety Plane

Pattern focus:

- Strategy by command class + Circuit Breaker/Retry/Bulkhead.

Scope:

- Externalize channel policy and safety governance from Node-RED.

Deliverables:

1. `channel-policy-router` with class-based policy matrix.
2. API primary with MQTT optional fallback policy enforcement.
3. Queueing, serialization, idempotency, and reconciliation controls matching V1 spec.
4. Incident and hold/resume integration points.

Acceptance criteria:

1. `422`, `503`, `Retry-After`, and safety restrictions behave exactly as spec.
2. Queue policy and safety-critical prioritization are test-verified.
3. Reconciliation SLA measurement is visible in dashboards.

Rollback:

- Toggle to API-only safe mode and hold non-safety execution if needed.

Wave 4 closure evidence:

- Frozen checkpoint: `docs/wave-4-closure-checkpoint.md`.
- Validation status: green on 2026-03-13 (lint, typecheck, unit/API tests, Postgres integration).

## Wave 5: Automation And Operator UI Decoupling

Scope:

- Move operations workflows fully into dedicated orchestration and UI.

Deliverables:

1. Camunda integration layer and workflow runtime paths.
2. `operator-ui` flows for approvals, incidents, reissue, and governance views.
3. Traceability and audit visibility for user actions.

Acceptance criteria:

1. Critical operational workflows run outside Node-RED core logic.
2. UI uses service APIs only; no direct SQL access.
3. End-to-end traceability available via correlation and command lineage.

Rollback:

- Read-only operator mode plus execution hold policy while fixing critical issues.

## Wave 6: Node-RED Retirement And Hardening

Scope:

- Remove residual critical dependency on Node-RED.

Deliverables:

1. Explicit list of remaining Node-RED flows and decommission decisions.
2. Runbooks for incident, rollback, and recovery per service.
3. SLO dashboards and alerting active for ingestion/API/command paths.
4. Execution backlog tracked in `docs/wave-6-execution-backlog.md`.
5. Baseline GHCR image publish workflows exist for all deployable service repos.

Acceptance criteria:

1. No critical business rule depends on Node-RED state.
2. Remaining Node-RED role is bridge-only or fully retired by decision.
3. Operational readiness checklist is green.
4. Pipeline-ready service images are published and pullable for deployment manifests.
5. Deferred image hardening items are explicitly tracked as post-baseline TODOs.

Rollback:

- Temporarily re-enable selected bridge paths only, with change-control approval.

## Wave 7: Partner Integration Rollout (Post-V1)

Scope:

- Add partner adapters without violating core ownership and policy boundaries.

Deliverables:

1. Schneider BACnet adapter (commissioning and read path first).
2. Tandem Connect adapter.
3. Siemens Building X API adapter.

Acceptance criteria:

1. Adapter contracts pass compatibility and isolation tests.
2. No adapter bypasses IAM, audit, or command policy controls.
3. Semantic mapping remains canonical at platform boundary.

Rollback:

- Disable adapter route and preserve canonical internal flows.

## Wave 8: Production Hardening And Org Migration

Scope:

- Convert post-baseline TODOs into enforced production gates and migrate temporary registry/org conventions.

Deliverables:

1. Image provenance/SBOM attestation and verification gate in CI.
2. Vulnerability scanning policy gate with agreed fail thresholds.
3. OIDC least-privilege publish identity for image pipelines.
4. Registry namespace/casing normalization and enforcement on `ghcr.io/olivierlegendre/...`.
5. Updated deployment manifests, release gates, and runtime credential validation after migration.

Acceptance criteria:

1. All service image pipelines publish attestations and pass verification checks.
2. Security scan gate blocks release on configured high/critical findings.
3. No PAT-based publish flow remains in release pipelines (OIDC only).
4. Production manifests and pullability proofs are green against `ghcr.io/olivierlegendre/...`.
5. Rollback path to previous trusted image set is documented and tested.

Rollback:

- Revert to last signed/pullable image set and previous manifest namespace while preserving audit trail.

## 5. Cross-Wave Quality Gates

Required for each merge:

1. Lint, typecheck, unit tests.
2. Integration tests at service boundaries.
3. Backward compatibility checks for API/schema/topic contracts.
4. Migration and rollback verification for DB-impacting changes.
5. Observability checks on new critical paths.
6. Security checks for authz, secrets, and tenant isolation.

## 6. Architecture Options Reviewed

Option A: Keep Node-RED as primary runtime and refactor internally.

1. Pros:
- Fast short-term execution.

2. Cons:
- Persistent coupling and lower long-term change safety.

Option B: Pattern-driven strangler extraction (selected).

1. Pros:
- Clear ownership boundaries, better testability, safer progressive rollout.

2. Cons:
- Higher up-front governance effort.

Decision:

- Option B is selected.

## 7. Program Exit Criteria

Migration is complete when all statements are true:

1. `reference-api-service` and `device-ingestion-service` run as independent deployable services.
2. Command and fallback governance executes outside Node-RED core runtime.
3. Canonical contracts are versioned and enforced by CI.
4. Security baseline is complete, including Vault and DB-level tenant isolation.
5. Operator workflows are served from `operator-ui` and orchestration runtime.
6. Runbooks cover rollback and incident operations for each production service.
