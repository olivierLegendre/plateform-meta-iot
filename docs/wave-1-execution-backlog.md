# Wave 1 Execution Backlog (Ordered)

Date: 2026-03-18
Scope: complete the pending Foundation And Security Baseline.

## 1. Priority Model

- `P0`: go-live blocking control (security/isolation/secrets).
- `P1`: required closure evidence and operational baseline.
- `P2`: quality/optimization after mandatory controls are green.

## 2. Backlog (Dependency Order)

| ID | Priority | Work item | Owner repo | Depends on | Done when |
| --- | --- | --- | --- | --- | --- |
| W1-01 | P0 | Establish Wave 1 closure evidence contract (artifacts, commands, owner sign-off template) | `plateform-meta-iot` | none | Kickoff/backlog + closure template path are defined and referenced |
| W1-02 | P0 | Build Keycloak baseline in `identity-access-config` (realm export, clients, roles/scopes, env-driven values, bootstrap runbook) | `identity-access-config` | W1-01 | Config is versioned and reproducible via runbook; no hardcoded secrets |
| W1-03 | P0 | Wire Vault runtime baseline for non-dev deployment path and validate generated runtime env contract | `platform-foundation` + service repos | W1-01 | Vault contract/render/validate flow is executable and referenced in deploy runbooks |
| W1-04 | P0 | Add tenant-isolation verification checks for critical services (org boundary deny assertions) | service repos + `plateform-meta-iot` | W1-01 | Automated tests/reports prove DB-level org isolation behavior |
| W1-05 | P1 | Confirm foundation observability baseline (Grafana dashboard/alerts + synthetic verification evidence) | `platform-foundation` | W1-03 | Wave 1 observability evidence report is PASS and linked in runbook |
| W1-06 | P1 | Consolidate security baseline docs with explicit acceptance mapping to V1 system spec | `plateform-meta-iot` | W1-02, W1-03, W1-04, W1-05 | Traceable mapping exists from spec requirement to artifact/report |
| W1-07 | P1 | Produce Wave 1 closure sign-off record and update architecture matrix status to completed | `plateform-meta-iot` | W1-06 | Wave 1 is formally closed with approvals and evidence bundle |

## 2.1 Progress Snapshot

Completed:
1. `W1-01` closure evidence contract is established via kickoff + ordered backlog docs.
2. `W1-02` Keycloak baseline scaffold implemented in `identity-access-config`:
- `keycloak/templates/realm-export.template.json`
- `scripts/render_realm_export.py`
- `scripts/validate_realm_export.py`
- `docs/runbooks/keycloak-bootstrap.md`
- `.env.keycloak.example`
3. `W1-03` Vault runtime baseline proof runner implemented in `platform-foundation`:
- `deploy/production/scripts/run_wave1_vault_runtime_baseline.sh`
- `vault/scripts/evaluate_wave1_vault_runtime_baseline.py`
- `vault/reports/w1-vault-runtime-baseline-report.json`
4. `W1-04` tenant-isolation verification checks implemented and automated:
- `reference-api-service/tests/test_postgres_integration.py` (`test_postgres_tenant_scope_isolation`)
- `device-ingestion-service/tests/test_postgres_integration.py` (`test_postgres_dead_letter_scope_isolation`)
- `channel-policy-router/tests/test_postgres_integration.py` (`test_postgres_site_scope_isolation_for_listing`)
- `automation-scenario-service/tests/test_api_smoke.py` (`test_list_runs_is_site_scoped`)
- `scripts/run_wave1_tenant_isolation_checks.sh`
- `docs/wave-1-tenant-isolation-report.json`
5. `W1-05` observability baseline confirmation automated in `platform-foundation`:
- `deploy/production/scripts/run_wave1_observability_baseline.sh`
- `observability/reports/w1-observability-wiring-verification.json`
- `observability/reports/w1-observability-baseline-report.json`
6. `W1-06` security baseline traceability matrix documented:
- `docs/wave-1-security-baseline-traceability.md`
7. `W1-07` closure sign-off and architecture status completion documented:
- `docs/wave-1-closure-signoff.md`
- `docs/target-architecture-and-migration.md` (Wave 1 status `completed`)
- `docs/wave-1-kickoff-checkpoint.md` (status `Closed`)

Validation evidence:
1. `render_realm_export.py` executed successfully.
2. `validate_realm_export.py` returned `PASS`.
3. `run_wave1_vault_runtime_baseline.sh` executed successfully (`status: PASS`).
4. `run_wave1_tenant_isolation_checks.sh` executed successfully (`status: PASS`).
5. `run_wave1_observability_baseline.sh` executed successfully (`status: PASS`).
6. Requirement-to-evidence mapping recorded and linked from architecture master document.
7. Wave 1 closure sign-off recorded and status moved to `completed`.

## 3. Verification Gates Per Item

Each item closes only if all are true:

1. A reproducible command/runbook exists for evidence regeneration.
2. Evidence artifact is committed in the owning repo.
3. Security posture is not downgraded (authz, secrets, tenant isolation, audit).
4. Rollback or safe-fail behavior is documented for operational incidents.

## 4. Suggested Step-by-Step Execution

1. Execute `W1-01` and lock the evidence contract.
2. Execute `W1-02` for Keycloak baseline.
3. Execute `W1-03` for Vault runtime path.
4. Execute `W1-04` for tenant isolation verification.
5. Execute `W1-05` for observability baseline confirmation.
6. Execute `W1-06` and prepare closure package.
7. Execute `W1-07` closure sign-off.
