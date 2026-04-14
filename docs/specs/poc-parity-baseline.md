# PoC Parity Baseline

> AUTHORITATIVE: This document is part of the normative project specification and governance baseline.

Date: 2026-04-03
Owner: Platform Architecture
PoC baseline source: `/home/olivier/Public/poc`
Primary PoC references:
- `/home/olivier/Public/poc/README.md`
- `/home/olivier/Public/poc/poc_project_runbook_ubuntu_EN.md`

## 1. Purpose

Define the mandatory parity baseline between the historical PoC and V1.
This document is the normative reference for parity checks in readiness tracking.

## 2. High-level parity matrix

| Capability family (PoC) | PoC baseline expectation | V1 target equivalence | Current status (2026-04-03) | Main owner repos |
| --- | --- | --- | --- | --- |
| Multi-network ingestion | Zigbee + LoRaWAN telemetry ingestion to one MQTT backbone | Equivalent ingestion pipeline and canonical telemetry persistence | Partial | `device-ingestion-service`, `platform-foundation` |
| Device uniqueness and registry | Uniquely identified devices with registry lifecycle | Canonical device references, links, mappings, metadata lifecycle | Partial | `reference-api-service` |
| Telemetry persistence | Telemetry stored with timestamps in PostgreSQL | Equivalent persistence with tenant/site boundaries | Partial (strong baseline) | `device-ingestion-service`, `reference-api-service` |
| Operator UX for operations | Registry, latest values, historical views, manual actuation, scenario toggles | Equivalent operator outcome via API-driven UI and service orchestration | Partial / gap | `operator-ui`, `automation-scenario-service`, `channel-policy-router` |
| Deterministic automation scenarios | At least two auditable deterministic automations | Equivalent workflow and execution governance | Partial | `automation-scenario-service`, `channel-policy-router` |
| Outbound command handling | Manual actuation and downlink actions with visible outcomes | Equivalent command lifecycle, routing policy, reconciliation, and auditability | Partial (backend strong, UX pending) | `channel-policy-router`, `operator-ui` |
| Security and operations baseline | Reproducible stack operations, MQTT auth, runtime checks | Stronger baseline with IAM, Vault, runbooks, observability gates | Partial (baseline gates pass locally, production-hardening evidence remains) | `platform-foundation`, `identity-access-config`, `plateform-meta-iot` |

## 3. Detailed parity matrix

| PoC feature/evidence | PoC behavior summary | V1 equivalent component(s) | Parity status | Notes / remaining work |
| --- | --- | --- | --- | --- |
| Runbook acceptance: Zigbee + LoRaWAN onboarding and unique IDs (`poc_project_runbook_ubuntu_EN.md`) | Multi-protocol onboarding with unique identification | `device-ingestion-service`, `reference-api-service` | Partial | Protocol adapter baseline exists; production-scale validation remains required. |
| One MQTT broker backbone (`README.md`) | Unified MQTT transport for events | `platform-foundation` + ingestion service runtime wiring | Partial | Baseline exists; observability gate currently blocked by missing `yaml` module in local verification scripts. |
| Telemetry stored in PostgreSQL with timestamps (`README.md`) | Historical event persistence and audit trail | `device-ingestion-service` postgres path | Partial (strong) | Local tests pass; production load/soak evidence still pending in readiness tracker. |
| Node-RED API for device references (`README.md`) | Suggestions, create/update references, mappings, links endpoints | `reference-api-service` | Partial (strong) | Service tests pass; production release evidence still pending. |
| Dashboard pages: All Devices / Actuators / Event Sensors / Periodic Sensors / Battery (`README.md`) | Read-heavy operational dashboards and status pages | `operator-ui` + observability deep-link strategy | Gap | Current React UI covers approvals/incidents/reissue/governance; device-registry + historical telemetry dashboards remain backlog (`NW-03`, `NW-04`, `NW-05`). |
| Scenario page with deterministic toggles (`README.md`) | Scenario on/off with deterministic logic and auditable outcomes | `automation-scenario-service` + `channel-policy-router` | Partial | Workflow service tests pass; persistence durability and explicit scenario parity evidence still needed. |
| Manual actuation path (`README.md`) | User-triggered device control from UI | `operator-ui` + `channel-policy-router` + downstream endpoints | Partial | Backend command policy is strong; UI mutation hardening and full operator path parity still in backlog. |
| Deterministic mapping candidate extraction (`README.md`) | Candidate fields + mapping governance | `device-ingestion-service` + `reference-api-service` | Partial | Foundations exist, but parity evidence for end-user mapping UX is incomplete. |
| Runtime health checks and operational scripts (`README.md` + runbook) | Repeatable operational checks and restart validation | `platform-foundation`, `plateform-meta-iot` scripts | Partial | Core local release gates now pass after `.venv` runtime setup; production-hardening and archive evidence remain. |
| LoRaWAN downlink confirmation criterion (`poc_project_runbook_ubuntu_EN.md`) | Confirmed downlink success by device + observable effect | Channel/partner path (post-V1 adapters) | Gap (expected) | Partner runtime adapters are post-V1 by scope; parity for this PoC criterion must be planned and tracked explicitly before declaring full parity. |

## 4. Parity decision rules

1. `Partial` means no regression is yet proven; it does not count as parity closure.
2. Full parity closure requires runnable evidence artifacts linked in readiness tracking.
3. A `Gap` item must have a backlog line with owner, target wave/date, and acceptance test.
4. No V1 closure can be declared if a PoC acceptance-critical capability remains untracked.

## 5. Link to execution tracking

Execution and closure tracking for these parity items is maintained in:

- `docs/project-monitoring/overview/service-readiness-tracker.md`
- `docs/specs/post-wave-roadmap-backlog.md`
