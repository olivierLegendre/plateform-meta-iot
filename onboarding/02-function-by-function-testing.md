# Function-By-Function Testing

## 1. Objective

Validate business capabilities across service boundaries after service-level checks are green.

## 2. Foundation and Security Functions

### 2.1 Tenant isolation

```bash
cd /home/olivier/work/iot_services/plateform-meta-iot
./scripts/run_wave1_tenant_isolation_checks.sh
```

Expected: `status: PASS` in `docs/project-monitoring/waves/wave-1-tenant-isolation-report.json`.

### 2.2 Vault runtime baseline

```bash
cd /home/olivier/work/iot_services/platform-foundation
PYTHON_BIN=python3.12 ./deploy/production/scripts/run_wave1_vault_runtime_baseline.sh
```

Expected: `status: PASS` in `vault/reports/w1-vault-runtime-baseline-report.json`.

### 2.3 Observability baseline

```bash
cd /home/olivier/work/iot_services/platform-foundation
PYTHON_BIN=python3.12 ./deploy/production/scripts/run_wave1_observability_baseline.sh
```

Expected: `status: PASS` in `observability/reports/w1-observability-baseline-report.json`.

## 3. Command and Workflow Functions

### 3.1 Channel policy router command flow

```bash
cd /home/olivier/work/iot_services/channel-policy-router
source .venv/bin/activate
pytest -q tests/test_api_smoke.py
```

### 3.2 Automation workflow and approval flow

```bash
cd /home/olivier/work/iot_services/automation-scenario-service
source .venv/bin/activate
pytest -q tests/test_api_smoke.py
```

## 4. Ingestion and Reference Functions

### 4.1 Ingestion processing and dead-letter behavior

```bash
cd /home/olivier/work/iot_services/device-ingestion-service
source .venv/bin/activate
pytest -q tests/test_api_smoke.py tests/test_poc_golden_regression.py
```

### 4.2 Reference lifecycle and mapping/link behavior

```bash
cd /home/olivier/work/iot_services/reference-api-service
source .venv/bin/activate
pytest -q tests/test_api_smoke.py tests/test_poc_golden_regression.py
```

## 5. UI Function Checks

```bash
cd /home/olivier/work/iot_services/operator-ui
npm run typecheck
npm run build
```

Run the UI manually:

```bash
cd /home/olivier/work/iot_services/operator-ui
npm run dev
```

Open:
- `http://localhost:5173`

Run required backends in separate terminals:

```bash
# terminal A
cd /home/olivier/work/iot_services/automation-scenario-service
source .venv/bin/activate
uvicorn automation_scenario_service.main:app --reload --port 8102

# terminal B
cd /home/olivier/work/iot_services/channel-policy-router
source .venv/bin/activate
uvicorn channel_policy_router.main:create_app --factory --reload --port 8103
```

If needed, set UI API base URLs in `operator-ui/.env.local`:

```env
VITE_AUTOMATION_API_BASE=http://localhost:8102
VITE_CHANNEL_ROUTER_API_BASE=http://localhost:8103
```

Then manually verify:
1. approvals view loads;
2. incidents view loads;
3. reissue action is reachable;
4. governance view renders.

## 6. Container and Deployment Functions

### 6.1 GHCR image pullability

```bash
cd /home/olivier/work/iot_services/platform-foundation
IMAGE_TAG=v0.2.0 ./deploy/production/scripts/verify_ghcr_images_pullable.sh
```

### 6.2 Namespace/topology readiness

```bash
cd /home/olivier/work/iot_services/platform-foundation
IMAGE_TAG=v0.2.0 ./deploy/production/scripts/run_wave8_namespace_readiness.sh
```

## 7. Exit Criteria

1. All function checks pass.
2. No regression from closed-wave evidence reports.
3. Remaining defects are documented with owner, severity, and next action.
