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

## 4.1 W7-02 Schneider Adapter Runtime Skeleton (Started)

Seeded repository:
- `partner-integration-layer`

Implemented baseline artifacts:
- `partner-integration-layer/src/partner_integration_layer/main.py`
- `partner-integration-layer/src/partner_integration_layer/adapters/inbound/http/router.py`
- `partner-integration-layer/src/partner_integration_layer/application/translator.py`
- `partner-integration-layer/src/partner_integration_layer/domain/models.py`
- `partner-integration-layer/tests/test_api.py`
- `partner-integration-layer/scripts/setup_dev.sh`
- `partner-integration-layer/scripts/export_openapi.py`
- `partner-integration-layer/.github/workflows/ci.yml`
- `partner-integration-layer/.github/workflows/image-publish.yml`

Baseline behavior:
1. health endpoint and versioned Schneider adapter endpoints are available;
2. telemetry normalization route maps BACnet input into canonical payload baseline fields;
3. command intent route declares governance handoff path to platform command plane;
4. CI/image workflow scaffolds exist for repeatable integration delivery.

Current interpretation: W7-02 is now started with an executable adapter skeleton. Remaining work is wiring real BACnet runtime integration and enforcing full security/tenancy controls (`W7-03`).

## 4.2 W7-03 Security And Tenancy Enforcement (Implemented Baseline)

Implemented in `partner-integration-layer`:
- adapter token enforcement for Schneider endpoints (`X-Adapter-Token`);
- tenant scope header enforcement (`X-Organization-Id`, `X-Site-Id`);
- payload/header scope consistency checks (reject mismatch).

Code references:
- `partner-integration-layer/src/partner_integration_layer/settings.py`
- `partner-integration-layer/src/partner_integration_layer/adapters/inbound/http/router.py`
- `partner-integration-layer/tests/test_api.py`

Validation:
1. local adapter test suite: `5 passed`;
2. reject-path coverage includes invalid token and tenant scope mismatch.

Current interpretation: W7-03 baseline controls are in place for adapter auth and tenant scoping. Remaining W7-03 work is integrating real IAM token validation path with `identity-access-config`.

## 4.3 W7-04 Command Governance Handoff (Implemented Baseline)

Implemented in `partner-integration-layer`:
1. command intent endpoint now calls `channel-policy-router` `POST /api/v1/commands`;
2. adapter command payload is forwarded with organization/site/point scope, class, correlation, and idempotency;
3. downstream handoff failures are returned as `503` (no local bypass execution path).

Code references:
- `partner-integration-layer/src/partner_integration_layer/application/governance.py`
- `partner-integration-layer/src/partner_integration_layer/adapters/inbound/http/router.py`
- `partner-integration-layer/tests/test_api.py`

Validation:
1. local adapter test suite: `6 passed`;
2. test coverage includes successful governance handoff shape and `503` error mapping.

Current interpretation: W7-04 baseline is in place; remaining W7-04 work is integration testing with a live `channel-policy-router` runtime and command lineage checks.

## 4.4 W7-05 Schneider Compatibility Suite (Implemented Baseline)

Implemented in `partner-integration-layer`:
1. protocol normalization edge-case tests (unit normalization with whitespace and unknown-unit passthrough);
2. governance handoff retry behavior tests (transient `503` retry then success);
3. non-retriable downstream failure contract test (`422` fails fast).

Code references:
- `partner-integration-layer/tests/test_compatibility.py`
- `partner-integration-layer/src/partner_integration_layer/application/governance.py`
- `partner-integration-layer/src/partner_integration_layer/application/translator.py`

Validation:
1. local adapter test suite: `10 passed`;
2. retry/failure semantics and protocol mapping edge cases are covered.

Current interpretation: W7-05 baseline compatibility verification is in place. Remaining W7-05 work is extending coverage with live BACnet fixture datasets and cross-service integration scenarios.

## 4.5 W7-06 Observability And Runbooks (Implemented Baseline)

Implemented in `partner-integration-layer`:
1. service runbook: incident/rollback/recovery for adapter operations;
2. README reference under operations runbook section.

Artifacts:
- `partner-integration-layer/docs/runbooks/incident-rollback-recovery.md`
- `partner-integration-layer/README.md`

Implemented in `platform-foundation/observability`:
1. Wave 7 partner SLO baseline;
2. Wave 7 partner metric mapping;
3. Wave 7 partner Prometheus rules;
4. Wave 7 partner Alertmanager routing;
5. synthetic healthy/breach payloads;
6. wiring verifier and verification report.

Artifacts:
- `platform-foundation/observability/slo-targets-wave7-partner.yaml`
- `platform-foundation/observability/metric-name-mapping-wave7-partner.yaml`
- `platform-foundation/observability/prometheus/rules/wave7-partner-adapter-alerts.yaml`
- `platform-foundation/observability/alertmanager/wave7-alert-routing.yaml`
- `platform-foundation/observability/examples/synthetic-metrics-wave7-healthy.json`
- `platform-foundation/observability/examples/synthetic-metrics-wave7-breach.json`
- `platform-foundation/observability/scripts/verify_wave7_partner_observability.py`
- `platform-foundation/observability/reports/wave7-partner-observability-verification.json`

Validation:
1. Wave 7 partner observability verifier: `PASS`, `findings=0`.

Current interpretation: W7-06 baseline is in place with operational runbook and observability wiring evidence. Remaining W7-06 work is live monitoring-stack integration and alert channel hardening.

## 4.6 W7-07 Tandem Connect Planning Packet (Started)

Implemented in `plateform-meta-iot`:
1. Tandem Connect planning packet with scope, boundary model, contract surface, risks, acceptance criteria, and rollback rules.

Artifact:
- `docs/wave-7-tandem-connect-planning.md`

Current interpretation: W7-07 planning is started with a baseline packet. Remaining work is architecture approval and implementation entry gating after Schneider track closure criteria.

## 4.7 W7-08 Siemens Building X Planning Packet (Started)

Implemented in `plateform-meta-iot`:
1. Siemens Building X planning packet with scope, boundary model, contract surface, risks, acceptance criteria, and rollback rules.

Artifact:
- `docs/wave-7-siemens-buildingx-planning.md`

Current interpretation: W7-08 planning is started with a baseline packet. Remaining work is architecture approval and implementation entry gating after prior adapter track closure criteria.

## 4.8 W7-09 Performance And Scale Hardening (Started)

Implemented baseline artifacts:
1. W7-09 scale-hardening packet with load profile targets, backpressure behavior, retry tuning baseline, and closure evidence requirements.
2. Partner adapter performance runbook for execution checklist and rollback guidance.

Artifacts:
- `docs/wave-7-scale-hardening-baseline.md`
- `partner-integration-layer/docs/runbooks/performance-scale-hardening.md`

Current interpretation: W7-09 baseline, observability load-breach assertions, and cross-service integrated load validation evidence are in place. Remaining work is final Wave 7 closure decision and sign-off packaging.

Validation evidence recorded:
1. baseline smoke load profile executed (`duration=5s`, `normalize=10 rps`, `command=4 rps`);
2. result: `PASS` with p95 and error-rate checks green;
3. report artifact:
- `platform-foundation/observability/reports/wave7-partner-scale-baseline.json`
4. baseline standard load profile executed (`duration=15s`, `normalize=100 rps`, `command=40 rps`);
5. result: `PASS` with p95 and error-rate checks green;
6. report artifact:
- `platform-foundation/observability/reports/wave7-partner-scale-baseline-standard.json`
7. Wave 7 observability verifier updated with explicit load-breach assertions (`command_intent_rps`, `overload_reject_ratio`);
8. verification result: `PASS`, `findings=0`;
9. report artifact:
- `platform-foundation/observability/reports/wave7-partner-observability-verification.json`
10. cross-service integrated load validation executed with live `channel-policy-router` handoff (`mode=real`, `duration=10s`, `normalize=40 rps`, `command=20 rps`, `target_point_cardinality=50`);
11. result: `PASS` with p95 and error-rate checks green;
12. report artifact:
- `platform-foundation/observability/reports/wave7-partner-scale-integration-real-controlled.json`

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
