# Documentation Structure

This folder is intentionally split between three categories:

1. `docs/specs/`
- Authoritative project instructions, architecture decisions, governance rules, and operating model.
- These documents are normative and must stay clean, explicit, and updated.

2. `docs/project-monitoring/`
- Authoritative execution tracking: wave artifacts, readiness trackers, and service-by-service delivery follow-up.
- These documents track implementation state and evidence; they do not redefine architectural/spec rules.

3. `docs/reports/`
- Research outputs, sponsor briefings, generated studies, and working notes.
- These documents are informative and can evolve faster.

## Rule of interpretation

- When content conflicts, `docs/specs/` prevails.
- `docs/project-monitoring/` must align with `docs/specs/` and reflect runtime facts.
- `docs/reports/` must align with `docs/specs/` and never redefine authoritative rules.
- Wave evidence is stored under `docs/project-monitoring/waves/`.
