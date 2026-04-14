# Service-By-Service Testing

## 1. Prerequisites

1. Docker is running.
2. Python virtual environments are initialized for Python services.
3. Node tooling is initialized for `operator-ui`.
4. You are in `/home/olivier/work/iot_services`.
5. `python3.12` is available in PATH (`python3.12 --version`).

## 2. Reference API Service

```bash
cd /home/olivier/work/iot_services/reference-api-service
PYTHON_BIN=python3.12 ./scripts/setup_dev.sh
source .venv/bin/activate
pytest -q
./scripts/run_postgres_integration_tests.sh
```

## 3. Device Ingestion Service

```bash
cd /home/olivier/work/iot_services/device-ingestion-service
PYTHON_BIN=python3.12 ./scripts/setup_dev.sh
source .venv/bin/activate
pytest -q
./scripts/run_postgres_integration_tests.sh
```

## 4. Channel Policy Router

```bash
cd /home/olivier/work/iot_services/channel-policy-router
PYTHON_BIN=python3.12 ./scripts/setup_dev.sh
source .venv/bin/activate
pytest -q
./scripts/run_postgres_integration_tests.sh
```

## 5. Automation Scenario Service

```bash
cd /home/olivier/work/iot_services/automation-scenario-service
PYTHON_BIN=python3.12 ./scripts/setup_dev.sh
source .venv/bin/activate
pytest -q
```

## 6. Operator UI

```bash
cd /home/olivier/work/iot_services/operator-ui
./scripts/setup_dev.sh
npm run typecheck
npm run build
```

## 7. Identity Access Config

```bash
cd /home/olivier/work/iot_services/identity-access-config
set -a
source .env.keycloak.example
set +a
python3 scripts/render_realm_export.py --template keycloak/templates/realm-export.template.json --out keycloak/generated/realm-export.local.json
python3 scripts/validate_realm_export.py --realm-export keycloak/generated/realm-export.local.json
```

## 8. Platform Foundation Baselines

```bash
cd /home/olivier/work/iot_services/platform-foundation
PYTHON_BIN=python3.12 ./deploy/production/scripts/run_wave1_vault_runtime_baseline.sh
PYTHON_BIN=python3.12 ./deploy/production/scripts/run_wave1_observability_baseline.sh
```

## 9. Partner Integration Layer

```bash
cd /home/olivier/work/iot_services/partner-integration-layer
PYTHON_BIN=python3.12 ./scripts/setup_dev.sh
source .venv/bin/activate
pytest -q
```

## 10. Exit Criteria

1. Every command above exits `0`.
2. No `FAIL` status appears in generated Wave 1 reports.
3. Service-level blockers are logged before moving to function-by-function testing.
