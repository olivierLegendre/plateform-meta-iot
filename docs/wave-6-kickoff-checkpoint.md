# Wave 6 Kickoff Checkpoint (Node-RED Retirement And Hardening)

Date: 2026-03-17
Status: In progress

## 1. Objective

Start Wave 6 by removing residual runtime risk from Node-RED and converting remaining hardening TODOs into explicit implementation tracks.

## 2. Completed At Kickoff

1. JWT mutation auth hardening completed in:
- `automation-scenario-service`
- `channel-policy-router`

2. Validation green after hardening:
- service lint + mypy + tests
- `channel-policy-router` Postgres integration tests
- cross-service Wave 5 e2e smoke

## 2.1 W6-01 Enforcement Artifacts (Implemented Baseline)

Implemented in `platform-foundation`:
- `nodered/policy/bridge_allowlist.json`
- `nodered/scripts/audit_bridge_policy.py`
- `nodered/scripts/run_bridge_policy_gate.sh`
- `nodered/reports/poc_bridge_policy_report.json`
- `nodered/flows/bridge_only_template.json`
- `.github/workflows/nodered-bridge-policy-gate.yml`
- `nodered/reports/bridge_policy_gate_report.json`

Baseline audit against `/home/olivier/Public/poc/stack/nodered/data/flows.json`:
- `nodes=169`
- `violations=270`

Current interpretation: bridge-only baseline is implemented for managed runtime artifacts (CI gate + compliant bridge flow with 0 violations). Legacy PoC flow remains non-compliant (270 violations) and is tracked for migration cutover in W6-02..W6-05.

## 2.2 W6-02 Ingestion Cutover Artifacts (Started)

Implemented in `platform-foundation`:
- `nodered/scripts/extract_ingestion_cutover_candidates.py`
- `nodered/reports/poc_ingestion_cutover_candidates.json`
- `nodered/scripts/apply_ingestion_cutover.py`
- `nodered/reports/poc_ingestion_cutover_actions.json`
- `nodered/flows/poc_ingestion_cutover_preview.json`
- `nodered/reports/poc_ingestion_cutover_bridge_audit.json`
- `nodered/ingestion-cutover.md`

Baseline extraction from PoC flow:
- `seed_count=5`
- `candidate_count=22`
- candidate types include `function`, `postgresql`, and ingest `mqtt in` handlers.

Current interpretation: ingestion cutover is now executable in preview mode (22 candidates, 7 ingestion nodes disabled, bridge-policy violations reduced from 270 to 257). Final closure still requires applying equivalent disablement in production runtime and validating ingest traffic through `device-ingestion-service`.

## 2.3 W6-03 Reference/Mapping API Cutover Artifacts (Started)

Implemented in `platform-foundation`:
- `nodered/scripts/extract_reference_api_cutover_candidates.py`
- `nodered/reports/poc_reference_api_cutover_candidates.json`
- `nodered/scripts/apply_reference_api_cutover.py`
- `nodered/reports/poc_reference_api_cutover_actions.json`
- `nodered/flows/poc_reference_api_cutover_preview.json`
- `nodered/reports/poc_reference_api_cutover_bridge_audit.json`
- `nodered/reference-api-cutover.md`

Baseline extraction from PoC flow:
- `seed_count=42`
- `candidate_count=61`
- `http in=7`, `http response=7`, plus `function` and `postgresql` chain nodes.

Current interpretation: reference/mapping API cutover is now executable in preview mode (61 candidates, 55 nodes disabled, bridge-policy violations reduced from 270 to 174). Final closure still requires applying equivalent disablement in production runtime and validating contract parity on `reference-api-service`.

## 2.4 W6-04 Scenario/Routing Cutover Artifacts (Started)

Implemented in `platform-foundation`:
- `nodered/scripts/extract_scenario_router_cutover_candidates.py`
- `nodered/reports/poc_scenario_router_cutover_candidates.json`
- `nodered/scripts/apply_scenario_router_cutover.py`
- `nodered/reports/poc_scenario_router_cutover_actions.json`
- `nodered/flows/poc_scenario_router_cutover_preview.json`
- `nodered/reports/poc_scenario_router_cutover_bridge_audit.json`
- `nodered/scenario-router-cutover.md`

Baseline extraction from PoC flow:
- `seed_count=6`
- `candidate_count=15`
- includes scenario `function` chain and MQTT command publish node(s).

Current interpretation: scenario-routing cutover is now executable in preview mode (15 candidates, 11 nodes disabled, bridge-policy violations reduced from 270 to 245). Final closure still requires applying equivalent disablement in production runtime and validating end-to-end scenario->command execution in `automation-scenario-service` + `channel-policy-router`.

## 2.5 W6-05 Dashboard Read-Path Cutover Artifacts (Started)

Implemented in `platform-foundation`:
- `nodered/scripts/extract_dashboard_cutover_candidates.py`
- `nodered/reports/poc_dashboard_cutover_candidates.json`
- `nodered/scripts/apply_dashboard_cutover.py`
- `nodered/reports/poc_dashboard_cutover_actions.json`
- `nodered/flows/poc_dashboard_cutover_preview.json`
- `nodered/reports/poc_dashboard_cutover_bridge_audit.json`
- `nodered/dashboard-cutover.md`

Baseline extraction from PoC flow:
- `seed_count=71`
- `candidate_count=92`
- includes `ui-*`, dashboard `function`, and `postgresql` read-path nodes.

Current interpretation: dashboard cutover is now executable in preview mode (92 candidates, 83 nodes disabled, bridge-policy violations reduced from 270 to 130). Final closure still requires applying equivalent disablement in production runtime and validating operator-ui/Grafana parity against service-owned read paths.

## 2.6 W6-06 JWT Strict Verification Profile (Implemented)

Implemented in services:
- `automation-scenario-service`
- `channel-policy-router`

Changes:
- Added env-aware strict mode (`APP_ENV != dev` => issuer/audience required unless overridden).
- Added `build_jwt_verifier_config(...)` guard that fails startup config when strict mode lacks issuer/audience.
- Added test coverage for strict and non-strict behavior in both services.

Validation:
- automation: lint, mypy, pytest green
- channel: lint, mypy, pytest green + Postgres integration green

Current interpretation: JWT verification profile baseline is in place for production strictness controls; next security hardening step is Vault runtime secret wiring (`W6-07`).

## 2.7 W6-07 Vault Bootstrap And Non-Dev Secret Guards (Implemented)

Implemented in `platform-foundation`:
- `vault/README.md`
- `vault/secrets-contract.yaml`
- `vault/examples/vault-export.example.json`
- `vault/scripts/render_runtime_env.py`
- `vault/scripts/validate_runtime_env.py`
- `vault/examples/docker-compose.secrets.override.yaml`

Implemented in services (`automation-scenario-service`, `channel-policy-router`):
- Non-dev startup guard rejects default dev JWT secret.
- Strict-mode JWT config still enforces issuer/audience requirements from W6-06.

Validation:
- Vault renderer compiled and generated service `.env` files from example payload.
- Runtime env validator passes against rendered files (required keys + non-dev secret policy).
- automation: lint, mypy, pytest green.
- channel: lint, mypy, pytest green + Postgres integration green.

Current interpretation: Wave 6 baseline for Vault bootstrap is implemented (contract + render + validate + deploy wiring example). Remaining future work is production injector automation hardening.

## 2.8 W6-08 Service Runbooks (Implemented Baseline)

Implemented baseline runbook docs in:
- `reference-api-service/docs/runbooks/incident-rollback-recovery.md`
- `device-ingestion-service/docs/runbooks/incident-rollback-recovery.md`
- `automation-scenario-service/docs/runbooks/incident-rollback-recovery.md`
- `channel-policy-router/docs/runbooks/incident-rollback-recovery.md`
- `operator-ui/docs/runbooks/incident-rollback-recovery.md`

Linked from service READMEs under `Operations Runbook`.

Automated baseline verification:
- `plateform-meta-iot/scripts/verify_wave6_runbooks.sh`
- `plateform-meta-iot/docs/wave-6-runbook-verification-report.md` (PASS)

Current interpretation: W6-08 baseline is implemented and structurally verified across target repos. Remaining governance step is explicit service-owner operational sign-off.

## 2.9 W6-09 SLO + Alerting Baseline (Implemented Baseline)

Implemented in `platform-foundation`:
- `observability/README.md`
- `observability/slo-targets.yaml`
- `observability/prometheus/rules/wave6-critical-path-alerts.yaml`
- `observability/metric-name-mapping.yaml`
- `observability/alertmanager/wave6-alert-routing.yaml`
- `observability/scripts/run_synthetic_alert_checks.py`
- `observability/scripts/verify_wave6_observability.py`
- `observability/examples/synthetic-metrics-healthy.json`
- `observability/examples/synthetic-metrics-breach.json`
- `observability/reports/wave6-observability-verification.json`

Validation:
- Synthetic healthy payload returns PASS.
- Synthetic breach payload returns FAIL with explicit threshold violations.
- Observability wiring verifier returns `PASS` with `findings=0`.

Current interpretation: W6-09 baseline is implemented with enforceable thresholds, mapped metric names, alert routing, and an executable verification report. Remaining production work is integration into shared monitoring deployment pipelines.


## 2.10 W6-10 Node-RED Retirement Cutover (Started)

Implemented in `platform-foundation`:
- `nodered/scripts/apply_retirement_cutover.py`
- `nodered/flows/poc_retirement_cutover_preview.json`
- `nodered/reports/poc_retirement_cutover_actions.json`
- `nodered/reports/poc_retirement_cutover_bridge_audit.json`
- `nodered/retirement-cutover.md`
- `nodered/scripts/verify_nodered_topology_retired.py`
- `nodered/reports/w6_topology_retirement_verification.json`
- `nodered/reports/poc_topology_retirement_gap_report.json`
- `nodered/scripts/run_w6_topology_release_gate.sh`
- `nodered/policy/w6_topology_release_gate.manifests.txt`
- `nodered/reports/w6_topology_release_gate_report.json`
- `nodered/scripts/evaluate_w6_retirement_readiness.py`
- `nodered/reports/w6_retirement_readiness_report.json`
- `deploy/production/README.md`
- `deploy/production/compose/reference-api.compose.yaml`
- `deploy/production/compose/device-ingestion.compose.yaml`
- `deploy/production/compose/channel-policy-router.compose.yaml`
- `deploy/production/compose/vault-secrets-runtime.compose.yaml`
- `docs/container-image-tagging-policy.md`
- `nodered/topology-retirement-check.md`

Validation:
- Retirement cutover preview generated from PoC flow (`total_input_nodes=169`).
- Preview output has `disabled_runtime_count=134` and `removed_config_count=24`.
- Bridge policy audit on active preview nodes returns `violations=0`.
- Topology verifier report on managed manifests returns `status=PASS`, `manifest_count=4`, `checked_service_count=5`, `finding_count=0`.
- Legacy PoC topology report returns `status=FAIL`, `manifest_count=1`, `checked_service_count=8`, `finding_count=2` (Node-RED service still present).
- One-command release gate report returns `status=PASS`, `manifest_count=4`, `checked_service_count=5`, `finding_count=0` on managed manifest set.
- Readiness evaluator latest rerun (2026-03-18, with `--manifest-set`) returns `decision=READY_FOR_W6_10_CLOSURE`, `blocker_count=0`, `warning_count=0`.

Current interpretation: W6-10 technical controls are ready for closure with manifest-set confirmation in place. Remaining governance actions are owner sign-off and final production artifact publication verification.
Governance sign-off record template and command checklist are tracked in `docs/wave-6-closure-signoff.md`.

## 2.11 W6-11 Baseline Service Image Publish Pipelines (Implemented Baseline)

Implemented in services:
- `reference-api-service/.github/workflows/image-publish.yml`
- `device-ingestion-service/.github/workflows/image-publish.yml`
- `channel-policy-router/.github/workflows/image-publish.yml`
- `automation-scenario-service/.github/workflows/image-publish.yml`
- `operator-ui/.github/workflows/image-publish.yml`

Baseline behavior:
- publishes to `ghcr.io/olivierlegendre/<service-name>`;
- supports tag-driven release (`v*`) and manual dispatch (`image_tag`);
- emits immutable tag set (`release` tag + `sha-<12>` fallback).

Deferred hardening TODOs (explicit, non-blocking for this baseline):
- provenance/SBOM attestations and signing;
- vulnerability scanning gate with fail threshold;
- OIDC least-privilege publish strategy + later org migration to `ghcr.io/ramery`.

Current interpretation: W6 image closure target is pipeline-ready images with pullability evidence, not full supply-chain hardening completion.

## 3. Node-RED Dependency Inventory (From PoC)

Inventory source checked:
- `/home/olivier/Public/poc/stack/nodered/data/flows.json`
- `/home/olivier/Public/poc/stack/docker-compose.yml`
- `/home/olivier/Public/poc/stack/nodered/data/lib/domain/index.js`
- `/home/olivier/Public/poc/stack/nodered/data/lib/repo/index.js`

Observed PoC footprint:
- 1 Node-RED tab: `PoC MQTT PostgreSQL + Dashboard`
- 143 nodes total
- 67 `function` nodes
- 24 `postgresql` nodes
- 2 `mqtt in` nodes
- 1 `mqtt out` node
- 7 `http in` + 7 `http response` nodes

### Decommission Classification Table

| Flow family (PoC) | Evidence pattern | Classification | Owner | Replacement target | Target date |
| --- | --- | --- | --- | --- | --- |
| Ingestion parse/normalize + device upsert | `domain.ingest.*`, `repo.devices.*`, `repo.telemetry.*` | `replace_with_service` | `device-ingestion-service` | Keep `device-ingestion-service` as single ingest path; disable equivalent Node-RED handlers | 2026-04-15 |
| Mapping candidate + metrics materialization | `domain.mapping.*`, `repo.device_mapping_candidate.*`, `repo.metrics.*` | `replace_with_service` | `device-ingestion-service` + `reference-api-service` | Split between ingest write-path and mapping/admin API | 2026-04-22 |
| Reference/mapping admin HTTP API in Node-RED | `api_*`, `domain.api.*`, `repo.deviceReference*` | `replace_with_service` | `reference-api-service` | Move all reference CRUD/list/link/mapping endpoints to `reference-api-service` only | 2026-04-22 |
| Dashboard SQL aggregation and formatting in Node-RED | `domain.dashboard.*`, `repo.dashboard.*`, `fn_q_*`, `fn_fmt_*` | `replace_with_service` | `operator-ui` + service owners | Rebuild read models via service APIs and/or Grafana queries; remove Node-RED dashboard logic | 2026-04-30 |
| Scenario evaluation + command routing in Node-RED | names containing `scenario` and `Route scenario actions` | `replace_with_service` | `automation-scenario-service` + `channel-policy-router` | Keep orchestration in Camunda/Python services; keep channel decision in `channel-policy-router` | 2026-04-18 |
| Temporary bridge shim for legacy topic/API compatibility | `stack/nodered/data/flows.json` runtime wiring | `temporary_bridge` | `platform-foundation` | Keep bridge-only behavior behind explicit allowlist, then remove | 2026-05-15 |

### Immediate retirements

`retire_now` candidates (once parity checks pass):
- Node-RED HTTP endpoints that duplicate `reference-api-service` routes.
- Node-RED dashboard query functions once operator UI/Grafana pages use service-owned read paths.

### Exit rule for temporary bridge

Temporary bridge can stay only if all conditions are true:
1. No domain rule execution inside Node-RED function nodes.
2. No direct SQL write from Node-RED into core tables.
3. Explicit owner and end date recorded.

If any condition fails, classification is escalated from `temporary_bridge` to blocked release item.

## 4. Hardening Tracks Open In Wave 6

1. Keycloak production-grade verification profile:
- issuer/audience enforced per environment
- key rotation operational runbook

2. Secret management completion:
- Vault wiring per service bootstrap path
- remove fallback plaintext bootstrap assumptions

3. Operational readiness:
- service runbooks (incident, rollback, recovery)
- SLO dashboards and alerting for ingestion/API/command paths
4. Container image pipeline readiness:
- baseline GHCR image publish workflows active for all deployable services
- images/tag artifacts pullable by deployment credentials
- deferred hardening tracked as explicit TODOs

## 5. Execution Backlog

Wave 6 implementation order and dependencies are tracked in:
- `docs/wave-6-execution-backlog.md`

## 6. Exit Conditions For Wave 6

1. No critical path depends on Node-RED runtime state.
2. Remaining Node-RED role is explicitly bridge-only or fully retired.
3. Runbooks and SLO/alert dashboards are active and validated.
4. Baseline GHCR image pipelines produce pullable service images for deployment manifests.
5. Post-baseline image hardening tasks remain tracked with explicit TODO ownership.
