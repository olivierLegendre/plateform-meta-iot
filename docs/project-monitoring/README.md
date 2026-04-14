# Project Monitoring

This directory is the authoritative execution workspace for delivery tracking.

It is intentionally separate from `docs/specs/`:

- `docs/specs/` defines normative architecture, policy, and target behavior.
- `docs/project-monitoring/` tracks implementation progress, stage-by-stage execution, evidence, and blockers.

## Structure

1. `overview/`
- Cross-service tracking and global execution state.
- Master readiness tracker and operating checkpoints.

2. `services/`
- One subfolder per service.
- Service-specific stage tracking, verification commands, dependencies, and evidence pointers.

3. `waves/`
- Wave-by-wave kickoff, backlog, closure, and sign-off artifacts.

## Governance Rule

1. Specifications are authoritative for *what* must be delivered.
2. Project monitoring is authoritative for *where execution currently stands*.
3. If there is a mismatch:
- first update monitoring with runtime facts,
- then decide whether specs must change (only if target contract changed).
