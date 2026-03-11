# Target Architecture And Migration Plan

Status: Draft v0.2  
Date: 2026-03-11  
Baseline: `/home/olivier/Public/poc`

Companion documents:

1. Detailed V1 specification: `docs/v1-system-specification.md`
2. BDD use-case suite: `docs/bdd/README.md`
3. Multi-repo setup and governance: `docs/multi-repo-operating-model.md`

## 0. Locked Decisions Snapshot

1. V1 includes all core capabilities except partner runtime integrations.
2. Node-RED is migration-only integration or edge glue and cannot host core logic at V1 GA.
3. Stack choices are fixed: Python services, `paho-mqtt`, Next.js operator UI, Camunda with
TypeScript integration layer, Keycloak IAM, Grafana OSS.
4. Vault is mandatory in V1 and blocks first production go-live if missing.
5. DB-level tenant isolation in PostgreSQL is required in V1.
6. API path versioning with 90-day overlap and deprecation warnings is required.
7. Post-V1 partner integration rollout order is Schneider BACnet first, Tandem Connect second,
Siemens Building X API third.

## 1. Current PoC Snapshot

The PoC currently centralizes ingestion, API, mapping logic, and dashboard behavior in Node-RED.
Important observations from the baseline:

1. Clear logic split already exists through `domain` and `repo` libraries loaded in
   `functionGlobalContext`.
2. API endpoints already exist for device references, mappings, and links.
3. Runtime scenario logic is partially hardcoded to specific device names/topics.
4. Mapping replacement flow can be destructive if payload validation is bypassed by shape.

This is a good base for extraction because interfaces are visible, even if runtime boundaries are
still coupled.

## 2. Target Architecture

## 2.1 High-level topology (current target)

1. `plateform-meta-iot`: orchestrator, standards, contract governance, and integration CI.
2. `platform-foundation`: shared runtime infrastructure, networking, and secrets baseline.
3. `identity-access`: Keycloak configuration and policy governance.
4. `iot-reference-api`: reference/mapping APIs and semantic governance.
5. `iot-ingestion-service`: MQTT intake, normalization, deduplication, and metric persistence.
6. `automation-scenario-service`: workflow orchestration through Camunda.
7. `channel-policy-router`: API-primary channel policy and fallback execution.
8. `operator-ui`: Next.js operational user interface.
9. `partner-integration-layer` (post-V1): external adapters for Schneider, Tandem, Siemens.

## 2.2 Boundary rules

1. Transport adapters (HTTP/MQTT) never embed business rules.
2. Domain services own validation and orchestration decisions.
3. Repositories own SQL and transaction boundaries.
4. Cross-service communication uses versioned contracts only.
5. No direct DB access from UI/service clients outside their ownership rules.

## 2.3 Data ownership (target)

1. `iot-ingestion-service` owns write path for `devices`, `telemetry`, `metrics`.
2. `iot-reference-api` owns `device_reference*` and mapping lifecycle.
3. Read models can be shared, but write ownership is single-service per aggregate.

## 3. Migration Phases

Each phase includes rollback and acceptance criteria. Do not start next phase until current
acceptance is green.

## Phase 0: Freeze and baseline

Scope:

- Freeze PoC behavior and capture contracts.

Deliverables:

1. Contract inventory (topics, payloads, endpoints, DB objects).
2. Golden dataset and golden API responses for regression comparison.
3. CI smoke workflow in meta-project.

Acceptance criteria:

1. Baseline smoke checks pass reproducibly on a clean environment.
2. All current API endpoints have request/response examples versioned in repo.
3. Rollback script documented and validated once.

## Phase 1: Contract-first extraction prep

Scope:

- Formalize contracts before moving code.

Deliverables:

1. OpenAPI for reference APIs.
2. JSON Schema/AsyncAPI-style definitions for MQTT payloads.
3. DB ownership matrix by table.

Acceptance criteria:

1. Contract lint checks run in CI.
2. Compatibility tests verify current PoC behavior against contract docs.
3. Any contract drift fails CI.

## Phase 2: Extract `iot-reference-api`

Scope:

- Move reference/mapping/link business logic out of Node-RED.

Deliverables:

1. New API service with hexagonal layers.
2. Repository + Unit of Work implementation for reference aggregates.
3. Compatibility adapter: Node-RED calls new API instead of local logic.

Acceptance criteria:

1. Existing clients can call same endpoint semantics with no functional regressions.
2. Validation and error model remain backward compatible (or versioned explicitly).
3. Integration tests pass for create/update/link/mapping replace workflows.
4. Destructive mapping edge case is fixed and tested.

Rollback:

- Switch Node-RED back to local API path behind a feature flag.

## Phase 3: Extract `iot-ingestion-service`

Scope:

- Move MQTT normalization/dedup/mapping materialization out of Node-RED.

Deliverables:

1. Ingestion worker service with domain adapters for Zigbee and LoRaWAN.
2. Idempotent write path and dedup policy tests.
3. Operational metrics and structured logs.

Acceptance criteria:

1. Metric counts and key field values match baseline within agreed tolerance.
2. End-to-end latency budget is met (define target in CI benchmarks).
3. Duplicate suppression behavior is deterministic and tested.

Rollback:

- Disable worker consumer group and re-enable Node-RED ingestion flow.

## Phase 4: Operator UI and command governance decoupling

Scope:

- Move UI, approvals, and incident operations to `operator-ui`.

Deliverables:

1. UI pages read from APIs/services only.
2. Command approval and incident flows are run outside Node-RED.

Acceptance criteria:

1. All critical operational views are available in `operator-ui`.
2. No direct domain SQL in UI layer.
3. User actions are traceable via logs and correlation ids.

## Phase 5: Harden and remove residual coupling

Scope:

- Security, observability, and cleanup.

Deliverables:

1. Auth/authz strategy for admin and APIs.
2. SLO dashboards and alerting for critical flows.
3. Decommission plan for obsolete Node-RED logic and bridge-only operation enforcement.

Acceptance criteria:

1. Security checks enabled by default (no insecure admin defaults).
2. Error budgets and SLOs tracked for ingestion/API paths.
3. Residual Node-RED business logic reduced to agreed target or zero.

## Phase 6: Partner integration rollout (post-V1)

Scope:

- Add external partner adapters without breaking core platform boundaries.

Deliverables:

1. Schneider BACnet adapter with read-only commissioning first.
2. Tandem Connect adapter for digital twin synchronization flows.
3. Siemens Building X API adapter for API-driven integration.

Acceptance criteria:

1. Each adapter passes contract and isolation tests.
2. Commands and telemetry remain canonicalized through platform semantic model.
3. No adapter bypasses core authorization or audit policies.

## 4. Cross-Phase Quality Gates

Required for each merge:

1. Lint + typecheck + unit tests.
2. Integration tests at service boundaries.
3. Backward compatibility checks for API and schemas.
4. Migration and rollback verification for DB-affecting changes.
5. Observability checks for new critical paths.

## 5. Alternative Architecture Considered

Alternative: keep Node-RED as the primary runtime and only refactor internals.

Pros:

1. Faster short-term delivery.
2. Lower initial migration effort.

Cons:

1. Persistent runtime coupling.
2. Harder independent scaling/testing/deployment per concern.
3. Higher long-term change risk for critical business rules.

Decision:

- Prefer service extraction with the meta-project orchestrator because it improves boundaries,
  testability, and controlled evolution.

## 6. Final Acceptance (Program Exit Criteria)

Migration is complete when all statements are true:

1. Core ingestion and reference APIs run in independent deployable services.
2. Canonical contracts are versioned and enforced by CI.
3. PoC scenarios are reproducible from meta-project orchestration only.
4. No critical business rule depends on Node-RED function node state.
5. Runbooks include on-call troubleshooting and rollback for each service.
