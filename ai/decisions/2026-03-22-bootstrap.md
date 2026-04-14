# Decision Log - AI Control Plane Bootstrap

Date: 2026-03-22

## Decision
Create `ai/` as the orchestration control plane in `plateform-meta-iot`.

## Rationale
1. Centralize architecture/governance context.
2. Reduce cross-repo drift by explicit ownership mapping.
3. Make AI sessions repeatable with bootstrap + task state.

## Impact
1. Faster session startup.
2. Clear delegation boundaries.
3. Better traceability of decisions.
