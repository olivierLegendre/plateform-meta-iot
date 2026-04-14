# AI Control Plane (plateform-meta-iot)

This folder is the single coordination point for multi-repo AI work.

## Goals
1. Keep architecture and governance decisions centralized.
2. Delegate implementation to per-repo agents with explicit ownership.
3. Keep traceable execution context across sessions.

## Core Files
- `agents.yaml`: agent registry and ownership map.
- `session-bootstrap.md`: default context loaded at session start.
- `prompts/`: role prompts for orchestrator and subproject agents.
- `context/`: architecture and contract references.
- `tasks/active-wave.md`: current execution backlog.
- `decisions/`: decision log snapshots.

## Standard Loop
1. Load `session-bootstrap.md`.
2. Read `tasks/active-wave.md`.
3. Delegate bounded tasks by ownership from `agents.yaml`.
4. Update decisions and task status after each milestone.
