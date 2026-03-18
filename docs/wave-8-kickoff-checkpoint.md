# Wave 8 Kickoff Checkpoint (Production Hardening And Org Migration)

Date: 2026-03-18
Status: Closed

## 1. Objective

Prepare the next wave that converts deferred post-baseline controls into mandatory production gates and completes registry/org migration.

## 2. Gating Rule

Wave 8 starts only after Wave 7 closure is fully green.

Required precondition:
1. Wave 7 status set to `completed` in `docs/target-architecture-and-migration.md`.
2. Wave 7 acceptance evidence finalized.

Start confirmation:
1. Wave 7 closure sign-off is recorded as approved.
2. Wave 8 status moved to `in_progress` in `docs/target-architecture-and-migration.md`.

## 3. Scope Summary

Wave 8 will focus on:
1. supply-chain attestation and verification enforcement;
2. vulnerability policy gate enforcement;
3. OIDC-only publish identity;
4. namespace/casing normalization and enforcement on `ghcr.io/olivierlegendre/...`;
5. post-migration manifest/readiness validation.

## 4. Inputs

Primary references:
1. `docs/container-image-tagging-policy.md`
2. `docs/wave-7-execution-backlog.md`
3. `docs/target-architecture-and-migration.md`

## 5. Backlog Reference

Wave 8 dependency-ordered work is tracked in:
- `docs/wave-8-execution-backlog.md`

## 5.1 Progress Snapshot

Implemented baseline:
1. `W8-02` vulnerability gate added to service image workflows (`Trivy`, fail on `HIGH,CRITICAL`).
2. `W8-03` OIDC keyless signing/verification path added in workflows (`id-token: write`, `cosign` keyless sign/verify).
3. `W8-04` namespace normalization applied in active workflows/manifests/docs (`ghcr.io/olivierlegendre/...`, lowercase enforcement).
4. `W8-06` runbook updates applied for hardening/migration incidents across service repos.
5. `W8-07` build-time optimization baseline applied (`buildx` cache + workflow concurrency control).

Evidence artifacts:
1. `platform-foundation/deploy/production/reports/wave8-namespace-readiness-report.json`
2. `platform-foundation/deploy/production/scripts/run_wave8_namespace_readiness.sh`
3. `platform-foundation/deploy/production/scripts/evaluate_wave8_namespace_readiness.py`
4. `platform-foundation/deploy/production/reports/wave8-pullability-report.json`

Validation result:
1. GHCR publish proof completed for `IMAGE_TAG=v0.2.0`.
2. `W8-05` full readiness rerun is `PASS` (namespace checks, topology gate, retirement decision, pullability).

## 6. Exit Conditions For Wave 8 Closure

1. Attestation/SBOM and scan gates are required and passing across target service pipelines.
2. OIDC publish identity is active and PAT publish is removed from release path.
3. Namespace normalization and pullability proofs are complete for `ghcr.io/olivierlegendre/...`.
4. Production manifest set and release gates are green post-migration.

## 7. Closure Confirmation

1. Wave 8 closure sign-off recorded in `docs/wave-8-closure-signoff.md`.
2. Status updated to closed on 2026-03-18.
