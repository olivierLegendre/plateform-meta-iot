# Wave 4 Closure Checkpoint (Command And Safety Plane)

Date: 2026-03-13
Scope owner: `channel-policy-router`
Status: Closed and frozen for Wave 4

## 1. Objective

Freeze the Wave 4 baseline for command and safety behavior before progressing further.

## 2. Implemented Deliverables

1. Class-based command policy matrix.
2. API-primary channel selection with policy-controlled MQTT fallback.
3. Queueing, strict serialization, idempotency, correlation, and reconciliation controls.
4. Incident hooks with retry/backoff delivery.
5. Lease-protected batch runners for SLA evaluation and incident delivery.

## 3. Acceptance Criteria Mapping

1. HTTP behavior and policy restrictions:
- `422` for invalid policy/required key violations.
- `503` + `Retry-After` for queue saturation policy.

2. Queue and safety behavior:
- FIFO queue with safety-critical prioritization in queued items.
- No preemption of already in-flight command.

3. Reconciliation visibility:
- SLA evaluator endpoint and worker script available for periodic checks.

## 4. Evidence (Validation Run)

Validation executed on 2026-03-13 in `channel-policy-router`:

```bash
source .venv/bin/activate
ruff check .
mypy src
pytest -m "not postgres_integration"
./scripts/run_postgres_integration_tests.sh
```

Observed results:
- `ruff`: all checks passed.
- `mypy`: success, no issues in source files.
- unit/API tests: `14 passed, 1 deselected`.
- Postgres integration: `1 passed, 14 deselected`.

## 5. Wave 4 Runtime Surface

Key endpoints:
- `POST /api/v1/commands`
- `POST /api/v1/commands/{command_id}/dispatch`
- `POST /api/v1/commands/{command_id}/reconcile`
- `POST /api/v1/commands/{command_id}/check-sla`
- `POST /api/v1/sla/evaluate`
- `GET /api/v1/incidents/hooks`
- `POST /api/v1/incidents/hooks/deliver`

Key scripts:
- `scripts/run_sla_evaluator.py`
- `scripts/run_incident_delivery_worker.py`
- `scripts/run_postgres_integration_tests.sh`

## 6. Explicit Freeze Boundary

Included in freeze:
- `channel-policy-router` command/safety behaviors listed above.
- Corresponding test and contract coverage.

Not included in this freeze:
- Wave 5 user workflow/UI expansion.
- Post-V1 partner adapters.

## 7. Exit Condition From Freeze

Wave 5 work can proceed only when this checkpoint remains green after any Wave 4 bug fix (lint, typecheck, tests, and contract checks).
