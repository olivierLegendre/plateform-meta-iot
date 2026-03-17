# Wave 5 Closure Checkpoint (Automation And Operator UI Decoupling)

Date: 2026-03-17
Scope owners: `automation-scenario-service`, `operator-ui`, `channel-policy-router`
Status: Closed for Wave 5 functional slice (workflows + UI actions + auth + e2e)

## 1. Objective

Close the Wave 5 functional slice by moving critical operational workflows into dedicated services/UI, with role-protected mutation actions and cross-service traceable flow.

## 2. Delivered Scope

1. `automation-scenario-service`:
- Task transition endpoint with explicit decisions (`approved` / `rejected`).
- Workflow audit events and audit listing endpoint.
- Bearer-token role checks on workflow mutation endpoints.

2. `operator-ui` (Vue.js):
- Real mutation actions for approvals and reissue.
- API-only integration pattern retained.

3. `channel-policy-router`:
- Command list endpoint used by UI.
- Governance snapshot endpoint used by UI.
- Reissue endpoint with bearer-token role enforcement.

4. End-to-end flow validation:
- Incident precursor command failure.
- Workflow start + approval.
- Command reissue with lineage linkage.

## 3. Acceptance Criteria Mapping

1. Critical operational workflows run outside Node-RED core logic.
- Satisfied by automation workflow transitions + UI actions through service APIs.

2. UI uses service APIs only; no direct SQL access.
- Satisfied by Vue API client layer and route views.

3. End-to-end traceability via correlation/lineage.
- Satisfied by workflow run references and reissued command `parent_command_id` lineage.

## 4. Evidence

Validation commands executed:

### automation-scenario-service
```bash
source .venv/bin/activate
ruff check .
mypy src
pytest
python scripts/export_openapi.py
```

Observed: all green (`4 passed`).

### channel-policy-router
```bash
source .venv/bin/activate
ruff check .
mypy src
pytest -m "not postgres_integration"
./scripts/run_postgres_integration_tests.sh
python scripts/export_openapi.py
```

Observed: all green (`16 passed, 1 deselected` + integration pass).

### operator-ui
```bash
source "$HOME/.nvm/nvm.sh"
nvm use node
npm run typecheck
npm run build
```

Observed: typecheck and build pass.

### cross-service e2e smoke
```bash
./scripts/run_wave5_e2e_smoke.sh
```

Observed: `Wave 5 e2e smoke: PASS`.

## 5. Open Hardening TODOs (Post-slice)

1. Replace unverified JWT payload parsing with full Keycloak token signature/issuer/audience validation.
2. Persist automation workflow state and audit trail in Postgres.
3. Add mutation retry/error UX polish and confirmation patterns in operator UI.
