# Forward Wave Alignment Audit

Date: 2026-03-18
Scope: Ensure post-W6 execution remains aligned with original goal: full target-architecture rewrite with industrial standards, using PoC only as migration input.

## 1. Core Alignment Rule

PoC artifacts are behavior references and migration evidence only.
They are never accepted as target runtime architecture.

## 2. Cross-Wave Drift Risks And Guardrails

1. Drift risk: counting scaffolds/placeholders as completion.
- Guardrail: wave closure requires production-grade artifacts (real images/config/secrets paths), not placeholders.

2. Drift risk: carrying Node-RED bridge patterns into final runtime design.
- Guardrail: Node-RED outputs can validate migration but cannot be part of V1 GA critical path.

3. Drift risk: bypassing service ownership with infra shortcuts.
- Guardrail: no direct DB access from UI/ops tools; all write paths through owning services.

4. Drift risk: partner adapters influencing V1 boundaries too early.
- Guardrail: partner integration remains post-V1 and must pass ACL and contract checks before enablement.

## 3. Next-Wave Alignment Checkpoints

## 3.1 Wave 7 (Partner Integration Rollout)

Required before implementation starts:
1. Confirm V1 closure metrics are green across identity, vault, observability, and Node-RED retirement.
2. Freeze canonical API/event contracts for adapters.
3. Confirm adapter boundaries (ACL) keep core domain isolated from vendor-specific models.

Required during implementation:
1. Adapter can be disabled without impacting core flows.
2. Adapter cannot bypass IAM, audit, or command policy router.
3. Adapter rollout uses explicit feature flags and rollback path.

## 3.2 Any future wave

Mandatory entry checklist:
1. Wave objective references target architecture component ownership.
2. Acceptance criteria are measurable and production-relevant.
3. Placeholder/scaffold artifacts are marked non-closure by rule.

Mandatory exit checklist:
1. Runtime checks pass against production-grade manifests/configuration.
2. Security and observability controls are active, not stubbed.
3. Owner sign-off records include explicit go-live or non-go-live statement.

## 4. Recommended Operating Discipline

For each implementation chunk:
1. Re-anchor against `docs/meta-project-charter.md`, `docs/target-architecture-and-migration.md`, and `docs/v1-system-specification.md`.
2. Declare "target artifact" vs "temporary migration artifact" explicitly.
3. Refuse closure if any acceptance criterion depends on placeholders or migration-only components.
