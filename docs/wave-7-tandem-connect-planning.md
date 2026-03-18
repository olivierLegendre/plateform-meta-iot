# Wave 7 - W7-07 Tandem Connect Planning Packet

Date: 2026-03-18
Status: Draft baseline (planning started)
Owners: Platform Architecture + Partner Integration Layer

## 1. Purpose

Define the Tandem Connect adapter execution plan before implementation starts, ensuring alignment with Wave 7 boundaries and governance rules.

## 2. Scope

In scope:
1. Tandem Connect adapter boundary and ownership confirmation.
2. Contract surface for read-path synchronization and command-intent handoff.
3. Security, tenancy, and observability requirements for implementation readiness.

Out of scope:
1. Production rollout execution.
2. Siemens-specific implementation details.
3. Any direct bypass of platform command governance services.

## 3. Boundary And Ownership

Adapter owns:
1. Tandem-specific protocol/client integration.
2. Anti-corruption mapping to canonical platform payloads.
3. Adapter-local retry and transient-failure handling.

Adapter does not own:
1. command policy/safety logic;
2. tenancy authorization policy decisions;
3. core domain workflows owned by platform services.

## 4. Candidate Contract Surface (Baseline)

Read path:
1. `POST /api/v1/partners/tandem-connect/telemetry/normalize`
2. canonical fields mirror Wave 7 Schneider baseline (`organization_id`, `site_id`, `external_asset_id`, `external_point_id`, `value`, `unit_si`, `observed_at`, `quality`, `source_metadata`).

Command intent path:
1. `POST /api/v1/partners/tandem-connect/commands/intent`
2. mandatory governance handoff to `channel-policy-router` `/api/v1/commands`.

## 5. Security And Tenancy Requirements

1. Require adapter auth token (or IAM-integrated service identity once available).
2. Require tenant scope headers and enforce payload/header scope match.
3. Reject cross-organization or cross-site mismatch requests.
4. Preserve `correlation_id` and `idempotency_key` in all command-intent flows.

## 6. Risks And Mitigations

1. Risk: model mismatch between Tandem payload semantics and canonical platform model.
- Mitigation: explicit mapping table and compatibility fixture set before runtime rollout.

2. Risk: adapter bypassing command governance under outage pressure.
- Mitigation: hard fail (`503`) on governance handoff failure; no direct command execution.

3. Risk: tenant-scope drift in partner payloads.
- Mitigation: strict scope header enforcement with reject-path tests.

4. Risk: partner-side rate limiting and transient outages.
- Mitigation: bounded retries, exponential backoff, and explicit incident signaling.

## 7. Acceptance Criteria For W7-07 Closure

1. Planning packet approved with explicit scope, risks, and acceptance criteria.
2. Contract surface and ownership boundaries are linked in Wave 7 checkpoint/backlog docs.
3. Tandem implementation entry conditions are clear enough to start W7 execution item after Schneider closure gates.

## 8. Rollback Rule

If contract or boundary ambiguity appears during implementation planning:
1. pause Tandem implementation start;
2. revise this planning packet and re-approve;
3. continue only after updated sign-off.

## 9. Dependencies

1. `docs/wave-7-execution-backlog.md` (`W7-07`)
2. `docs/wave-7-kickoff-checkpoint.md`
3. `docs/wave-7-schneider-bacnet-contract.md` (reference baseline pattern)
