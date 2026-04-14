# Service Readiness Tracker

> AUTHORITATIVE (EXECUTION): This document is part of the project-monitoring baseline and is authoritative for implementation status, blockers, and evidence tracking.

Date: 2026-04-14
Owner: Platform team
Purpose: track readiness closure work service-by-service until production gates are met.
Last verification cycle: 2026-04-14 (`platform-foundation` closure pass)

Status legend:
- `not_started`
- `in_progress`
- `done`
- `blocked`

## 1. Global Dashboard

| Service | Readiness | Why | Items total | Items done | Progress |
| --- | --- | --- | ---: | ---: | ---: |
| `platform-foundation` | Partial | Wave 1/Wave 6/Wave 8 gates are PASS with fresh evidence, shared Postgres ownership tracking is in place, and repo clean-state is confirmed. Remaining open item: production TODO placeholder closure in manifest policy flow. | 4 | 3 | 75% |
| `identity-access-config` | Partial | Keycloak baseline scripts validated locally, but CI drift control and non-dev import evidence remain open. | 3 | 0 | 0% |
| `reference-api-service` | Partial (near Ready) | Local quality gates pass (lint/typecheck/tests), production evidence still missing. | 3 | 0 | 0% |
| `device-ingestion-service` | Partial (near Ready) | Local quality gates pass (lint/typecheck/tests), production load evidence still missing. | 3 | 0 | 0% |
| `channel-policy-router` | Partial (near Ready) | Local quality gates pass (lint/typecheck/tests), integration/SLO proofs still missing. | 3 | 0 | 0% |
| `automation-scenario-service` | Partial | Durable Postgres adapter and integration-test path added; restart durability and controlled-env evidence still pending. | 3 | 0 | 0% |
| `operator-ui` | Not Ready | React build/typecheck pass, but Keycloak lifecycle and frontend test baseline are still missing. | 3 | 0 | 0% |
| `partner-integration-layer` | Partial (near Ready) | Local quality gates now pass (lint/typecheck/tests); non-stub end-to-end partner validation remains open. | 3 | 0 | 0% |

## 2. Execution Tracker

### 2.1 `platform-foundation`

- [x] Clean git state in foundation scripts/reports.
- [x] Re-run Wave 8 readiness/pullability and archive fresh PASS artifacts.
- [ ] Remove/close remaining production TODO placeholders in manifest policy flow.
- [x] Define and track backup/restore implementation for shared PostgreSQL operations.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Clean git state in foundation scripts/reports | done | Platform team | 2026-04-14 | `git -C /home/olivier/work/iot_services/platform-foundation status --short` | Verified clean working tree on this cycle (no pending changes). |
| Re-run Wave 8 readiness/pullability and archive fresh PASS artifacts | done | Platform team | 2026-04-14 | `platform-foundation/deploy/production/scripts/run_wave8_namespace_readiness.sh` | Re-run executed on 2026-04-14 with `status=PASS`; reports refreshed under `deploy/production/reports/` and `nodered/reports/`. |
| Remove/close remaining production TODO placeholders in manifest policy flow | in_progress | Platform team | TBD | `platform-foundation/deploy/production/README.md` | Open TODO/placeholder markers remain in deployment docs; requires closure or explicit deferred policy with owner/date. |
| Define and track backup/restore implementation for shared PostgreSQL operations | done | Platform team | 2026-04-14 | `platform-foundation/deploy/production/runbooks/postgres-backup-restore.md`; `docs/project-monitoring/services/platform-foundation/postgresql-shared-cluster-rollout.md` | Ownership, scope, and TODO checklist are documented and linked in execution tracking. |

### 2.2 `identity-access-config`

- [ ] Add automated realm drift check in CI.
- [ ] Add secret rotation + emergency rollback runbook validation evidence.
- [ ] Validate non-dev realm import path end-to-end against target env.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Add automated realm drift check in CI | blocked | Platform team | TBD | `identity-access-config/.github` (missing) | No CI workflow folder in this repo at the moment. |
| Add secret rotation + emergency rollback runbook validation evidence | not_started | Platform team | TBD | `identity-access-config/docs/runbooks/keycloak-bootstrap.md` | Runbook exists, but no explicit rotation/rollback evidence package. |
| Validate non-dev realm import path end-to-end against target env | in_progress | Platform team | TBD | `identity-access-config/keycloak/generated/realm-export.local.json` | Local render/validate PASS; non-dev target environment validation still pending. |

### 2.3 `reference-api-service`

- [ ] Final production config profile + secret wiring verification.
- [ ] SLO/alert hooks wired and validated in shared observability.
- [ ] Release evidence on real environment (not only local/CI).

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Final production config profile + secret wiring verification | in_progress | Platform team | TBD | Local check command: `ruff check . && mypy src && pytest -q` | Local gate passes (`10 passed, 2 skipped`), production profile proof still pending. |
| SLO/alert hooks wired and validated in shared observability | not_started | Platform team | TBD | TBD | Not validated in this cycle. |
| Release evidence on real environment (not only local/CI) | not_started | Platform team | TBD | TBD | No deployment evidence attached yet. |

### 2.4 `device-ingestion-service`

- [ ] Throughput/soak validation on expected load.
- [ ] Production DLQ/replay operational procedure tested.
- [ ] Runtime secrets + broker auth/TLS path verified in deployment target.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Throughput/soak validation on expected load | not_started | Platform team | TBD | TBD | Functional tests pass locally, but no soak benchmark evidence yet. |
| Production DLQ/replay operational procedure tested | in_progress | Platform team | TBD | Local check command: `ruff check . && mypy src && pytest -q` | Local gate passes (`8 passed, 2 skipped`); production DLQ replay drill still pending. |
| Runtime secrets + broker auth/TLS path verified in deployment target | not_started | Platform team | TBD | TBD | Deployment-target verification not yet evidenced. |

### 2.5 `channel-policy-router`

- [ ] Full integration verification with upstream/downstream services in realistic env.
- [ ] Incident hook delivery reliability SLO validated under failure scenarios.
- [ ] Production auth settings locked and verified (issuer/audience strict mode evidence).

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Full integration verification with upstream/downstream services in realistic env | in_progress | Platform team | TBD | Local check command: `ruff check . && mypy src && pytest -q` | Local gate passes (`20 passed, 2 skipped`); realistic-env integration proof still pending. |
| Incident hook delivery reliability SLO validated under failure scenarios | not_started | Platform team | TBD | TBD | Not executed in this cycle. |
| Production auth settings locked and verified (issuer/audience strict mode evidence) | not_started | Platform team | TBD | TBD | Strict-mode runtime evidence not attached yet. |

### 2.6 `automation-scenario-service`

- [ ] Implement and wire persistent outbound adapter (e.g. postgres).
- [ ] Add integration tests for persistence and restart recovery.
- [ ] Prove workflow durability across service restarts.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Implement and wire persistent outbound adapter (e.g. postgres) | in_progress | Platform team | TBD | `automation-scenario-service/src/automation_scenario_service/adapters/outbound/postgres.py` | Postgres adapter wired in runtime; remaining step is controlled-env validation and final sign-off. |
| Add integration tests for persistence and restart recovery | not_started | Platform team | TBD | TBD | Not available while durable persistence is not implemented. |
| Prove workflow durability across service restarts | not_started | Platform team | TBD | TBD | Blocked by missing durable persistence implementation. |

### 2.7 `operator-ui`

- [ ] Implement real Keycloak login/refresh/logout flow.
- [ ] Add frontend test baseline (unit + key view behavior).
- [ ] Harden mutation UX (error handling/retry/confirmations/audit visibility).

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Implement real Keycloak login/refresh/logout flow | not_started | Platform team | TBD | `operator-ui/README.md` | README still states temporary `localStorage.access_token` path. |
| Add frontend test baseline (unit + key view behavior) | not_started | Platform team | TBD | `operator-ui/package.json` | No `test` script currently present. |
| Harden mutation UX (error handling/retry/confirmations/audit visibility) | in_progress | Platform team | TBD | Local check command: `npm run typecheck && npm run build` | Build/typecheck pass; UX hardening backlog remains open. |

### 2.8 `partner-integration-layer`

- [ ] Complete real connector behavior beyond baseline translation/handoff.
- [ ] Add resilience/observability depth per partner path (timeouts, retries, backpressure proofs).
- [ ] Validate non-stub end-to-end partner flows in controlled integration environment.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Complete real connector behavior beyond baseline translation/handoff | in_progress | Platform team | TBD | `partner-integration-layer/src/partner_integration_layer/application/governance.py` | Governance handoff to `channel-policy-router` exists; still baseline-level connector depth. |
| Add resilience/observability depth per partner path (timeouts, retries, backpressure proofs) | not_started | Platform team | TBD | TBD | No dedicated resilience evidence package in this cycle. |
| Validate non-stub end-to-end partner flows in controlled integration environment | in_progress | Platform team | TBD | Local checks: `ruff check . && mypy src && pytest -q` | Local gate now passes (`ruff` PASS, `mypy` PASS, `16 passed`); non-stub controlled-env proof still pending. |

### 2.9 Shared PostgreSQL Rollout (Cross-service traceability)

| Service | Task | Status | Owner | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| `reference-api-service` | Switch Postgres integration tests to foundation-managed shared cluster | in_progress | Platform team | `reference-api-service/scripts/run_postgres_integration_tests.sh` | Service-local Postgres compose lifecycle removed; now depends on foundation bootstrap/provisioning. |
| `device-ingestion-service` | Switch Postgres integration tests to foundation-managed shared cluster | in_progress | Platform team | `device-ingestion-service/scripts/run_postgres_integration_tests.sh` | Service-local Postgres compose lifecycle removed; now depends on foundation bootstrap/provisioning. |
| `channel-policy-router` | Switch Postgres integration tests to foundation-managed shared cluster | in_progress | Platform team | `channel-policy-router/scripts/run_postgres_integration_tests.sh` | Service-local Postgres compose lifecycle removed; now depends on foundation bootstrap/provisioning. |
| `automation-scenario-service` | Implement durable Postgres adapter + restart durability test path | in_progress | Platform team | `automation-scenario-service/src/automation_scenario_service/adapters/outbound/postgres.py` | Includes schema SQL and `postgres_integration` test path. |

## 3. PoC Parity Tracking Hook

PoC parity is a mandatory V1 requirement.

Normative baseline:

- `docs/specs/poc-parity-baseline.md`

Execution rule:

1. No service can be declared `Ready` if it leaves an acceptance-critical PoC capability untracked.
2. Any PoC parity gap must be mapped to an explicit task row with owner + target date + evidence.

## 4. Verification Snapshot (2026-04-03 baseline + 2026-04-14 platform-foundation refresh)

Executed checks:

1. `identity-access-config`: local realm render/validate PASS.
2. `reference-api-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
3. `device-ingestion-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
4. `channel-policy-router`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
5. `automation-scenario-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
6. `operator-ui`: `npm run typecheck` PASS, `npm run build` PASS.
7. `partner-integration-layer`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
8. `platform-foundation`: vault runtime baseline PASS; observability baseline PASS; Wave 6 topology release gate PASS; Wave 8 namespace readiness PASS. Wave 8 readiness/pullability was re-run on 2026-04-14 with `status=PASS`. Script runners now auto-resolve Python via `PYTHON_BIN` -> repo `.venv/bin/python` -> `python3`.
9. `plateform-meta-iot`: Wave 1 tenant isolation checks PASS; Wave 6 runbook verification PASS.

## 5. Update Rules

1. Update checklist and table status together.
2. Every `done` line must include an evidence link.
3. If blocked, capture the blocker in `Notes` and add an unblocking owner/date.
4. Recompute dashboard progress after each update cycle.
