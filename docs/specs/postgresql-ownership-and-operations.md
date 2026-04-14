# PostgreSQL Ownership And Operations

> AUTHORITATIVE: This document is part of the normative project specification and governance baseline.

Status: Draft v1.0  
Date: 2026-04-03  
Owner: Platform Architecture + `platform-foundation`

## 1. Purpose

Define the shared PostgreSQL operating model for V1 and its ownership split.

## 2. Cluster Model

1. One shared PostgreSQL cluster is managed by `platform-foundation`.
2. Runtime services do not own their own PostgreSQL container lifecycle.
3. Managed persistent volume is mandatory for cluster data durability.

## 3. Isolation Model

1. One logical database per service.
2. Services in current scope:
- `reference-api-service`
- `device-ingestion-service`
- `channel-policy-router`
- `automation-scenario-service`
3. Cross-service reads and writes must go through service APIs.
4. Direct DB-to-DB data coupling between services is prohibited.

## 4. Role And Privilege Model

Role naming pattern:

1. `svc_<service>_app`
2. `svc_<service>_migrator`

Privilege rules:

1. No service role may be PostgreSQL `SUPERUSER`.
2. No service role may have global `CREATEDB` or `CREATEROLE`.
3. `svc_<service>_migrator` owns DDL for its own service database.
4. `svc_<service>_app` has runtime DML privileges for its own service database only.
5. Service roles must have no rights outside their own service database.

## 5. Ownership Split (RACI)

`platform-foundation` owns:

1. PostgreSQL cluster lifecycle and runtime hosting.
2. Managed persistent volumes and data durability guardrails.
3. Service DB and role provisioning automation.
4. Credential distribution path via Vault.
5. Backup and restore operations.

Service repos own:

1. Their own schema definitions and migration logic.
2. Their own repository/UoW persistence implementation.
3. Application-level restore-validation tests and evidence.

## 6. Operational Contracts

1. Provisioning scripts must be idempotent.
2. Teardown scripts must not remove managed data volumes by default.
3. Destructive data deletion must require explicit operator acknowledgement.
4. Integration tests must target shared foundation-managed PostgreSQL, not per-service Postgres containers.

## 7. Backup And Restore

1. Backup/restore implementation is foundation-owned.
2. Backup and restore runbooks are mandatory before production go-live.
3. Restore drill evidence must include:
- infra-level restore success evidence (foundation-owned),
- per-service application-level validation evidence (service-owned).

## 8. Deferred Items (tracked)

1. Automated backup scheduling and retention policy implementation.
2. Restore drill cadence automation and evidence packaging.
3. RPO/RTO target formalization per environment.
