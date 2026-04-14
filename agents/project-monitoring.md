# Project Monitoring — Agent Instructions

## Purpose

Define how to structure and maintain ongoing execution tracking across the project.
This file governs *delivery follow-up*, not architecture/spec decisions.

## Authority Model

1. `docs/specs/` is authoritative for target architecture, policy, and required behavior.
2. `docs/project-monitoring/` is authoritative for execution status, blockers, evidence, and step-by-step follow-up.
3. `docs/reports/` is informative only (research, briefings, communication artifacts).

If there is a mismatch:

1. Update `docs/project-monitoring/` first with runtime facts.
2. Update `docs/specs/` only if the target contract itself changed.

## Required Structure

Use this split for ongoing work tracking:

1. `docs/project-monitoring/overview/`
- Program-level tracking and cross-service status.
- Primary tracker: `service-readiness-tracker.md`.

2. `docs/project-monitoring/services/<service-name>/`
- Service-specific follow-up.
- Current stage, open tasks, owner, target date, verification commands, evidence pointers.

3. `docs/project-monitoring/waves/`
- Wave kickoff, execution backlog, closure sign-off, and wave evidence artifacts.

## Follow-Up Rules

1. Every planned step in specs must be traceable to concrete follow-up entries in `docs/project-monitoring/`.
2. Every readiness status claim must be backed by evidence (report path, command, or artifact).
3. If a task is blocked, record blocker cause, owner, and next action.
4. Keep service-level tracking centralized here; avoid scattering planning/checklist authority in service repos.

## Service Repo Boundary

Service repos may keep:

1. executable scripts,
2. local operational runbooks strictly tied to running that service.

But service repos must not become the authoritative source for cross-service execution status.

## Editing Policy

1. Prefer small, auditable updates.
2. Keep links valid when moving files.
3. Keep dates and status fields current when touched.
4. Preserve clear distinction between:
- normative requirements (`docs/specs/`),
- execution state (`docs/project-monitoring/`),
- communication outputs (`docs/reports/`).
