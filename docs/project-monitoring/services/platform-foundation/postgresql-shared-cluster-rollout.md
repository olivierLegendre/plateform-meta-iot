# Shared PostgreSQL Cluster Rollout

> AUTHORITATIVE (EXECUTION): This document is part of the project-monitoring baseline and is authoritative for shared PostgreSQL rollout execution status and evidence.

Date: 2026-04-14  
Owner: Platform team  
Scope: foundation-managed PostgreSQL cluster + cross-service migration to shared DB runtime/test bootstrap.

## 1. Target Structure

1. One PostgreSQL cluster owned by `platform-foundation`.
2. Managed persistent volume for cluster data durability.
3. One service database per service.
4. Least-privilege roles per service:
- `svc_<service>_app`
- `svc_<service>_migrator`
5. No service role has PostgreSQL `SUPERUSER`.
6. Backup/restore operations are foundation-owned.
7. Service teams provide restore-validation evidence at application level.

## 2. Execution Plan

| Step | Status | Owner | Evidence | Notes |
| --- | --- | --- | --- | --- |
| Add shared Postgres compose stack with managed persistent volume | done | Platform team | `platform-foundation/deploy/production/compose/postgres-shared.compose.yaml` | Shared cluster runs on `postgres:18` with managed external volume mount at `/var/lib/postgresql` (Postgres 18 layout compatible). |
| Add cluster lifecycle script with destructive delete guardrail | done | Platform team | `platform-foundation/deploy/production/scripts/run_shared_postgres_cluster.sh` | `destroy-data` requires explicit `ALLOW_DESTRUCTIVE_VOLUME_DELETE=true`; normal `down` keeps managed volume intact. |
| Add idempotent DB/role provisioning script | done | Platform team | `platform-foundation/deploy/production/scripts/provision_shared_postgres.sh` | Script provisions service DB/app/migrator roles idempotently and supports per-service reset. |
| Add vault-ready DSN wiring placeholders in production service compose files | done | Platform team | `platform-foundation/deploy/production/compose/*.compose.yaml` | Runtime DSN contracts are declared and production compose now pins `*_POSTGRES_AUTO_INIT=false` for reference-api, device-ingestion, and channel-policy-router. |
| Add Alembic migration entrypoints for shared-DB services | done | Platform team | `reference-api-service/alembic/`; `device-ingestion-service/alembic/`; `channel-policy-router/alembic/`; `automation-scenario-service/alembic/` | Initial schema revisions and `scripts/migrate_postgres.sh` are present for all four services. |
| Migrate integration tests to foundation-managed shared Postgres | done | Platform team | service `scripts/run_postgres_integration_tests.sh` files | Service-local Postgres compose lifecycles removed; tests now provision shared cluster DBs/roles, run Alembic upgrade, then execute tests with app-role DSNs. |
| Implement durable persistence path for `automation-scenario-service` | in_progress | Platform team | `automation-scenario-service/src/.../adapters/outbound/postgres.py` | Includes restart durability integration test path. |
| Add backup/restore implementation TODO and runbook placeholder | done | Platform team | `platform-foundation/deploy/production/runbooks/postgres-backup-restore.md` | Ownership and deferred operational checklist are documented and tracked. |

## 3. Acceptance Checklist

- [x] Shared Postgres cluster bootstraps and remains durable across container restart.
- [x] Provisioning script is idempotent and can reset one service DB without impacting others.
- [x] Service integration tests run without per-service Postgres containers.
- [x] Teardown commands do not remove managed persistent volume by default.
- [x] Backup/restore TODO remains tracked with owner and target implementation wave.
