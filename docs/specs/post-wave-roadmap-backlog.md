# Post-Wave Roadmap Backlog

> AUTHORITATIVE: This document is part of the normative project specification and governance baseline.


Date: 2026-03-18
Status: active
Scope: consolidated next-step backlog after Wave 1-8 closure.

## 1. Why This Exists

Wave closure docs record what was completed.  
This document records what is intentionally next, so deferred items remain visible and planned.

## 2. Priority Backlog

| ID | Priority | Item | Owner repo(s) | Status | Notes |
| --- | --- | --- | --- | --- | --- |
| NW-01 | P0 | Implement full Keycloak login/refresh/logout lifecycle in `operator-ui` | `operator-ui`, `identity-access-config` | planned | Replace temporary `localStorage.access_token` dev path with end-to-end OIDC flow. |
| NW-02 | P0 | Add route-level RBAC enforcement in UI (viewer/operator/approver/site_admin/org_admin) | `operator-ui` | planned | UI behavior must align with Keycloak roles and backend authz boundaries. |
| NW-03 | P1 | Add device management screens (reference lifecycle, mappings, links) | `operator-ui`, `reference-api-service` | planned | Device management UX was not delivered in current wave set. |
| NW-04 | P1 | Formalize telemetry display ownership and integration path | `platform-foundation`, `operator-ui` | planned | Grafana is telemetry dashboard owner; document deep-link/embed policy from `operator-ui` if needed. |
| NW-05 | P1 | Implement production-grade mutation UX and traceability timeline in UI | `operator-ui` | planned | Confirm dialogs, retries, rich error surfaces, lineage timeline. |
| NW-06 | P1 | Complete Vault production injector automation (agent/injector/CSI path) | `platform-foundation` | planned | Current baseline is functional bootstrap mode; complete production automation hardening. |
| NW-07 | P1 | Add onboarding test report template and execution log convention | `plateform-meta-iot` | planned | Standardize test-cycle reporting across service and function checks. |
| NW-08 | P2 | Establish Wave 9 kickoff package for UI/auth/product hardening slice | `plateform-meta-iot` | planned | Convert NW-01..NW-05 into dependency-ordered wave backlog. |
| NW-09 | P1 | Implement Tandem (Autodesk) runtime adapter integration track | `partner-integration-layer`, `plateform-meta-iot`, `platform-foundation` | planned | Move from planning packet to executable adapter/runtime integration with governance and evidence gates. |
| NW-10 | P1 | Implement Siemens Building X runtime adapter integration track | `partner-integration-layer`, `plateform-meta-iot`, `platform-foundation` | planned | Move from planning packet to executable adapter/runtime integration with governance and evidence gates. |
| NW-11 | P1 | Implement GDPR subject-right operations (export/delete/anonymize) | cross-service | planned | Explicitly marked out-of-V1 and post-V1 backlog in V1 system specification. |
| NW-12 | P1 | Add MFA for `approver` and `org_admin` | `identity-access-config`, `operator-ui` | planned | Explicitly marked post-V1 hardening backlog in V1 system specification. |
| NW-13 | P1 | Implement tamper-evident audit log chains | cross-service | planned | Explicitly marked post-V1 hardening backlog in V1 system specification. |
| NW-14 | P2 | Finalize pilot KPI success criteria and timeline | `plateform-meta-iot` | planned | Listed as open item in V1 system specification. |
| NW-15 | P2 | Finalize pilot rollback trigger thresholds and operator runbook details | `plateform-meta-iot` | planned | Listed as open item in V1 system specification. |
| NW-16 | P2 | Finalize production incident communications matrix per organization | `plateform-meta-iot` | planned | Listed as open item in V1 system specification. |

## 3. Governance Rule

1. No deferred item is considered done unless linked to a runnable command/test or evidence artifact.
2. Any newly deferred item must be added here before closing the corresponding wave/task.
