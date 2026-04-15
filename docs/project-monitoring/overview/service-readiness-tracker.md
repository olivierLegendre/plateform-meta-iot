# Service Readiness Tracker

> AUTHORITATIVE (EXECUTION): This document is part of the project-monitoring baseline and is authoritative for implementation status, blockers, and evidence tracking.

Date: 2026-04-14
Owner: Platform team
Purpose: track readiness closure work service-by-service until production gates are met.
Last verification cycle: 2026-04-14 (`platform-foundation` closure pass + shared-Postgres/Alembic rollout verification across reference-api, device-ingestion, channel-policy-router, and automation-scenario)

Status legend:
- `not_started`
- `in_progress`
- `done`
- `blocked`

## 1. Global Dashboard

| Service | Readiness | Why | Items total | Items done | Progress |
| --- | --- | --- | ---: | ---: | ---: |
| `platform-foundation` | Ready (baseline) | Wave 1/Wave 6/Wave 8 gates are PASS with fresh evidence, shared Postgres ownership tracking is in place, repo clean-state is confirmed, and deployment placeholder wording in manifest policy docs is closed. | 4 | 4 | 100% |
| `identity-access-config` | Partial | Keycloak baseline scripts validated locally, but CI drift control and non-dev import evidence remain open. | 3 | 0 | 0% |
| `reference-api-service` | Ready (baseline) | Local quality gates and Postgres integration path pass; production-profile secret wiring is verified in foundation Vault baseline; shared observability SLO/alert wiring is verified; real-environment release evidence is recorded with runtime smoke and DB persistence proof. | 3 | 3 | 100% |
| `device-ingestion-service` | Partial (near Ready) | Local quality gates pass (lint/typecheck/tests), shared Postgres integration path (with Alembic migrator/app split) passes; production load evidence still missing. | 3 | 0 | 0% |
| `channel-policy-router` | Partial (near Ready) | Local quality gates pass (lint/typecheck/tests), shared Postgres integration path (with Alembic migrator/app split) passes; integration/SLO proofs still missing. | 3 | 0 | 0% |
| `automation-scenario-service` | Partial | Durable Postgres adapter is wired, restart-survival integration test passes on shared Postgres, controlled-env evidence remains pending. | 3 | 1 | 33% |
| `operator-ui` | Not Ready | React build/typecheck pass, but Keycloak lifecycle and frontend test baseline are still missing. | 3 | 0 | 0% |
| `partner-integration-layer` | Partial (near Ready) | Local quality gates now pass (lint/typecheck/tests); non-stub end-to-end partner validation remains open. | 3 | 0 | 0% |

## 2. Execution Tracker

### 2.1 `platform-foundation`

- [x] Clean git state in foundation scripts/reports.
- [x] Re-run Wave 8 readiness/pullability and archive fresh PASS artifacts.
- [x] Remove/close remaining production TODO placeholders in manifest policy flow.
- [x] Define and track backup/restore implementation for shared PostgreSQL operations.

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Clean git state in foundation scripts/reports | done | Platform team | 2026-04-14 | `git -C /home/olivier/work/iot_services/platform-foundation status --short` | Verified clean working tree on this cycle (no pending changes). |
| Re-run Wave 8 readiness/pullability and archive fresh PASS artifacts | done | Platform team | 2026-04-14 | `platform-foundation/deploy/production/scripts/run_wave8_namespace_readiness.sh` | Re-run executed on 2026-04-14 with `status=PASS`; reports refreshed under `deploy/production/reports/` and `nodered/reports/`. |
| Remove/close remaining production TODO placeholders in manifest policy flow | done | Platform team | 2026-04-14 | `platform-foundation/deploy/production/README.md` | Placeholder language removed from deployment manifest policy documentation; release policy wording now references verified immutable tag promotion. |
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

- [x] Final production config profile + secret wiring verification.
- [x] SLO/alert hooks wired and validated in shared observability.
- [x] Release evidence on real environment (not only local/CI).

| Task | Status | Owner | Target date | Evidence link | Notes |
| --- | --- | --- | --- | --- | --- |
| Final production config profile + secret wiring verification | done | Platform team | 2026-04-14 | `reference-api-service/src/reference_api_service/settings.py`; `platform-foundation/deploy/production/compose/reference-api.compose.yaml`; `platform-foundation/vault/secrets-contract.yaml`; `platform-foundation/vault/reports/w1-vault-runtime-baseline-report.json`; `reference-api-service/scripts/run_postgres_integration_tests.sh` | Runtime contract now includes `REFERENCE_API_POSTGRES_DSN`; Wave 1 vault baseline report PASS includes `reference-api-service`; local gates pass (`10 passed, 2 skipped`) and Postgres integration path passes (`2 passed`). |
| SLO/alert hooks wired and validated in shared observability | done | Platform team | 2026-04-14 | `platform-foundation/observability/prometheus/rules/wave6-critical-path-alerts.yaml`; `platform-foundation/observability/metric-name-mapping.yaml`; `platform-foundation/observability/reports/w1-observability-baseline-report.json` | Reference API 5xx error-rate alert rule, SLO mapping, and baseline observability report verification are present and PASS. |
| Release evidence on real environment (not only local/CI) | done | Platform team | 2026-04-14 | `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/evidence-summary.json`; `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/smoke-healthz.txt`; `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/smoke-put-reference.txt`; `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/postgres-row-check.txt`; `platform-foundation/deploy/production/compose/reference-api.compose.yaml` | Controlled real runtime proof executed on production-profile compose (`env=production`, Postgres backend). Runtime smoke checks and DB row persistence checks are PASS. |

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
| Implement and wire persistent outbound adapter (e.g. postgres) | done | Platform team | 2026-04-14 | `automation-scenario-service/src/automation_scenario_service/adapters/outbound/postgres.py`; `automation-scenario-service/src/automation_scenario_service/settings.py`; `automation-scenario-service/src/automation_scenario_service/main.py` | Postgres adapter is runtime-wired with backend toggle and shared Postgres DSN contract. |
| Add integration tests for persistence and restart recovery | in_progress | Platform team | TBD | `automation-scenario-service/tests/test_postgres_integration.py`; `automation-scenario-service/scripts/run_postgres_integration_tests.sh` | Local integration test path now validates persistence through app restarts; controlled-env evidence package still pending. |
| Prove workflow durability across service restarts | in_progress | Platform team | TBD | `automation-scenario-service/tests/test_postgres_integration.py` | Restart-survival behavior is covered locally; production-like drill evidence still required before closure. |

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
| `reference-api-service` | Switch Postgres integration tests to foundation-managed shared cluster | done | Platform team | `reference-api-service/scripts/run_postgres_integration_tests.sh`; `reference-api-service/alembic/`; `reference-api-service/scripts/migrate_postgres.sh` | Shared cluster provisioning + Alembic migration + app-role test execution verified PASS. |
| `device-ingestion-service` | Switch Postgres integration tests to foundation-managed shared cluster | done | Platform team | `device-ingestion-service/scripts/run_postgres_integration_tests.sh`; `device-ingestion-service/alembic/`; `device-ingestion-service/scripts/migrate_postgres.sh` | Shared cluster provisioning + Alembic migration + app-role test execution verified PASS. |
| `channel-policy-router` | Switch Postgres integration tests to foundation-managed shared cluster | done | Platform team | `channel-policy-router/scripts/run_postgres_integration_tests.sh`; `channel-policy-router/alembic/`; `channel-policy-router/scripts/migrate_postgres.sh` | Shared cluster provisioning + Alembic migration + app-role test execution verified PASS. |
| `automation-scenario-service` | Implement durable Postgres adapter + restart durability test path | in_progress | Platform team | `automation-scenario-service/src/automation_scenario_service/adapters/outbound/postgres.py` | Includes schema SQL and `postgres_integration` test path. |

## 3. PoC Parity Tracking Hook

PoC parity is a mandatory V1 requirement.

Normative baseline:

- `docs/specs/poc-parity-baseline.md`

Execution rule:

1. No service can be declared `Ready` if it leaves an acceptance-critical PoC capability untracked.
2. Any PoC parity gap must be mapped to an explicit task row with owner + target date + evidence.

## 4. Verification Snapshot (2026-04-03 baseline + 2026-04-14 shared-Postgres/Alembic rollout refresh)

Executed checks:

1. `identity-access-config`: local realm render/validate PASS.
2. `reference-api-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS (`10 passed, 2 skipped`); Postgres integration path PASS (`2 passed`); controlled real-runtime release evidence PASS (`health/write/read/list + DB persistence`) under `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/`.
3. `device-ingestion-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS (`8 passed, 2 skipped`); shared Postgres integration + Alembic path PASS (`2 passed`).
4. `channel-policy-router`: `ruff` PASS, `mypy` PASS, `pytest` PASS (`20 passed, 2 skipped`); shared Postgres integration + Alembic path PASS (`2 passed`).
5. `automation-scenario-service`: `ruff` PASS, `mypy` PASS, `pytest` PASS (`9 passed, 1 skipped`); shared Postgres integration + Alembic path PASS (`1 passed`).
6. `operator-ui`: `npm run typecheck` PASS, `npm run build` PASS.
7. `partner-integration-layer`: `ruff` PASS, `mypy` PASS, `pytest` PASS.
8. `platform-foundation`: vault runtime baseline PASS; observability baseline PASS; Wave 6 topology release gate PASS; Wave 8 namespace readiness PASS. Wave 8 readiness/pullability and observability baseline were re-run on 2026-04-14 with `status=PASS`. Script runners now auto-resolve Python via `PYTHON_BIN` -> repo `.venv/bin/python` -> `python3`.
9. `plateform-meta-iot`: Wave 1 tenant isolation checks PASS; Wave 6 runbook verification PASS.

## 5. Update Rules

1. Update checklist and table status together.
2. Every `done` line must include an evidence link.
3. If blocked, capture the blocker in `Notes` and add an unblocking owner/date.
4. Recompute dashboard progress after each update cycle.
