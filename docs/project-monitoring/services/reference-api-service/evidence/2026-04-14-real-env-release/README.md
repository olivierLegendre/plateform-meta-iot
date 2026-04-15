# reference-api-service Real-Environment Release Evidence (2026-04-14)

Purpose: close readiness item `2.3.3` ("Release evidence on real environment") with production-profile runtime proof.

## Runtime context

1. Deployment profile: `platform-foundation/deploy/production/compose/reference-api.compose.yaml`
2. Image: `ghcr.io/olivierlegendre/reference-api-service:v0.2.0`
3. Shared DB: `platform-foundation-postgres` (`postgres:18`)
4. Runtime mode: `REFERENCE_API_APP_ENV=production`, `REFERENCE_API_PERSISTENCE_BACKEND=postgres`

## Artifacts

1. `evidence-summary.json`
2. `compose-ps.txt`
3. `container-runtime.txt`
4. `container-inspect.json`
5. `image-inspect.json`
6. `reference-api-service.logs.txt`
7. `smoke-healthz.txt`
8. `smoke-put-reference.txt`
9. `smoke-get-reference.txt`
10. `smoke-list-references.txt`
11. `postgres-row-check.txt`
12. `timestamp-utc.txt`

## Notes

1. During proof execution, production env mapping was hardened by wiring `REFERENCE_API_APP_ENV=production` in compose.
2. Runtime auto schema init was disabled for production profile (`REFERENCE_API_POSTGRES_AUTO_INIT=false`), and schema was pre-provisioned through shared Postgres operations.
3. End-to-end runtime checks passed: health, write, read-by-id, list, and DB row verification.
