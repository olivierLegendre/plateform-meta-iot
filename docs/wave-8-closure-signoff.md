# Wave 8 Closure Sign-off Record

Date: 2026-03-18
Status: closed
Scope: final governance and production hardening evidence for Wave 8 closure.

## 0. Current Decision Snapshot

- Vulnerability gate (`W8-02`): implemented in service image workflows and enforced (`HIGH,CRITICAL` fail threshold).
- OIDC identity path (`W8-03`): implemented with keyless cosign sign/verify and `id-token: write`.
- Namespace normalization (`W8-04`): completed on `ghcr.io/olivierlegendre/...` across workflows, manifests, and policy docs.
- Readiness/pullability rerun (`W8-05`): `PASS` for `IMAGE_TAG=v0.2.0`.
- Runbook hardening (`W8-06`) and pipeline optimization baseline (`W8-07`): recorded and integrated.
- Active blocker: none.

## 1. Required Evidence Bundle

All items must be present before setting status to `closed`.

1. Wave 8 kickoff evidence records implemented scope and validation outcomes.
- Artifact: `docs/wave-8-kickoff-checkpoint.md`

2. Wave 8 execution backlog records dependency order and completion evidence.
- Artifact: `docs/wave-8-execution-backlog.md`

3. Namespace and topology readiness evaluation is `PASS`.
- Artifact: `platform-foundation/deploy/production/reports/wave8-namespace-readiness-report.json`

4. Pullability proof is `PASS` on normalized namespace.
- Artifact: `platform-foundation/deploy/production/reports/wave8-pullability-report.json`

5. Hardened image workflows are active in all target service repos.
- Artifacts:
  - `reference-api-service/.github/workflows/image-publish.yml`
  - `device-ingestion-service/.github/workflows/image-publish.yml`
  - `channel-policy-router/.github/workflows/image-publish.yml`
  - `automation-scenario-service/.github/workflows/image-publish.yml`
  - `operator-ui/.github/workflows/image-publish.yml`

## 2. Verification Commands

Use these commands to regenerate closure evidence.

```bash
cd /home/olivier/work/iot_services/platform-foundation
IMAGE_TAG=v0.2.0 ./deploy/production/scripts/run_wave8_namespace_readiness.sh
```

```bash
cd /home/olivier/work/iot_services/platform-foundation
IMAGE_TAG=v0.2.0 ./deploy/production/scripts/verify_ghcr_images_pullable.sh
```

## 3. Owner Sign-off

| Role | Owner | Decision | Date | Evidence link/note |
| --- | --- | --- | --- | --- |
| Platform architecture | olivier | approved | 2026-03-18 | Wave 8 hardening gates and migration evidence reviewed and accepted |
| Platform foundation operations | olivier | approved | 2026-03-18 | Namespace readiness and pullability verification are PASS |
| Service owners collective | olivier | approved | 2026-03-18 | Hardened publish workflows active across target repos |

Final closure decision:
- Wave 8 status: `Closed`
- Approved by: `olivier`
- Approval date: `2026-03-18`
- Notes: Wave 8 closure complete; proceed to next wave planning.
