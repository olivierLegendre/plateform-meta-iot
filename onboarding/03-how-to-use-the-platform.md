# How To Use The Platform

## 1. Daily Start Sequence

1. Start required backends.
2. Start API services.
3. Start `operator-ui`.
4. Run smoke tests before feature work.

## 2. Minimal Local Runtime

### 2.1 Reference API

```bash
cd /home/olivier/work/iot_services/reference-api-service
source .venv/bin/activate
uvicorn reference_api_service.main:app --reload --port 8101
```

### 2.2 Automation Scenario

```bash
cd /home/olivier/work/iot_services/automation-scenario-service
source .venv/bin/activate
uvicorn automation_scenario_service.main:app --reload --port 8102
```

### 2.3 Channel Policy Router

```bash
cd /home/olivier/work/iot_services/channel-policy-router
source .venv/bin/activate
uvicorn channel_policy_router.main:create_app --factory --reload --port 8103
```

### 2.4 Operator UI

```bash
cd /home/olivier/work/iot_services/operator-ui
npm run dev
```

## 3. JWT/Auth Baseline Notes

1. Non-dev mode requires strict JWT settings and non-default secrets.
2. Keycloak baseline config is managed in `identity-access-config`.
3. Vault runtime baseline should be validated before non-dev launch.

## 4. Safe Change Workflow

1. Make changes in one service at a time.
2. Run that service's local tests.
3. Run function-by-function checks for impacted flows.
4. Re-run Wave 1 baseline proofs if security/foundation paths changed.

## 5. Incident/Recovery Quick Actions

1. Use service runbooks under each repo `docs/runbooks/`.
2. Re-run baseline proofs to confirm recovery state:
- `run_wave1_vault_runtime_baseline.sh`
- `run_wave1_observability_baseline.sh`
- `run_wave1_tenant_isolation_checks.sh`

## 6. Release Readiness Quick Check

1. Service-level tests green.
2. Function-level checks green.
3. GHCR pullability and namespace readiness green.
4. No unresolved high-severity security or isolation findings.
