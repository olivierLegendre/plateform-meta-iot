# V1 System Specification

Status: Draft v1.0  
Date: 2026-03-11  
Owner: Platform Architecture

## 1. Purpose

This document defines the full V1 scope for the platform, based on validated project decisions.
It is the implementation contract for architecture, security, behavior, and operations.

## 2. Scope

V1 includes all core platform capabilities except partner integrations.

Included in V1:

- Multi-tenant platform foundations.
- Identity and access management with Keycloak.
- Device ingestion, reference API, command orchestration, and operator UI.
- Command governance, fallback behavior, incident handling, and observability.
- DB-level tenant isolation.

Excluded from V1:

- Partner adapters runtime integration (Schneider, Tandem, Siemens).
- GDPR data-subject operations (export/delete/anonymize).
- Tamper-evident hash-chained audit log implementation.

Post-V1 partner rollout order:

1. Schneider BACnet adapter.
2. Tandem Connect adapter.
3. Siemens Building X API adapter.

## 3. Guiding Architecture Decisions

1. Migration strategy: strangler approach (progressive extraction, no big-bang rewrite).
2. Backend default language: Python.
3. MQTT client library: `paho-mqtt`.
4. Workflow orchestration: Camunda, with TypeScript integration layer.
5. Operator UI: Vue.js (Vue 3 + Vite).
6. Observability: Grafana OSS in V1, Metabase later.
7. Node-RED strategy:
  - Temporary integration or edge bridge only during migration.
  - No core business logic in Node-RED by V1 GA.

## 4. Target Component Model

## 4.1 Platform components

1. `platform-foundation`
- Shared infrastructure runtime.
- Networking, runtime baselines, deployment primitives.
- Vault and security baseline.

2. `identity-access`
- Keycloak realm, clients, roles, scopes, policies.
- Token issuance and authorization integration.

3. `reference-api-service` (Python)
- Device references, mappings, links, semantic metadata, command APIs.
- Path versioning and compatibility policy.

4. `device-ingestion-service` (Python)
- MQTT ingestion, normalization, deduplication, metric persistence.

5. `automation-scenario-service`
- Camunda process execution and workflow governance.
- TypeScript integration workers for Camunda interaction.

6. `operator-ui` (Vue.js)
- Operational workflows, approvals, incidents, reissue actions, governance screens.

7. `channel-policy-router`
- Channel selection logic (API primary, MQTT fallback policy).
- Retry, timeout, failover, and idempotency orchestration.

8. `notifications-service` (can be integrated in V1 runtime if needed)
- In-app and email notifications.
- Retry policy and delivery status tracking.

## 4.2 Data runtime

1. One shared PostgreSQL cluster.
2. Separate database and schema per service.
3. Separate least-privilege DB role per service.

## 5. Tenant, Asset, and Semantic Model

## 5.1 Tenancy layers

Business tenancy:

`customer -> organization -> site`

Physical model:

`site -> building -> floor -> space -> equipment -> point`

## 5.2 Semantics and standards

1. Semantic modeling aligns with Brick.
2. Units must be SI for operations and display.
3. Persist QUDT-compatible unit identifiers alongside SI display text.

## 5.3 Isolation and access boundaries

1. Hard data isolation boundary is organization-level.
2. Access is site-scoped by default.
3. Cross-site access requires explicit multi-site grants.

## 6. Identity and Authorization

## 6.1 IAM baseline

1. Keycloak is mandatory in V1.
2. MFA is out of V1, with medium-priority backlog for `approver` and `org_admin`.

## 6.2 Role model

Human roles:

- `viewer`
- `operator`
- `approver`
- `scenario_publisher`
- `site_admin`
- `org_admin`

Machine actors:

- service accounts

Scope rules:

1. `org_admin` is organization-scoped.
2. All other human roles are site-scoped.
3. Service accounts are site-scoped by default.
4. Service accounts can be organization-scoped only by explicit exception and justification.

## 7. Command Domain Specification

## 7.1 Command classes

1. `safety_critical`
2. `interactive_control`
3. `routine_automation`
4. `bulk_non_critical`

## 7.2 Channel policy

Global principles:

1. API is primary channel.
2. MQTT is fallback only where policy allows.
3. API and MQTT are implemented by separate components.

Per-class policy:

1. `safety_critical`
- API only.
- MQTT fallback never allowed.

2. `interactive_control`
- API primary.
- Automatic MQTT fallback on API timeout or transient failure.

3. `routine_automation`
- API primary.
- Automatic MQTT fallback on API timeout or transient failure.

4. `bulk_non_critical`
- API only by default.
- No MQTT fallback by default.

## 7.3 Execution policy matrix

`safety_critical`:

- API timeout per attempt: 5 seconds.
- API attempts total: 2.
- MQTT retries: not applicable.
- TTL: 60 seconds.
- Reconciliation SLA (`accepted -> applied_confirmed`): 60 seconds.
- Success requires observed-state confirmation.
- SLA breach action: auto-fail, immediate high-severity alert, manual action required.

`interactive_control`:

- API timeout before fallback: 3 seconds.
- API attempts before fallback: 1.
- MQTT retries after fallback: 2.
- TTL: 120 seconds.
- Reconciliation SLA: 60 seconds.

`routine_automation`:

- API timeout before fallback: 10 seconds.
- API attempts before fallback: 2.
- MQTT retries after fallback: 3.
- TTL: 10 minutes.
- Reconciliation SLA: 5 minutes.

`bulk_non_critical`:

- API timeout per attempt: 30 seconds.
- API retries: 3.
- MQTT fallback: none by default.
- TTL: 60 minutes.
- Reconciliation SLA: 30 minutes.

## 7.4 Idempotency and correlation

Idempotency:

1. Dedup window: 1 hour.
2. Uniqueness scope: per site.
3. Platform generates missing idempotency keys for non-safety classes.
4. `safety_critical` requires client-provided idempotency key; missing key returns `422`.

Correlation:

1. Platform generates missing `correlation_id` for non-safety classes.
2. `safety_critical` requires client-provided `correlation_id`; missing ID returns `422`.
3. `correlation_id` uniqueness: per site for 24 hours.
4. Duplicate correlation returns `409` with existing command reference.

## 7.5 Mutability and cancellation

1. Commands are immutable after `accepted`.
2. Changes are handled by cancel-and-reissue only.
3. Cancel is allowed only before dispatch for all command classes.

## 7.6 Serialization and queueing

1. Strict serialization per point (single in-flight command).
2. New commands for busy points are queued.
3. Queue backend: PostgreSQL (durable queue).
4. Queue durability survives service restarts.
5. Queue max depth per point: 5.
6. Overflow behavior:
- return `503 Service Unavailable`
- include current queue depth
- include `Retry-After` header (relative seconds)
- fixed `Retry-After` value: 30

Queue ordering:

1. FIFO within normal execution.
2. Queue can be reordered to prioritize `safety_critical`.
3. If a non-safety command is already in-flight when safety arrives:
- do not preempt in-flight command
- wait for completion
- execute safety next
- emit high-priority delay audit event
- page immediately off-hours

Persistence failure behavior:

1. Fail-safe mode: accept no new commands.
2. Alert immediately.
3. Never silently lose queued data.

## 7.7 Override policy

1. Channel override rights: `org_admin` and designated operations role.
2. Overrides require mandatory reason.
3. Ticket or external reference is optional.

## 7.8 Reissue and lineage

1. Reissue requires a new idempotency key.
2. Reissue requires a new correlation ID.
3. Lineage field is standardized as `parent_command_id`.
4. `parent_command_id` applies to manual reissues and automatic retry or fallback attempts.
5. Automatic retries and fallback update the same command record (no child command records).

## 8. Incident and Safety Governance

## 8.1 Incident lifecycle

1. Incidents are created automatically for safety events.
2. Lifecycle states: `open`, `mitigating`, `resolved`.
3. Incident records are append-only.
4. Incident closure requires mandatory resolution note.
5. Reopening uses the same incident ID and requires mandatory reopen note.

## 8.2 Root-cause policy

Root-cause category is mandatory at resolution.

Default categories:

- `partner_outage`
- `network_issue`
- `mapping_error`
- `operator_error`
- `platform_bug`
- `unknown`

## 8.3 Escalation policy

Page acknowledgement SLA:

- 15 minutes before escalation.

Escalation chain:

1. `T+0`: primary safety on-call.
2. `T+15`: secondary safety on-call and site duty manager.
3. `T+30`: organization admin and incident manager.
4. `T+45`: external BMS integrator emergency contact (if configured).

At `T+30`:

1. Freeze of non-safety execution requires manual confirmation.
2. While waiting for manual confirmation:
- new non-safety commands are accepted
- execution is held
3. Held commands auto-expire after 60 minutes with status `expired_due_to_safety_incident`.

After incident resolution:

1. Expired commands are manual reissue only (no auto replay).
2. Reissue wizard is available in `operator-ui` with pre-filled data.
3. Resume authority for non-safety execution: `org_admin` and `site_admin`.
4. Resume does not require mandatory reason.
5. Resume does not require two-person approval.
6. Post-resume execution continues in FIFO order.
7. Bulk-cancel held commands is allowed.

## 8.4 Notification policy

1. Immediate notifications: in-app and email.
2. Recipients are configurable per site.
3. Email content defaults to incident summary and link (not full payload).
4. Email retry policy: 3 retries over 15 minutes, then mark failed.
5. Notification and incident exports:
- `org_admin`: organization scope
- `site_admin`: site scope only

## 9. API Contract and Versioning

## 9.1 Versioning

1. API path versioning is mandatory (`/api/v1/...`).
2. Major version migration supports 90-day overlap.

## 9.2 Deprecation behavior during overlap

1. Use standard deprecation headers:
- `Deprecation`
- `Sunset`
- `Link`
2. Include warnings in both headers and response body.
3. Warning body format is structured with required fields:
- `code`
- `message`
- `sunset_at`
- `replacement`
- `docs_url`
4. Warnings apply to `2xx` and `4xx`.
5. Warnings are not added to `5xx`.
6. Overlap enforcement uses calendar-day policy with fixed UTC cutoff on day 90.

## 9.3 End of overlap

1. Deprecated endpoints return `410 Gone`.
2. `410` responses include machine-readable migration hints.
3. Every major release requires versioned migration documentation URL
   (example: `/docs/api/migrations/v1-to-v2`).

## 10. Data Governance and Compliance

## 10.1 Retention

1. Command and approval logs: 24 months.
2. Incident logs: 24 months.
3. Telemetry and metrics:
- hot data: 90 days
- cold archive: 24 months

## 10.2 Data residency

1. EU-only residency in V1.

## 10.3 PII handling

1. Exports mask PII by default.
2. Explicit unmask requires authorized `org_admin`.
3. Every unmask action is audited.

## 10.4 Subject-rights operations

1. GDPR-style export/delete/anonymize is out of V1.
2. Planned as post-V1 backlog item.

## 11. Security and Secrets

## 11.1 V1 mandatory baseline

1. Vault is in V1 scope.
2. Vault is a go-live blocker for first production customer.
3. TLS in transit is required.

## 11.2 Post-V1 hardening backlog

1. MFA for `approver` and `org_admin` (medium priority).
2. Tamper-evident audit log chains.

## 12. Isolation and Database Security

DB-level tenant isolation is required in V1.

Minimum implementation:

1. `organization_id` mandatory on tenant-owned records.
2. PostgreSQL row-level security policies by organization.
3. Per-request tenant context set in DB session.
4. Cross-organization FK or relationship prevention constraints.
5. Least-privilege roles per service.

## 13. Reliability and Operations

1. Core API availability SLO: 99.5% monthly.
2. Observability includes distributed tracing from day one.
3. Incident response coverage: business hours for standard operations.
4. Off-hours safety failures page immediately.
5. Disaster recovery targets:
- RTO: 24 hours
- RPO: 1 hour
6. Deployment topology: single region in V1.

## 14. Partner Integration Policy (Post-V1)

1. Partner integration layer is required, but not in V1 delivery scope.
2. First adapter rollout order:
- Schneider BACnet
- Tandem Connect
- Siemens Building X API

First Schneider integration mode:

1. Read-only first.
2. Write or control only after formal commissioning gate:
- mapping validation
- point quality checks
- failover test
- approval sign-off

## 15. Pilot Strategy

1. First rollout target: one pilot organization.
2. Pilot duration and KPI thresholds: TBD.
3. Pilot rollback trigger thresholds: TBD.
4. Pilot command-policy baseline follows this specification.

## 16. Open Items

1. Pilot timeline and KPI success criteria.
2. Pilot rollback trigger thresholds and operator runbook details.
3. Final production incident communications matrix per organization.

