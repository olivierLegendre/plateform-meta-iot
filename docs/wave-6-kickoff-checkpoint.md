# Wave 6 Kickoff Checkpoint (Node-RED Retirement And Hardening)

Date: 2026-03-17
Status: In progress

## 1. Objective

Start Wave 6 by removing residual runtime risk from Node-RED and converting remaining hardening TODOs into explicit implementation tracks.

## 2. Completed At Kickoff

1. JWT mutation auth hardening completed in:
- `automation-scenario-service`
- `channel-policy-router`

2. Validation green after hardening:
- service lint + mypy + tests
- `channel-policy-router` Postgres integration tests
- cross-service Wave 5 e2e smoke

## 3. Node-RED Dependency Inventory (From PoC)

Inventory source checked:
- `/home/olivier/Public/poc/stack/nodered/data/flows.json`
- `/home/olivier/Public/poc/stack/docker-compose.yml`
- `/home/olivier/Public/poc/stack/nodered/data/lib/domain/index.js`
- `/home/olivier/Public/poc/stack/nodered/data/lib/repo/index.js`

Observed PoC footprint:
- 1 Node-RED tab: `PoC MQTT PostgreSQL + Dashboard`
- 143 nodes total
- 67 `function` nodes
- 24 `postgresql` nodes
- 2 `mqtt in` nodes
- 1 `mqtt out` node
- 7 `http in` + 7 `http response` nodes

### Decommission Classification Table

| Flow family (PoC) | Evidence pattern | Classification | Owner | Replacement target | Target date |
| --- | --- | --- | --- | --- | --- |
| Ingestion parse/normalize + device upsert | `domain.ingest.*`, `repo.devices.*`, `repo.telemetry.*` | `replace_with_service` | `device-ingestion-service` | Keep `device-ingestion-service` as single ingest path; disable equivalent Node-RED handlers | 2026-04-15 |
| Mapping candidate + metrics materialization | `domain.mapping.*`, `repo.device_mapping_candidate.*`, `repo.metrics.*` | `replace_with_service` | `device-ingestion-service` + `reference-api-service` | Split between ingest write-path and mapping/admin API | 2026-04-22 |
| Reference/mapping admin HTTP API in Node-RED | `api_*`, `domain.api.*`, `repo.deviceReference*` | `replace_with_service` | `reference-api-service` | Move all reference CRUD/list/link/mapping endpoints to `reference-api-service` only | 2026-04-22 |
| Dashboard SQL aggregation and formatting in Node-RED | `domain.dashboard.*`, `repo.dashboard.*`, `fn_q_*`, `fn_fmt_*` | `replace_with_service` | `operator-ui` + service owners | Rebuild read models via service APIs and/or Grafana queries; remove Node-RED dashboard logic | 2026-04-30 |
| Scenario evaluation + command routing in Node-RED | names containing `scenario` and `Route scenario actions` | `replace_with_service` | `automation-scenario-service` + `channel-policy-router` | Keep orchestration in Camunda/Python services; keep channel decision in `channel-policy-router` | 2026-04-18 |
| Temporary bridge shim for legacy topic/API compatibility | `stack/nodered/data/flows.json` runtime wiring | `temporary_bridge` | `platform-foundation` | Keep bridge-only behavior behind explicit allowlist, then remove | 2026-05-15 |

### Immediate retirements

`retire_now` candidates (once parity checks pass):
- Node-RED HTTP endpoints that duplicate `reference-api-service` routes.
- Node-RED dashboard query functions once operator UI/Grafana pages use service-owned read paths.

### Exit rule for temporary bridge

Temporary bridge can stay only if all conditions are true:
1. No domain rule execution inside Node-RED function nodes.
2. No direct SQL write from Node-RED into core tables.
3. Explicit owner and end date recorded.

If any condition fails, classification is escalated from `temporary_bridge` to blocked release item.

## 4. Hardening Tracks Open In Wave 6

1. Keycloak production-grade verification profile:
- issuer/audience enforced per environment
- key rotation operational runbook

2. Secret management completion:
- Vault wiring per service bootstrap path
- remove fallback plaintext bootstrap assumptions

3. Operational readiness:
- service runbooks (incident, rollback, recovery)
- SLO dashboards and alerting for ingestion/API/command paths

## 5. Exit Conditions For Wave 6

1. No critical path depends on Node-RED runtime state.
2. Remaining Node-RED role is explicitly bridge-only or fully retired.
3. Runbooks and SLO/alert dashboards are active and validated.
