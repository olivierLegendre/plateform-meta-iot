# Session Bootstrap

Load this file first for every orchestrated session.

## Scope
- Control-plane repo: `plateform-meta-iot`
- Mission: coordinate multi-repo delivery while preserving ownership boundaries.

## Mandatory Inputs
1. `ai/agents.yaml`
2. `ai/tasks/active-wave.md`
3. `ai/context/architecture.md`
4. `ai/context/contracts.md`

## Operating Rules
1. Orchestrator only edits `plateform-meta-iot` unless explicitly requested.
2. Subproject work must be delegated by ownership in `agents.yaml`.
3. Any cross-repo change requires explicit contract note under `context/contracts.md`.
4. Decisions must be logged in `ai/decisions/` with date and rationale.

## Completion Definition
1. Task status updated in `tasks/active-wave.md`.
2. Evidence links added (tests, docs, diffs).
3. Decision impacts captured in latest decision log.
