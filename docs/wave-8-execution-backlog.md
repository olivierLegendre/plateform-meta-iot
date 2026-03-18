# Wave 8 Execution Backlog (Ordered)

Date: 2026-03-18
Scope: Production hardening and registry/org migration after Wave 7.

## 1. Priority Model

- `P0`: release-blocking supply-chain/security/identity risk.
- `P1`: required for Wave 8 acceptance.
- `P2`: optimization or quality improvements after gate enforcement.

## 2. Backlog (Dependency Order)

| ID | Priority | Work item | Owner repo | Depends on | Done when |
| --- | --- | --- | --- | --- | --- |
| W8-01 | P0 | Implement provenance/SBOM attestation generation and verification gate in image pipelines | service repos + `plateform-meta-iot` policy docs | Wave 7 closure | All target image workflows emit attestations and verification passes in CI |
| W8-02 | P0 | Add vulnerability scanning gate with policy fail thresholds | service repos + `platform-foundation` release controls | W8-01 | Release pipeline blocks on configured severity violations |
| W8-03 | P0 | Migrate image publish identity to OIDC least-privilege model | service repos + GitHub org settings | W8-01 | PAT-based release publish path removed for target services |
| W8-04 | P1 | Execute namespace migration from `ghcr.io/olivierlegendre/...` to `ghcr.io/ramery/...` | service repos + `platform-foundation` + `plateform-meta-iot` docs | W8-03 | All manifests, workflows, and policy docs reference `ghcr.io/ramery/...` |
| W8-05 | P1 | Re-run pullability and topology/readiness evidence on migrated namespace | `platform-foundation` + `plateform-meta-iot` | W8-04 | Pullability checks and release gates pass against migrated manifests |
| W8-06 | P1 | Update runbooks and rollback playbooks for hardening/migration incidents | `platform-foundation` + service repos | W8-05 | Incident/rollback runbooks explicitly cover attestation, scan, and namespace rollback |
| W8-07 | P2 | Performance and build-time optimization after hardening gates | service repos | W8-02 | Pipeline latency targets documented and within agreed budget |

## 3. Verification Gates Per Item

Each item closes only if all are true:

1. CI evidence is attached for target repos.
2. Policy and runtime docs are updated in `plateform-meta-iot`.
3. Rollback path is executable and tested.
4. Security review confirms no downgrade of authz, tenant isolation, or audit coverage.

## 4. Suggested Execution Sequence

1. `W8-01` attestation/SBOM gate.
2. `W8-02` vulnerability gate.
3. `W8-03` OIDC publish identity.
4. `W8-04` namespace migration.
5. `W8-05` readiness evidence refresh.
6. `W8-06` runbook updates.
7. `W8-07` optimization follow-up.
