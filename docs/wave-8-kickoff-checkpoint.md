# Wave 8 Kickoff Checkpoint (Production Hardening And Org Migration)

Date: 2026-03-18
Status: Pending (prepared)

## 1. Objective

Prepare the next wave that converts deferred post-baseline controls into mandatory production gates and completes registry/org migration.

## 2. Gating Rule

Wave 8 does not start until Wave 7 closure is fully green.

Required precondition:
1. Wave 7 status set to `completed` in `docs/target-architecture-and-migration.md`.
2. Wave 7 acceptance evidence finalized.

## 3. Scope Summary

Wave 8 will focus on:
1. supply-chain attestation and verification enforcement;
2. vulnerability policy gate enforcement;
3. OIDC-only publish identity;
4. namespace migration from `ghcr.io/olivierlegendre/...` to `ghcr.io/ramery/...`;
5. post-migration manifest/readiness validation.

## 4. Inputs

Primary references:
1. `docs/container-image-tagging-policy.md`
2. `docs/wave-7-execution-backlog.md`
3. `docs/target-architecture-and-migration.md`

## 5. Backlog Reference

Wave 8 dependency-ordered work is tracked in:
- `docs/wave-8-execution-backlog.md`

## 6. Exit Conditions For Wave 8 Closure

1. Attestation/SBOM and scan gates are required and passing across target service pipelines.
2. OIDC publish identity is active and PAT publish is removed from release path.
3. Namespace migration to `ghcr.io/ramery/...` is complete with pullability proofs.
4. Production manifest set and release gates are green post-migration.
