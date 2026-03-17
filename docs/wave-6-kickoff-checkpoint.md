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

## 3. Node-RED Dependency Inventory (Current)

Current platform runtime components (`device-ingestion-service`, `reference-api-service`, `automation-scenario-service`, `channel-policy-router`, `operator-ui`) do not execute critical business rules inside Node-RED.

Residual Node-RED worklist (to close in Wave 6):

1. Enumerate any legacy PoC flows still used as live bridge paths.
2. Classify each flow as one of:
- `retire_now`
- `temporary_bridge`
- `replace_with_service`
3. Record owner, replacement target, and decommission date for each surviving flow.

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
