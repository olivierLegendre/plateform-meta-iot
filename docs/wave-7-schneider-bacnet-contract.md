# Wave 7 - W7-01 Schneider BACnet Contract And Boundary Freeze

Date: 2026-03-18
Status: Draft baseline (execution start)
Owners: Platform Architecture + Partner Integration Layer

## 1. Purpose

Freeze the first partner adapter contract for Schneider BACnet integration so implementation can proceed without boundary ambiguity.

This contract defines:
1. ownership and non-ownership boundaries;
2. canonical model mapping principles;
3. allowed integration APIs/events;
4. security/tenant constraints;
5. acceptance and rollback criteria.

## 2. Scope (W7-01)

In scope:
1. BACnet read-path mapping for points, equipment context, and alarms/events.
2. Controlled write-path contract for partner-triggered command requests through platform governance APIs.
3. Adapter error model and compatibility rules.

Out of scope for W7-01:
1. Full production scale/performance tuning.
2. Tandem/Siemens adapter implementation.
3. Any bypass around existing command governance services.

## 3. Boundary Freeze

Adapter component (`partner-integration-layer` / `schneider-bacnet-adapter`) owns:
1. protocol translation (BACnet objects/properties -> canonical payload);
2. vendor-specific ACL/anti-corruption translation logic;
3. adapter-local connectivity/retry concerns.

Adapter must not own:
1. command safety policy or channel fallback decisions;
2. platform tenant/IAM policy decisions;
3. cross-service business rules already owned by platform services.

## 4. Canonical Contract Mapping (Baseline)

BACnet objects/properties are translated into canonical point payloads with these required fields:
1. `organization_id`
2. `site_id`
3. `source_partner` = `schneider_bacnet`
4. `external_asset_id`
5. `external_point_id`
6. `canonical_point_type`
7. `value`
8. `unit_si`
9. `observed_at`
10. `quality`

Mapping rules:
1. Unit normalization must output SI-compatible units.
2. Vendor-specific labels remain in `source_metadata` only.
3. Canonical payloads cannot contain partner-only control semantics as first-class domain fields.

## 5. Integration Contracts

Read/ingest path:
1. Adapter publishes normalized telemetry/events to platform-owned ingestion/reference APIs.
2. No direct writes to service databases from adapter runtime.

Write/command path:
1. Adapter-originated command intents must call platform command API contracts only.
2. Command execution remains governed by `channel-policy-router` and related workflow services.
3. Safety-critical command behavior must remain API-primary/no-bypass per existing policy.

Versioning:
1. Adapter contract version starts at `v1`.
2. Breaking changes require explicit version bump and compatibility notes.

## 6. Security And Tenancy Constraints

1. Adapter requests must carry verifiable identity context (service account token).
2. `organization_id` and `site_id` scope must be explicit in every mutable operation.
3. Cross-organization data access is forbidden and must be test-verified.
4. Every write-path action must emit audit metadata (`actor`, `correlation_id`, `idempotency_key` where applicable).

## 7. Error Model (Baseline)

1. Protocol translation failure -> mapped validation error with partner/source references.
2. Tenant/auth failure -> authorization error (no data leak in response).
3. Downstream dependency unavailable -> retriable integration error with bounded retries.
4. Unsupported partner capability -> explicit `not_supported` category.

## 8. Acceptance Criteria For W7-01 Closure

1. Ownership matrix and boundary rules are approved and linked from Wave 7 kickoff/backlog docs.
2. Canonical field mapping and required metadata are documented and versioned.
3. Allowed read/write integration routes are explicit and testable.
4. Security/tenant/audit constraints are written as executable test requirements for W7-03/W7-05.

## 9. Rollback Rule

If boundary drift is detected during W7-02..W7-04 (adapter taking policy/domain ownership):
1. stop implementation merge;
2. revert to this contract baseline;
3. re-approve changed contract before continuing.

## 10. Linked Execution Items

1. `docs/wave-7-kickoff-checkpoint.md`
2. `docs/wave-7-execution-backlog.md` (`W7-01`)
3. `docs/target-architecture-and-migration.md` (Wave 7 status/plan)
