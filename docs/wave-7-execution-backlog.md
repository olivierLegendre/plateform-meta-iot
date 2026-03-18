# Wave 7 Execution Backlog (Ordered)

Date: 2026-03-18
Scope: Partner integration rollout with Schneider BACnet first.

## 1. Priority Model

- `P0`: release-blocking risk on safety, tenant isolation, auth/audit bypass, or command governance.
- `P1`: required for Wave 7 acceptance, but not immediate safety blocker.
- `P2`: optimization and scale improvements that can follow baseline partner enablement.

## 2. Backlog (Dependency Order)

| ID | Priority | Work item | Owner repo | Depends on | Done when |
| --- | --- | --- | --- | --- | --- |
| W7-01 | P0 | Schneider BACnet adapter contract and boundary definition (point model, read/write semantics, alarms/events mapping) (started: baseline freeze doc created) | `partner-integration-layer` + `reference-api-service` | W6 closure | Versioned contract and ownership matrix are approved; no boundary ambiguity remains |
| W7-02 | P0 | Schneider BACnet adapter runtime skeleton with ACL mapping to canonical model | `partner-integration-layer` | W7-01 | Adapter can ingest/normalize baseline Schneider BACnet data through canonical APIs |
| W7-03 | P0 | Security and tenancy enforcement for adapter path (IAM token validation, org/site scope guards, audit records) | `partner-integration-layer` + `identity-access-config` | W7-02 | Unauthorized or cross-tenant operations are rejected and audited |
| W7-04 | P0 | Command/write-path governance integration (no direct adapter bypass of queue/idempotency/safety policy) | `partner-integration-layer` + `channel-policy-router` + `automation-scenario-service` | W7-03 | All partner-originated commands flow through platform command governance plane |
| W7-05 | P1 | Schneider compatibility/integration test suite (protocol edge cases + failure/retry behavior) | `partner-integration-layer` + QA artifacts | W7-02, W7-03, W7-04 | Automated suite passes with deterministic results and documented tolerances |
| W7-06 | P1 | Observability + runbooks for partner adapter operations (SLO, alert routes, incident/rollback) | `platform-foundation` + `partner-integration-layer` | W7-05 | Alerts and runbooks validated with synthetic failure exercises |
| W7-07 | P1 | Tandem Connect track planning packet (scope, risks, acceptance criteria) | `plateform-meta-iot` | W7-01 | Tandem execution plan approved for implementation start |
| W7-08 | P1 | Siemens Building X track planning packet (scope, risks, acceptance criteria) | `plateform-meta-iot` | W7-01 | Siemens execution plan approved for implementation start |
| W7-09 | P2 | Performance and scale hardening for partner adapters (throughput, backpressure, retry tuning) | `partner-integration-layer` + `platform-foundation` | W7-05 | Load profile targets are met and documented |

## 3. Verification Gates Per Item

Each backlog item closes only if all are true:

1. Lint/type/unit/integration checks are green in owning repo.
2. Contract artifacts are regenerated when external schemas/topics/endpoints change.
3. Rollback path is documented and testable.
4. Security and tenancy checks are explicitly covered for adapter-exposed operations.
5. Evidence is recorded in Wave 7 checkpoint updates.

## 4. Suggested Execution Sequence

1. `W7-01` contract/boundary freeze for Schneider BACnet.
2. `W7-02`, `W7-03`, `W7-04` implementation and control integration.
3. `W7-05` compatibility suite stabilization.
4. `W7-06` operations readiness (observability + runbooks).
5. `W7-07`, `W7-08` planning closure for next adapter tracks.
6. `W7-09` scale hardening.

W7-01 baseline document:
- `docs/wave-7-schneider-bacnet-contract.md`
