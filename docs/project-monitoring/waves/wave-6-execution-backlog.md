# Wave 6 Execution Backlog (Ordered)

Date: 2026-03-17
Scope: Node-RED retirement and hardening

## 1. Priority Model

- `P0`: release-blocking risk on safety, data integrity, or security.
- `P1`: required for Wave 6 acceptance, but not immediate safety blocker.
- `P2`: quality and operations improvements that can trail Wave 6 close.

## 2. Backlog (Dependency Order)

| ID | Priority | Work item | Owner repo | Depends on | Done when |
| --- | --- | --- | --- | --- | --- |
| W6-01 | P0 | Freeze Node-RED to bridge-only mode with explicit allowlist of permitted flows/topics (implemented baseline: managed bridge flow + CI gate + PoC non-compliance evidence kept for migration tracking) | `platform-foundation` | none | Node-RED cannot execute domain/business function paths outside allowlist |
| W6-02 | P0 | Cut over ingestion paths from Node-RED handlers to `device-ingestion-service` only (started: extraction + executable cutover preview script + action report + preview flow audit evidence) | `device-ingestion-service` | W6-01 | MQTT ingest + normalization + persistence run through service; Node-RED ingest handlers disabled |
| W6-03 | P0 | Cut over reference/mapping HTTP paths to `reference-api-service` and disable duplicate Node-RED API endpoints (started: extraction + executable cutover preview script + action report + preview flow audit evidence) | `reference-api-service` | W6-01 | Node-RED HTTP endpoints for reference CRUD/list/link/mapping are disabled |
| W6-04 | P0 | Move scenario-triggered command routing fully to `automation-scenario-service` + `channel-policy-router` (started: extraction + executable cutover preview script + action report + preview flow audit evidence) | `automation-scenario-service`, `channel-policy-router` | W6-01 | No command decision/routing logic left in Node-RED |
| W6-05 | P1 | Replace Node-RED dashboard SQL aggregation paths with operator-ui/Grafana service-backed reads (started: extraction + executable cutover preview script + action report + preview flow audit evidence) | `operator-ui`, service owners | W6-02, W6-03 | Dashboard views use service APIs or approved read models; Node-RED dashboard functions retired |
| W6-06 | P0 | Enforce production JWT verification profile (issuer/audience on, env-specific config) (implemented in auth config builder + strict env mode in both services) | `automation-scenario-service`, `channel-policy-router` | none | Mutation endpoints reject tokens with wrong issuer/audience |
| W6-07 | P0 | Vault bootstrap integration for runtime secrets (remove plaintext fallback assumptions in deploy path) (implemented: Vault contract/renderer/validator artifacts + compose wiring example + non-dev default-secret guard in JWT services) | `platform-foundation`, all services | none | Service startup in non-dev relies on Vault-injected secrets |
| W6-08 | P1 | Service runbooks: incident, rollback, recovery (implemented baseline: service-specific runbooks + README links + automated verification report) | each service repo + meta docs | W6-02, W6-03, W6-04 | Runbooks exist, reviewed, and linked from meta docs |
| W6-09 | P1 | SLO + alerting activation for ingest/API/command critical paths (implemented baseline: observability metric mapping + alert routing + wiring verifier + PASS report in platform-foundation) | `platform-foundation`, service owners | W6-02, W6-03, W6-04 | Alert rules active and tested with synthetic breach checks |
| W6-10 | P2 | Remove temporary bridge and retire Node-RED runtime from production topology (started: executable retirement cutover preview + one-command topology release gate + readiness evaluator + managed-manifest PASS report + legacy-PoC FAIL gap report) | `platform-foundation` | W6-05, W6-08, W6-09 | Node-RED not required for production operation |
| W6-11 | P1 | Baseline GHCR image publish workflows for all service repos with explicit deferred hardening TODOs (implemented baseline in service `.github/workflows/image-publish.yml`) | service repos + meta docs | none | Tag-triggered/manual workflows can publish pullable images; deferred hardening TODOs are documented |

## 3. Verification Gates Per Item

Each backlog item closes only if all are true:

1. Lint/type/unit/integration checks are green in owning repo.
2. Contract artifacts are regenerated when endpoints/topics change.
3. Rollback command is documented and tested.
4. Evidence is recorded in Wave 6 checkpoint.

## 4. Suggested Execution Sequence

1. `W6-01` bridge-only freeze.
2. `W6-02`, `W6-03`, `W6-04` in parallel where possible.
3. `W6-06`, `W6-07` security hardening completion.
4. `W6-05` dashboard/read path migration.
5. `W6-08`, `W6-09` operations readiness.
6. `W6-11` baseline image pipeline readiness + deferred hardening tracking.
7. `W6-10` final retirement.
