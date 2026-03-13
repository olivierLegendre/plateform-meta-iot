# Meta-Project Charter

Status: Draft v0.4
Date: 2026-03-13  
Owner: Platform team

Companion documents:

1. Detailed V1 specification: `docs/v1-system-specification.md`
2. BDD use-case suite: `docs/bdd/README.md`
3. Multi-repo setup and governance: `docs/multi-repo-operating-model.md`
4. Target migration waves: `docs/target-architecture-and-migration.md`
5. Fast context anchor: `docs/baseline-snapshot.md`
6. Wave 4 closure checkpoint: `docs/wave-4-closure-checkpoint.md`

## 1. Mission

Create a meta-project that orchestrates several IoT subprojects, shares context between them,
and guarantees functional and data coherence across the platform.

The current PoC is the baseline. It already runs end-to-end, but concerns are coupled in one
runtime (Node-RED + dashboard + API + ingestion). The meta-project formalizes boundaries,
contracts, and integration governance.

## 2. Objectives

1. Separate concerns into explicit subprojects with clear ownership.
2. Preserve current PoC behavior while extracting services incrementally.
3. Define canonical contracts (events, schemas, APIs) as the shared truth.
4. Keep local developer experience simple (single orchestration entrypoint).
5. Enforce quality gates (lint, typecheck, tests, observability) before merge.

## 2.1 Locked Baseline Decisions

1. V1 includes all core platform capabilities except partner integrations.
2. Multi-customer, multi-organization, multi-building scope is required from day one.
3. Node-RED is temporary integration or edge bridge only during migration.
4. No core API, domain, or command logic can remain in Node-RED at V1 GA.
5. Backend default language is Python (`paho-mqtt` for MQTT ingestion).
6. Workflow orchestration uses Camunda with a TypeScript integration layer.
7. Operator UI uses Next.js.
8. IAM uses Keycloak from the beginning.
9. Vault is in V1 scope and is a production go-live blocker.
10. API is primary command channel; MQTT is optional fallback by explicit policy.
11. API and MQTT responsibilities must be separated into distinct components.
12. Partner integrations are post-V1, with rollout order: Schneider BACnet adapter first,
Tandem Connect adapter second, Siemens Building X API adapter third.

## 3. Scope

In scope:

- Multi-project orchestration (local and CI).
- Contract governance (MQTT topics, API schema, DB schema ownership).
- Progressive extraction of API and ingestion from Node-RED.
- Integration testing across all subprojects.
- Documentation, ADRs, and migration runbooks.
- DB-level tenant isolation in PostgreSQL.
- Incident governance, command SLA governance, and explicit fallback policies.
- API path versioning with deprecation lifecycle.

Out of scope (V1):

- Partner adapters runtime integration.
- GDPR-style data-subject workflows (export/delete/anonymize).
- Tamper-evident hash-chained audit logs.

## 4. Guiding Principles

1. Hexagonal architecture per service (transport -> domain -> infrastructure).
2. Domain logic must stay framework-agnostic.
3. Repository + Unit of Work at persistence boundaries.
4. Adapter + ACL boundaries for partner/protocol integration.
5. Backward compatibility first during migration.
6. No hidden side effects or mutable shared global state.

## 5. Subproject Model

## 5.1 `plateform-meta-iot` (this repository)

Role:

- Orchestrator and coherence layer.

Responsibilities:

- Compose profiles and environment templates.
- Shared contracts and compatibility matrix.
- End-to-end test harness and smoke checks.
- Architecture docs, ADRs, and migration governance.

Must not contain:

- Business logic for ingestion, API rules, or device behavior.

## 5.2 `identity-access`

Role:

- Identity and authorization platform capability.

Owns:

- Keycloak realm, client, role, and policy governance.

## 5.3 `device-ingestion-service`

Role:

- Consume MQTT events, normalize payloads, apply mapping, persist telemetry/metrics.

Owns:

- Ingestion domain rules.
- Idempotency and dedup logic.
- Mapping application pipeline.

## 5.4 `reference-api-service`

Role:

- Expose and manage device references, mappings, links, and command API contracts.

Owns:

- Validation and business rules for reference lifecycle.
- API contract and versioning.

## 5.5 `automation-scenario-service`

Role:

- Process orchestration and approval workflows.

Owns:

- Camunda process definitions and workflow runtime integration.

## 5.6 `operator-ui`

Role:

- Visualization, command operations, approvals, and incident operations.

Owns:

- UI concerns only, no domain persistence logic.

## 5.7 `channel-policy-router`

Role:

- Channel governance and fallback orchestration.

Owns:

- API-primary routing, MQTT fallback policy execution, retries, and failover decisions.

## 5.8 `partner-integration-layer` (post-V1 rollout)

Role:

- External BMS and digital twin integrations via dedicated adapters.

## 6. Shared Contract Governance

Contract categories:

1. Event contracts: MQTT topics and payload schemas.
2. API contracts: OpenAPI schemas and error model.
3. Data contracts: owned DB tables, migration strategy, compatibility policy.

Rules:

1. Any contract change requires versioned changelog entry.
2. Breaking changes require migration notes and compatibility tests.
3. Subprojects consume contracts through generated or pinned artifacts.

## 7. Delivery and Governance

Cadence:

- Architecture review per migration wave.
- Weekly migration checkpoint.

Required artifacts per wave:

1. ADRs for boundary decisions.
2. Updated compatibility matrix.
3. Test evidence (unit + integration + e2e smoke).
4. Rollback procedure and verification.

## 8. Success Metrics

1. No regression on existing PoC core scenarios.
2. >= 90% of domain rules moved out of Node-RED function nodes by end of migration.
3. API compatibility maintained for current clients during transition.
4. Mean time to identify cross-project integration failures < 30 minutes in CI.
5. Core API monthly availability target of 99.5% in V1 operations.

## 9. Definition of Done (Meta-Project Level)

Done when:

1. Orchestrator starts all subprojects reproducibly with one command profile.
2. Canonical contracts are versioned and validated in CI.
3. Migration waves pass acceptance criteria and rollback checks.
4. Node-RED is reduced to orchestration or edge glue, or retired by explicit decision.
