# Wave 6 Closure Sign-off Record

Date: 2026-03-18
Status: closed
Scope: final governance evidence for Wave 6 closure decision.

## 0. Current Decision Snapshot

- Topology gate rerun (2026-03-18): `PASS`
- Readiness rerun (2026-03-18, with `--manifest-set`): `READY_FOR_W6_10_CLOSURE`
- Active blocker: none (technical gates green)

## 1. Required Evidence Bundle

All items must be present before setting status to `closed`.

1. W6-10 topology release gate report is `PASS`.
- Artifact: `platform-foundation/nodered/reports/w6_topology_release_gate_report.json`
2. W6 retirement readiness report decision is `READY_FOR_W6_10_CLOSURE`.
- Artifact: `platform-foundation/nodered/reports/w6_retirement_readiness_report.json`
3. Production-scaffold manifests reference canonical images with immutable tags.
- Artifacts:
  - `platform-foundation/deploy/production/compose/reference-api.compose.yaml`
  - `platform-foundation/deploy/production/compose/device-ingestion.compose.yaml`
  - `platform-foundation/deploy/production/compose/channel-policy-router.compose.yaml`
  - `platform-foundation/deploy/production/compose/vault-secrets-runtime.compose.yaml`
4. Baseline service image publish workflows exist across target repos and include deferred hardening TODOs.
- Artifacts:
  - `reference-api-service/.github/workflows/image-publish.yml`
  - `device-ingestion-service/.github/workflows/image-publish.yml`
  - `channel-policy-router/.github/workflows/image-publish.yml`
  - `automation-scenario-service/.github/workflows/image-publish.yml`
  - `operator-ui/.github/workflows/image-publish.yml`
5. Runtime credential pullability confirmation is recorded (manual evidence or CI artifact links).

## 2. Verification Commands

Use these commands to regenerate closure evidence.

```bash
# Topology gate
cd /home/olivier/work/iot_services/platform-foundation
./nodered/scripts/run_w6_topology_release_gate.sh

# Retirement readiness decision
python3 nodered/scripts/evaluate_w6_retirement_readiness.py \
  --managed nodered/reports/w6_topology_release_gate_report.json \
  --legacy nodered/reports/poc_topology_retirement_gap_report.json \
  --manifest-set nodered/policy/w6_topology_release_gate.manifests.txt \
  --out nodered/reports/w6_retirement_readiness_report.json
```

Optional pullability check examples (execute where registry credentials are available):

```bash
docker manifest inspect ghcr.io/olivierlegendre/reference-api-service:v0.1.0 >/dev/null
docker manifest inspect ghcr.io/olivierlegendre/device-ingestion-service:v0.1.0 >/dev/null
docker manifest inspect ghcr.io/olivierlegendre/channel-policy-router:v0.1.0 >/dev/null
docker manifest inspect ghcr.io/olivierlegendre/automation-scenario-service:v0.1.0 >/dev/null
docker manifest inspect ghcr.io/olivierlegendre/operator-ui:v0.1.0 >/dev/null
```

## 3. Owner Sign-off

| Role | Owner | Decision | Date | Evidence link/note |
| --- | --- | --- | --- | --- |
| Platform architecture | olivier | approved | 2026-03-18 | W6 topology gate PASS + readiness READY_FOR_W6_10_CLOSURE |
| Platform foundation operations | olivier | approved | 2026-03-18 | Production manifest set confirmed in release gate |
| Service owners collective | olivier | approved | 2026-03-18 | GHCR images confirmed present in GitHub Packages |

Final closure decision:
- Wave 6 status: `Closed`
- Approved by: `olivier`
- Approval date: 2026-03-18
- Notes: Technical and governance closure evidence recorded; post-baseline hardening remains tracked in `docs/container-image-tagging-policy.md`.
