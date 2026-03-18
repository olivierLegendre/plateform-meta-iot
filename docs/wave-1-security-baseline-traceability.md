# Wave 1 Security Baseline Traceability

Date: 2026-03-18
Status: closed
Scope: explicit mapping from Wave 1 and V1 security/foundation requirements to implementation evidence and reproducible verification commands.

## 1. Requirement-To-Evidence Matrix

| Requirement source | Requirement | Evidence artifacts | Verification command(s) | Status |
| --- | --- | --- | --- | --- |
| `target-architecture-and-migration.md` Wave 1 Deliverable #2 | Keycloak realm, clients, role model and token-validation baseline | `identity-access-config/keycloak/templates/realm-export.template.json`<br>`identity-access-config/scripts/render_realm_export.py`<br>`identity-access-config/scripts/validate_realm_export.py`<br>`identity-access-config/docs/runbooks/keycloak-bootstrap.md` | `cd /home/olivier/work/iot_services/identity-access-config && set -a && source .env.keycloak.example && set +a && python3 scripts/render_realm_export.py --template keycloak/templates/realm-export.template.json --out keycloak/generated/realm-export.local.json && python3 scripts/validate_realm_export.py --realm-export keycloak/generated/realm-export.local.json` | PASS |
| `target-architecture-and-migration.md` Wave 1 Deliverable #3 | Vault operational baseline (go-live blocker) | `platform-foundation/deploy/production/scripts/run_wave1_vault_runtime_baseline.sh`<br>`platform-foundation/vault/scripts/evaluate_wave1_vault_runtime_baseline.py`<br>`platform-foundation/vault/reports/w1-vault-runtime-baseline-report.json` | `cd /home/olivier/work/iot_services/platform-foundation && ./deploy/production/scripts/run_wave1_vault_runtime_baseline.sh` | PASS |
| `target-architecture-and-migration.md` Wave 1 Deliverable #4 | PostgreSQL tenant isolation baseline (organization boundary) | `plateform-meta-iot/scripts/run_wave1_tenant_isolation_checks.sh`<br>`plateform-meta-iot/docs/wave-1-tenant-isolation-report.json`<br>`reference-api-service/tests/test_postgres_integration.py`<br>`device-ingestion-service/tests/test_postgres_integration.py`<br>`channel-policy-router/tests/test_postgres_integration.py`<br>`automation-scenario-service/tests/test_api_smoke.py` | `cd /home/olivier/work/iot_services/plateform-meta-iot && ./scripts/run_wave1_tenant_isolation_checks.sh` | PASS |
| `target-architecture-and-migration.md` Wave 1 Deliverable #5 | Grafana/alert scaffolding baseline | `platform-foundation/deploy/production/scripts/run_wave1_observability_baseline.sh`<br>`platform-foundation/observability/reports/w1-observability-wiring-verification.json`<br>`platform-foundation/observability/reports/w1-observability-baseline-report.json` | `cd /home/olivier/work/iot_services/platform-foundation && ./deploy/production/scripts/run_wave1_observability_baseline.sh` | PASS |
| `target-architecture-and-migration.md` Wave 1 Acceptance #1 | Authn/authz checks pass at service boundaries | `channel-policy-router/tests/test_auth_config.py`<br>`automation-scenario-service/tests/test_auth_config.py`<br>`automation-scenario-service/tests/test_api_smoke.py::test_workflow_mutation_requires_roles` | `cd /home/olivier/work/iot_services/channel-policy-router && source .venv/bin/activate && pytest -q tests/test_auth_config.py`<br>`cd /home/olivier/work/iot_services/automation-scenario-service && source .venv/bin/activate && pytest -q tests/test_auth_config.py tests/test_api_smoke.py::test_workflow_mutation_requires_roles` | PASS (baseline checks present and executable) |
| `target-architecture-and-migration.md` Wave 1 Acceptance #2 | Secrets not stored in code/plain committed env outside approved path | `platform-foundation/vault/README.md`<br>`platform-foundation/vault/secrets-contract.yaml`<br>`platform-foundation/vault/examples/vault-export.example.json`<br>`identity-access-config/.gitignore` (`.env.keycloak`) | `cd /home/olivier/work/iot_services/platform-foundation && ./deploy/production/scripts/run_wave1_vault_runtime_baseline.sh` | PASS |
| `target-architecture-and-migration.md` Wave 1 Acceptance #3 | Isolation tests prove cross-organization read/write denial | `plateform-meta-iot/docs/wave-1-tenant-isolation-report.json` | `cd /home/olivier/work/iot_services/plateform-meta-iot && ./scripts/run_wave1_tenant_isolation_checks.sh` | PASS |
| `v1-system-specification.md` §6.1, §6.2 | Keycloak mandatory, role model present | `identity-access-config/keycloak/templates/realm-export.template.json` | Same as Keycloak render/validate command above | PASS |
| `v1-system-specification.md` §5.3 | Hard data isolation at organization boundary | `plateform-meta-iot/docs/wave-1-tenant-isolation-report.json` | Same as tenant-isolation command above | PASS |
| `v1-system-specification.md` §3 Decision #6 | Observability baseline in V1 (Grafana OSS) | `platform-foundation/observability/reports/w1-observability-baseline-report.json` | Same as Wave 1 observability command above | PASS |

## 2. Consolidated Evidence Artifacts

1. `platform-foundation/vault/reports/w1-vault-runtime-baseline-report.json`
2. `plateform-meta-iot/docs/wave-1-tenant-isolation-report.json`
3. `platform-foundation/observability/reports/w1-observability-baseline-report.json`
4. `platform-foundation/observability/reports/w1-observability-wiring-verification.json`

## 3. Closure Notes

1. Wave 1 evidence is traceable from requirement -> artifact -> command.
2. Closure sign-off is recorded in `docs/wave-1-closure-signoff.md`.
