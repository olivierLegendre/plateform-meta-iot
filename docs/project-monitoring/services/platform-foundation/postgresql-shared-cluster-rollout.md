# Shared PostgreSQL Cluster Rollout

> AUTHORITATIVE (EXECUTION): This document is part of the project-monitoring baseline and is authoritative for shared PostgreSQL rollout execution status and evidence.

Date: 2026-04-03  
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
| Add shared Postgres compose stack with managed persistent volume | in_progress | Platform team | `platform-foundation/deploy/production/compose/postgres-shared.compose.yaml` | External managed volume strategy applied. |
| Add cluster lifecycle script with destructive delete guardrail | in_progress | Platform team | `platform-foundation/deploy/production/scripts/run_shared_postgres_cluster.sh` | `destroy-data` requires explicit operator flag. |
| Add idempotent DB/role provisioning script | in_progress | Platform team | `platform-foundation/deploy/production/scripts/provision_shared_postgres.sh` | Supports full provisioning and per-service reset. |
| Add vault-ready DSN wiring placeholders in production service compose files | in_progress | Platform team | `platform-foundation/deploy/production/compose/*.compose.yaml` | Runtime DSN variables declared for service containers. |
| Migrate integration tests to foundation-managed shared Postgres | in_progress | Platform team | service `scripts/run_postgres_integration_tests.sh` files | Service-local Postgres compose lifecycles removed. |
| Implement durable persistence path for `automation-scenario-service` | in_progress | Platform team | `automation-scenario-service/src/.../adapters/outbound/postgres.py` | Includes restart durability integration test path. |
| Add backup/restore implementation TODO and runbook placeholder | in_progress | Platform team | `platform-foundation/deploy/production/runbooks/postgres-backup-restore.md` | Operational implementation deferred from V1 delivery. |

## 3. Acceptance Checklist

- [ ] Shared Postgres cluster bootstraps and remains durable across container restart.
- [ ] Provisioning script is idempotent and can reset one service DB without impacting others.
- [ ] Service integration tests run without per-service Postgres containers.
- [ ] Teardown commands do not remove managed persistent volume by default.
- [ ] Backup/restore TODO remains tracked with owner and target implementation wave.
