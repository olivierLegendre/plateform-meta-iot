# Wave 7 - W7-09 Performance And Scale Hardening Baseline

Date: 2026-03-18
Status: Draft baseline (execution started)
Owners: Partner Integration Layer + Platform Foundation

## 1. Purpose

Start W7-09 with a measurable scale-hardening baseline for partner adapters (throughput, backpressure, retry tuning) without changing Wave 7 ownership boundaries.

## 2. Scope

In scope:
1. Define initial load profile targets for normalize and command-intent routes.
2. Define backpressure behavior expectations and overload failure semantics.
3. Define retry tuning guardrails for transient downstream failures.
4. Define evidence artifacts needed to close W7-09.

Out of scope:
1. Full production load certification.
2. Cloud/provider-specific autoscaling design.
3. Any change to command governance ownership rules.

## 3. Baseline Load Profile Targets (Initial)

Adapter API targets (single instance baseline):
1. normalize route sustained rate: 100 requests/second for 15 minutes.
2. command-intent route sustained rate: 40 requests/second for 15 minutes.
3. p95 latency target under steady load:
- normalize route: <= 250 ms
- command-intent route: <= 400 ms
4. error-rate target under steady load: < 1% (excluding induced dependency faults).

## 4. Backpressure And Failure Semantics

1. Adapter should fail fast with bounded queueing when downstream governance is saturated.
2. `503` remains the canonical overload/downstream-unavailable error for command-intent handoff failures.
3. No local direct command execution path is allowed under overload conditions.

## 5. Retry Tuning Baseline

1. Transient downstream failure retry budget:
- max retries: 2
- exponential backoff base: 200 ms
- jitter enabled.
2. Non-retriable failures (4xx validation/policy errors) fail fast with no retry loop.

## 6. Evidence Required For W7-09 Closure

1. Load-test scenario definitions and reproducible command lines in `partner-integration-layer`.
2. Observability wiring for scale indicators in `platform-foundation/observability`.
3. Report artifact with measured throughput/latency/error outcomes and pass/fail interpretation.
4. Updated rollback guidance for performance regressions.

## 7. Immediate Next Tasks

1. Add adapter performance runbook/checklist in `partner-integration-layer`.
2. Add synthetic load breach examples and alert assertions in `platform-foundation/observability`.
3. Execute first baseline load run and record results in Wave 7 checkpoint evidence.

## 8. First Baseline Execution Evidence

1. baseline smoke profile executed on 2026-03-18 with local uvicorn runtime and governance stub mode enabled;
2. profile parameters: `duration=5s`, `normalize=10 rps`, `command=4 rps`;
3. result: `PASS`;
4. report artifact: `platform-foundation/observability/reports/wave7-partner-scale-baseline.json`.

## 9. Standard Baseline Execution Evidence

1. baseline standard profile executed on 2026-03-18 with local uvicorn runtime and governance stub mode enabled;
2. profile parameters: `duration=15s`, `normalize=100 rps`, `command=40 rps`;
3. result: `PASS`;
4. measured highlights:
- normalize route: `1500/1500` success, `p95=3.9967 ms`, `error_rate=0.0%`;
- command-intent route: `600/600` success, `p95=2.2654 ms`, `error_rate=0.0%`;
5. report artifact: `platform-foundation/observability/reports/wave7-partner-scale-baseline-standard.json`.

## 10. Load-Breach Alert Assertion Evidence

1. observability mapping/rules/synthetic payloads were extended with explicit load-breach signals:
- `partner_adapter_command_intent_rps`
- `partner_adapter_overload_reject_ratio`
2. verifier was updated to require the new mapping keys, alert rules, and synthetic payload keys.
3. verification result: `PASS`, `findings=0`.
4. report artifact: `platform-foundation/observability/reports/wave7-partner-observability-verification.json`.

## 11. Cross-Service Integrated Load Validation Evidence

1. integrated real-handoff profile executed on 2026-03-18 with live `channel-policy-router` handoff (`mode=real`);
2. profile parameters: `duration=10s`, `normalize=40 rps`, `command=20 rps`, `target_point_cardinality=50`;
3. result: `PASS`;
4. measured highlights:
- normalize route: `400/400` success, `p95=1.8909 ms`, `error_rate=0.0%`;
- command-intent route: `200/200` success, `p95=50.2022 ms`, `error_rate=0.0%`;
5. report artifact: `platform-foundation/observability/reports/wave7-partner-scale-integration-real-controlled.json`.
