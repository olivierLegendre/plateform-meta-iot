# Baseline Snapshot (Single Page)

Last updated: 2026-03-13
Purpose: quick context re-anchor after long sessions or context compaction.

## 1) Mission
- Evolve the PoC into an industrial BMS platform.
- Decouple concerns and refactor with a strangler pattern.
- Keep platform-wide coherence across independent service repositories.

## 2) Locked Product/Architecture Decisions
1. V1 includes all core platform capabilities except partner adapters (post-V1).
2. Multi-customer, multi-organization, multi-building is required from day one.
3. Node-RED is migration-only (integration or edge glue); no core business logic in Node-RED at V1 GA.
4. Backend default is Python; MQTT ingestion uses `paho-mqtt`.
5. Camunda is the workflow engine, with a TypeScript integration layer; business services stay Python.
6. Operator UI stack is Next.js.
7. IAM/IdP is Keycloak from the beginning.
8. Vault is in V1 scope and is a go-live blocker.
9. Observability uses Grafana OSS in V1.
10. Semantic model aligns with Brick (SI units).
11. API is primary command channel; MQTT is optional fallback by policy.
12. API and MQTT are handled by separate components.

## 3) Scope and Boundaries
- API and MQTT are both supported.
- Schneider first integration path targets BACnet.
- Tandem target is Tandem Connect first.
- Partner adapters are deferred to post-V1 rollout.

## 4) Target Components
- `platform-foundation`
- `identity-access` (Keycloak config/policy)
- `device-ingestion-service`
- `reference-api-service`
- `automation-scenario-service` (Camunda-backed)
- `channel-policy-router` (API-primary fallback orchestration)
- `operator-ui` (Next.js)
- `partner-integration-layer` (post-V1)

## 5) Tenancy and Isolation
- Tenancy hierarchy: `customer -> organization -> site`.
- Asset hierarchy: `site -> building -> floor -> space -> equipment -> point`.
- Hard isolation boundary: organization.
- Access defaults to site scope.
- DB-level isolation is required in V1 (RLS and tenant guards), in addition to app-level controls.

## 6) Command and Safety Baseline
- Command classes: `safety_critical`, `interactive_control`, `routine_automation`, `bulk_non_critical`.
- `safety_critical`:
  - API only (no MQTT fallback).
  - Client must provide idempotency key and correlation_id; missing values return `422`.
- For non-safety classes, platform can generate missing keys/IDs.
- Idempotency dedup scope: per site, 1 hour.
- Correlation uniqueness scope: per site, 24 hours.
- Command mutability: immutable after accepted; cancel-and-reissue model.
- Cancel allowed only before dispatch.
- Serialization: strict; queueing enabled.
- Queue policy: FIFO with allowed reordering for `safety_critical`.
- Queue saturation behavior: reject new commands with `503` and `Retry-After: 30` seconds.

## 7) Incident Governance Baseline
- Fail-safe mode during incident: accept nothing new and alert immediately (no silent loss).
- Incidents are append-only records.
- Off-hours paging is immediate.
- Resume after safety incident requires manual confirmation.
- Hold expiration window: 60 minutes.
- Explicit expiry reason includes `expired_due_to_safety_incident`.

## 8) API Versioning and Deprecation
- Path versioning is mandatory (`/api/v1/...`).
- 90 calendar-day overlap for old/new major versions.
- During overlap: explicit deprecation warning object + standard deprecation headers.
- After overlap: `410 Gone` + machine-readable migration hint.

## 9) Security Baseline
- Vault in V1 scope (mandatory).
- TODOs explicitly tracked: TLS in transit, encrypted backups, dedicated secret handling hardening.
- MFA for `approver` and `org_admin`: medium-priority commitment.

## 10) Delivery Model
- Multi-repo operating model is the target.
- Meta repo keeps shared governance/docs/scripts.
- Service repos are generated under a common `iot_services/` parent.
- Migration execution uses the wave model in `docs/target-architecture-and-migration.md`.

## 11) Post-V1 Items
- Partner integration rollout order: Schneider BACnet adapter, Tandem Connect adapter, Siemens Building X API adapter.
- Metabase optional for ad-hoc BI.

## 12) Current Delivery Status
- Wave 4 (Command and Safety Plane) is frozen and validated.
- Wave 5 is in progress (automation service scaffold + operator-ui route scaffold done; integration hardening pending).
- Evidence: `docs/wave-4-closure-checkpoint.md`.
- Status source of truth: `docs/target-architecture-and-migration.md` Wave Status Matrix.

## 13) How To Use This File
- Read this file first when starting a new session.
- If any decision here conflicts with detailed docs, update this file immediately after final decision.
- Keep this page concise and decision-oriented; detailed rationale stays in architecture/spec docs.
