# Wave 6 Drift Audit (Goal Alignment)

Date: 2026-03-18
Scope: Review Wave 6 artifacts against project goal (target architecture rewrite, industrial standards, PoC as input only).

## 1. Drift Findings

1. Readiness decision too optimistic.
- Previous state: `w6_retirement_readiness_report.json` reported `READY_FOR_W6_10_CLOSURE` while production manifests still used placeholder images.
- Risk: false closure confidence.

2. Production scaffold could be misread as deploy-ready production.
- Previous state: scaffold existed but closure narrative did not clearly enforce "not ready until real images/config".
- Risk: governance ambiguity.

3. W6 docs partially framed automation as closure-equivalent.
- Previous state: W6-10 wording could be interpreted as near-complete without hard production artifact replacement.
- Risk: drift from industrial go-live standard.

## 2. Corrections Applied

1. Strict readiness logic enforced.
- File: `platform-foundation/nodered/scripts/evaluate_w6_retirement_readiness.py`
- Change: placeholder production images now create blockers (not warnings).
- Decision rule: `NOT_READY` when blockers exist.

2. Readiness evidence regenerated.
- File: `platform-foundation/nodered/reports/w6_retirement_readiness_report.json`
- Current decision: `NOT_READY`
- Blocker: `production_manifests_contain_placeholder_images`

3. W6 checkpoint/docs aligned with strict status.
- Updated:
  - `platform-foundation/nodered/topology-retirement-check.md`
  - `platform-foundation/nodered/README.md`
  - `plateform-meta-iot/docs/wave-6-kickoff-checkpoint.md`
- Current interpretation: W6-10 is blocked from closure until real production manifests are used.

## 3. Current W6-10 State (Aligned)

- Managed topology gate: PASS.
- Legacy PoC gap signal: FAIL (expected migration signal).
- Readiness: NOT_READY.
- Closure blockers:
  1. Replace scaffold placeholder images/tags with real production artifacts.
  2. Re-run release gate and readiness report.
  3. Record owner signoff.

## 4. Alignment Rule Going Forward

Wave closure status must be derived from hard blockers, not from tooling completeness.
Scaffolds are allowed for iteration speed but never considered closure evidence for production readiness.

## 5. Resolution Update (2026-03-18)

Follow-up correction completed:
1. Added formal image/tag policy for temporary org namespace `olivierlegendre` in `docs/container-image-tagging-policy.md`.
2. Replaced placeholder scaffold images with `ghcr.io/olivierlegendre/...:v0.1.0` in production-scaffold manifests.
3. Re-ran release gate and readiness evaluation.

Current readiness evidence:
- topology gate: PASS
- readiness evaluator latest rerun (2026-03-18, with `--manifest-set`): `READY_FOR_W6_10_CLOSURE` with `blocker_count=0`, `warning_count=0`

Open governance action:
- owner sign-off and final confirmation that published artifacts are available in target runtime credentials (tracked in `docs/wave-6-closure-signoff.md`).
