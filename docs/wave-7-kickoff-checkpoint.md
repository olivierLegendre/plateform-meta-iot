# Wave 7 Kickoff Checkpoint (Partner Integration Rollout)

Date: 2026-03-18
Status: In progress

## 1. Objective

Start Wave 7 with the first partner integration track (Schneider BACnet) while preserving service boundaries, IAM controls, and command/safety governance.

## 2. Entry Criteria (Met)

1. Wave 6 closure sign-off recorded.
- Evidence: `docs/wave-6-closure-signoff.md`

2. Production topology retirement/readiness controls are green for Node-RED-independent runtime path.
- Evidence:
  - `platform-foundation/nodered/reports/w6_topology_release_gate_report.json`
  - `platform-foundation/nodered/reports/w6_retirement_readiness_report.json`

3. Baseline service image publish and pullability proof process exists.
- Evidence:
  - `platform-foundation/deploy/production/scripts/run_ghcr_publish_proof.sh`
  - `platform-foundation/deploy/production/ghcr-service-images.manifest`

## 3. Wave 7 Scope Decision

Wave 7 remains post-V1 partner rollout work, started now as a controlled implementation wave.

Execution order locked for adapters:
1. Schneider BACnet adapter (first)
2. Tandem Connect adapter (second)
3. Siemens Building X API adapter (third)

## 4. First Track (W7-01) - Schneider BACnet

Primary outcomes:
1. Define adapter boundary and canonical contract mapping for Schneider BACnet points/events.
2. Enforce policy that adapters do not bypass platform IAM, audit, command serialization, or tenant isolation controls.
3. Deliver integration verification baseline (contract + isolation + rollback).

## 5. Guardrails (Non-negotiable)

1. Adapter components remain transport/integration adapters only (no core business rule ownership).
2. Command governance remains in platform services (`channel-policy-router`, `automation-scenario-service`, `reference-api-service` as applicable).
3. Tenant/org isolation and site-scoped control model remain enforced at service boundary.
4. All partner adapter routes are versioned and observable.

## 6. Backlog Reference

Wave 7 implementation order and dependencies are tracked in:
- `docs/wave-7-execution-backlog.md`

W7-01 contract baseline:
- `docs/wave-7-schneider-bacnet-contract.md`

## 7. Initial Exit Conditions For Wave 7 Closure

1. Schneider BACnet integration path is deployed behind explicit feature flag and passes compatibility/isolation tests.
2. Adapter does not bypass IAM/audit/command policy controls.
3. Tandem and Siemens tracks have approved execution plans and acceptance criteria.
4. Runbook coverage exists for partner adapter incident/rollback handling.
