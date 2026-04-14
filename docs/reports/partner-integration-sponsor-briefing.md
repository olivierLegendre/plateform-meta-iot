# Partner Integration Decision Briefing (From Zero)

Date: 2026-03-20
Audience: non-specialists, sponsors, project stakeholders
Purpose: explain partner integration choices for building automation and digital twin, and document the context as a stable project memory.

## 1. Baseline Context (Agreed)

Your platform already does the following:
1. Ingests IoT device telemetry.
2. Centralizes data.
3. Manages identity and access.
4. Exposes telemetry via API and MQTT.

This briefing is about adding partner capabilities on top of that baseline.

## 1.1 Working Context Updates (Decision Log)

1. Tandem context precision (recorded on 2026-03-20):
- The company is a construction firm already using Autodesk tooling to model buildings.
- Building models already exist.
- The next target step is to connect IoT devices to these buildings and link telemetry/context through Tandem/Tandem Connect.

## 2. Two Separate Functionalities Under Study

## 2.1 Automation Partners (Schneider, Siemens, potentially others)

Questions to answer:
1. What can these partners automate?
2. At what granularity (single device, floor, building, portfolio)?
3. How do we connect technically?
4. What does this imply for architecture, cost, difficulty, and risk?

## 2.2 Digital Twin Partner (Autodesk Tandem / Tandem Connect)

Questions to answer:
1. What must we provide to make Tandem work?
2. How should our platform integrate cleanly and safely?
3. What are constraints, costs, and risks?

## 3. Automation Partners: What They Are and What They Can Do

## 3.1 Schneider (EcoStruxure Building Operation / SpaceLogic ecosystem)

In practical terms, Schneider can span multiple layers:
1. Device/room layer: local control (for example room HVAC and local sequences).
2. Equipment/floor layer: AHU/FCU/chiller-loop coordination and supervisory logic.
3. Building/campus layer: central monitoring, alarms, scheduling, trend logging, optimization.

Meaning:
1. Schneider is not only a small-device controller.
2. It can be a full building automation stack depending on deployment scope.

## 3.2 Siemens (Desigo + Building X ecosystem)

Siemens should be viewed across two dimensions:
1. Building automation/control systems (controller and BMS side).
2. API-first cloud platform capabilities via Building X (operations/integration side).

Meaning:
1. Siemens can also operate from point-level control up to portfolio workflows.
2. Building X APIs are relevant when integrating cloud-operational capabilities.

## 3.3 Granularity Map (Applies to Both)

Both Schneider and Siemens can be used at:
1. Single point/actuator level (setpoint, on/off, mode).
2. Equipment level (AHU, pumps, chillers, fan coils).
3. Zone/floor level (coordinated comfort/energy control).
4. Whole-building level (schedules, alarms, optimization).
5. Multi-building portfolio level (centralized operations patterns).

## 4. How We Connect to Automation Partners

In real programs, connections are usually a mix of:
1. OT protocol integration (for example BACnet family in many deployments).
2. API-based integration (especially for cloud platform capabilities).
3. Gateway/integration servers to normalize legacy environments.
4. Event/message-based interactions for alerting and orchestration.

What you need before integration:
1. Point inventory and mapping (read/write, units, frequencies, quality).
2. Authority matrix (who can command what, where, when).
3. Safety policy (holds, overrides, fail-safe behavior).
4. Tenant/site mapping model (org/site boundaries).
5. Network and security prerequisites (segmentation, cert/key path, allowed flows).
6. Incident and rollback runbooks.

## 5. What This Means for Your Architecture

You have two valid operating modes with Schneider/Siemens:

1. Partner-as-primary-automation:
- Partner platform owns most closed-loop control.
- Your platform provides data/context and governance envelope.

2. Partner-as-targeted-domain-automation:
- Partner controls selected domains/sites only.
- Your platform remains the broader orchestrator.

Both are viable; the choice depends on governance appetite, existing contracts, and operational ownership model.

## 6. Costs, Difficulty, and Limits (Automation)

The largest effort is usually not API coding.
Main effort drivers:
1. Point and metadata quality cleanup.
2. Commissioning and mapping per site.
3. Command safety and authority governance.
4. Cybersecurity approvals and network constraints.
5. Multi-site variance and legacy heterogeneity.

Complexity trend:
1. Single-site targeted pilot: medium.
2. Multi-site mixed-vendor rollout: high.
3. Portfolio-wide with strict control governance: very high.

## 7. Digital Twin with Autodesk Tandem: What It Is

Tandem is best treated as a digital twin and lifecycle context platform.
It is typically not the primary low-latency field control loop.

Best value of Tandem:
1. Asset context and lifecycle continuity.
2. Linking operational data to physical assets and spaces.
3. Event-driven workflows and cross-system context.

## 8. What You Must Provide to Make Tandem Work

Minimum integration package:
1. Facility hierarchy (site/building/floor/space).
2. Asset model and identifiers.
3. Sensor/point-to-asset mapping.
4. Telemetry contract (timestamp, unit, quality, source).
5. Metadata governance (naming, tags, classifications).
6. Credentials/environment setup and connector configuration.
7. Event policy (which twin changes trigger which workflows).

Recommended operating pattern:
1. Keep your platform as telemetry/governance core.
2. Use Tandem as context/twin layer.
3. Keep command execution in your command governance and/or automation partner plane.

## 9. Limits, Costs, and Risks (Tandem)

Main risks:
1. Semantic mismatch between IoT points and twin model.
2. Twin drift over time (model not synchronized with building reality).
3. Overloading the twin layer with responsibilities better kept in control systems.

Main costs:
1. Data modeling and mapping governance.
2. Ongoing curation and synchronization process.
3. Cross-team ownership alignment (ops/engineering/facilities).

## 10. Decision Scenarios

You can choose one of these strategic scenarios:
1. Schneider/Siemens as full BAS control + your platform as data/governance overlay.
2. Schneider/Siemens as selective control domains + your platform orchestrates globally.
3. Tandem as digital context layer only.
4. Tandem + automation partner together, with your platform as canonical integration/governance core.

Scenario 4 is often the most scalable long-term enterprise model.

## 11. Recommended Pilot Approach

Before final architecture lock:
1. Choose one pilot building.
2. Define a bounded scope: 20-30 read points and 5-10 write points.
3. Validate three things:
- telemetry reliability,
- command authority/safety behavior,
- twin synchronization quality.
4. Use pilot evidence to decide the final operating model.

## 12. Sponsor-Critical Governance Topics

These are mandatory regardless of partner choice:

1. Semantic model strategy:
- canonical model + controlled vendor metadata,
- Brick/Haystack-style tagging layer for cross-vendor normalization.

2. Command authority model:
- explicit policy matrix for who can write what, where, and when,
- role/site/time/asset/command-class controls,
- immutable command lineage and audit trail.

3. Data quality SLA:
- staleness/freshness, missing-data ratio, timestamp drift bounds,
- per-partner quality scorecards and alerting.

4. Partner certification gate before production:
- contract tests,
- sandbox parity,
- failover drills,
- rollback rehearsal.

5. Cyber baseline alignment:
- network segmentation,
- cert/key lifecycle,
- vault-based secrets,
- auditable incident/recovery controls.

## 13. Open Questions to Resolve Before Final Design

1. Should partners own direct actuator control in production, or should all writes always pass central governance first?
2. Is rollout first single-site or multi-site?
3. Which subsystem is first priority (HVAC, lighting, mixed)?
4. For digital twin, is near-real-time streaming needed first, or context/lifecycle synchronization first?
5. Do sponsors prefer a single recommended target model or an option matrix with tradeoffs?

## 14. References

1. Schneider BMS overview:
https://www.se.com/us/en/work/products/product-launch/building-management-system/
2. Schneider EBO Enterprise Server document:
https://www.se.com/us/en/download/document/03-71021/
3. Siemens Building X overview:
https://www.siemens.com/us/en/products/buildingtechnologies/building-x.html
4. Siemens Building X API manager overview:
https://www.siemens.com/en-us/products/building-x/apis/
5. Siemens Building X developer guide:
https://developer.siemens.com/building-x-openness/dev-guide/gettingstarted.html
6. Siemens Building Operations API overview:
https://developer.siemens.com/building-x-openness/api/building-operations/overview.html
7. Autodesk Tandem Data API overview:
https://aps.autodesk.com/developer/overview/tandem-data-api
8. Autodesk Tandem webhook/events reference article:
https://aps.autodesk.com/blog/tandem-webhook-events
9. Autodesk Tandem Connect integrations page:
https://intandem.autodesk.com/integrations-tandem-connect/

## 15. Decision Log - Schneider Integration (Granularity Map)

Date: 2026-03-20
Status: working conclusion (validated with official Schneider product/service pages)

## 15.1 Full Buildings Ecosystem (Portfolio / Multi-building)

Schneider offer at this level:
1. Central BMS platform with portfolio views and control-center behavior via EcoStruxure Building Operation.
2. Cross-subsystem integration scope including HVAC, lighting, power, microgrid, EV charging, security, and fire.
3. Managed/remote service layers (Building Advisor) with module-based monitoring and operational assistance.

Typical services at this level:
1. Portfolio monitoring and dashboards.
2. Alarm and system-health supervision across sites.
3. Condition-based maintenance and value reporting.
4. Cloud-backed expert support/service-plan options.

What it means for us:
1. Schneider can act as a full enterprise building-operations stack, not only a local controller.
2. Integration can happen at supervisory and business-operations levels, not just at field-device level.

## 15.2 One-Building Ecosystem

Schneider offer at this level:
1. Option A: EcoStruxure Building Operation (EBO) as the unified building command center.
2. Option B: AS-P as the building edge automation boundary and operational owner of subsystems, executing local control while receiving platform-governed command intent.
3. Building-level visibility across device, floor, and building scopes in both options.
4. Building-level control, scheduling, alarms, trend logging, and optimization workflows, with ownership split depending on the selected option.

Typical services at this level:
1. Building-wide operations supervision.
2. Multi-subsystem coordination.
3. Building analytics and optimization loops.

What it means for us:
1. We can integrate building-by-building without requiring immediate portfolio rollout.
2. A single-building pilot can be representative for technical validation.

## 15.3 One System Controller (HVAC/AHU/FCU/Lighting)

Schneider offer at this level:
1. Plant-room controller families (for example SpaceLogic MP-C) for HVAC/mechanical-room control.
2. Automation server/controller layer (AS-P/AS-B) for edge logic, trends, alarms, and field-bus connectivity.
3. Room/system controllers that can handle lighting/blinds/temperature and occupancy-related control.

Typical services at this level:
1. System-level control loops.
2. Equipment orchestration (AHU/plant-room domain).
3. Data collection and local supervisory logic.

What it means for us:
1. Schneider can be used as a domain controller (for example HVAC first) without delegating the entire building.
2. This supports a phased integration strategy by subsystem.

## 15.4 One Device Controller (Room / Local Device)

Schneider offer at this level:
1. Room/device controllers (SpaceLogic room-controller families) for temperature, lighting, blinds, and local occupancy-driven control.
2. Local HMI/operator display options for operations/maintenance tasks.
3. Device-adjacent control and telemetry collection at room/zone granularity.

Typical services at this level:
1. Point-level sensing/control.
2. Local comfort and occupancy control logic.
3. Device-level diagnostics and local overrides (depending on deployed design).

What it means for us:
1. Schneider can be integrated at very fine granularity, down to room/device scope.
2. This is useful where only targeted local optimization is needed.

## 15.5 Overall Conclusion for Schneider

1. Schneider supports all four requested granularities: device, system, single building, and portfolio ecosystem.
2. The same vendor can be engaged in narrow scope (one subsystem/site) or full-scope BAS/BMS ownership.
3. Our integration choice is architectural and contractual, not constrained by Schneider capability alone.

Primary references used for this conclusion:
1. Schneider BMS product page:
https://www.se.com/us/en/work/products/product-launch/building-management-system/
2. Schneider Building Advisor service page:
https://www.se.com/ie/en/work/services/field-services/building-services/building-advisor/

## 15.6 Deep Dive - Schneider Full Ecosystem Portfolio Offering

For full ecosystem portfolio scope, Schneider's offer is best understood as a layered operating stack:

1. Integration and control platform layer (EcoStruxure Building Operation):
- Open and secure software integration framework designed to connect Schneider and third-party systems.
- Scope includes energy, lighting, HVAC, fire safety, security, and workplace management.
- Monitor/manage/control capability from mobile and enterprise contexts.
- Positioning from small buildings to complex multi-site enterprises.

2. Device and controller layer (Connected Products / SmartX IP):
- Field-level connected products (sensors, valves, actuators, etc.).
- SmartX IP controllers for scalable end-to-end IP topologies and data transmission from connected equipment.
- Built-in security posture and faster diagnosis intent at controller level.

3. Domain expansion modules in the same ecosystem:
- Energy Expert: embedded energy monitoring/measurement/optimization in the same interface as HVAC/lighting/fire domains.
- Security Expert: integrated role-based physical-access control and intrusion context with enterprise-wide visibility.

4. Portfolio maintenance and analytics services (Building Advisor):
- Single-tool portfolio view across buildings/systems/equipment.
- Module model: BMS Health, Asset Health, Smart Alarm, Task Manager, Value Reports.
- Service plans (Plus/Prime/Ultra) combining remote monitoring, diagnostics, preventive/condition-based maintenance, and optional onsite support.
- Explicit operating cycle: Monitor -> Maintain -> Improve with KPI/ROI tracking.

5. Operational/cyber and lifecycle posture:
- Portfolio-level architecture includes software/firmware health visibility and network/system trend analysis.
- Schneider messaging includes cybersecurity and compliance posture across the building stack.
- Lifecycle services and partner ecosystem support (EcoXpert program) are part of scale-out operations.

6. Scale and portfolio characteristics highlighted by Schneider:
- Positioned for large and multi-site enterprises.
- Engineering and commissioning acceleration claims in published solution pages.
- Up to 10x scale statement for large/multi-site support in solution messaging.

What this means for us (portfolio use case):
1. Schneider can be selected as an end-to-end portfolio operating stack, not only as a device/system vendor.
2. Integration decisions become governance decisions: where command authority sits, how data ownership is split, and which analytics/maintenance workflows stay in our platform vs Schneider service modules.
3. Strongest value appears when portfolio operations, condition-based maintenance, and cross-domain optimization are required, not only point-level control.

## 16. Decision Log - Siemens Integration (Granularity Map)

Date: 2026-03-20
Status: working conclusion (validated with Siemens product and developer pages)

## 16.1 Full Buildings Ecosystem (Portfolio / Multi-building)

Siemens offer at this level:
1. Portfolio and cross-building operations with Building X platform applications.
2. Integrated building-management backbone with Desigo CC across multiple disciplines.
3. API and digital platform model (Building X Openness) for data/operations integration.

Typical services at this level:
1. Multi-building operations management.
2. Cross-domain optimization (energy, operations, safety/security, maintenance).
3. Centralized supervision and integration of heterogeneous building subsystems.

What it means for us:
1. Siemens can operate as a full ecosystem partner, not only as a single-system controller vendor.
2. Integration can be both operational UI/workflow level (Building X) and supervisory BMS level (Desigo CC).

## 16.2 One-Building Ecosystem

Siemens offer at this level:
1. Single-building integrated management through Desigo CC.
2. Unified management of HVAC, lighting, power, fire, security, and third-party systems.
3. Open-architecture positioning for future integrations and extensions.

Typical services at this level:
1. Building-wide command/monitoring center.
2. Alarm/event handling and operator workflows.
3. Building-scale energy and comfort optimization.

What it means for us:
1. Siemens can support single-building pilots with complete operational scope.
2. We can validate integrations at building scale before portfolio rollout.

## 16.3 One System Controller (HVAC/AHU/FCU/Lighting)

Siemens offer at this level:
1. Desigo PXC controller family for freely programmable HVAC and integration control.
2. Scalable controller options from room/compact contexts to central plant and campus-level control.
3. Protocol/security capabilities including BACnet Secure Connect in newer controller lines.
4. KNX-based system integration options for lighting/shading and room comfort control.

Typical services at this level:
1. System-domain control loops.
2. Equipment orchestration and subsystem optimization.
3. Field integration and engineering workflows for subsystem deployment.

What it means for us:
1. Siemens can be used as targeted subsystem automation (HVAC-first, lighting-first, etc.).
2. This supports phased rollout by domain instead of all-at-once building takeover.

## 16.4 One Device Controller (Room / Local Device)

Siemens offer at this level:
1. Room/device-level controls through room-automation products and KNX room units.
2. Local control for HVAC, lighting, and shading at space level.
3. Local sensing/operation interfaces with room-centric automation behavior.

Typical services at this level:
1. Device/room-level comfort and local actuation.
2. Point-level telemetry and local override behaviors (depending on deployment).
3. Smart-room operation and localized control logic.

What it means for us:
1. Siemens can be integrated at fine granularity, including room/device use cases.
2. This enables selective modernization of specific floors/zones without immediate full-building conversion.

## 16.5 Overall Conclusion for Siemens

1. Siemens supports all four requested granularities: device, system, one building, and portfolio ecosystem.
2. Siemens provides both classic BMS/control stack options (Desigo family) and modern API-centric digital-platform options (Building X).
3. Our integration-model choice is strategic (scope and control authority), not limited by Siemens capability coverage.

Primary references used for this conclusion:
1. Siemens Building X overview:
https://www.siemens.com/us/en/products/buildingtechnologies/building-x.html
2. Siemens Building X developer openness guide:
https://developer.siemens.com/building-x-openness/dev-guide/gettingstarted.html
3. Siemens Building X Building Operations API overview:
https://developer.siemens.com/building-x-openness/api/building-operations/overview.html
4. Siemens Desigo CC BMS page:
https://www.siemens.com/global/en/products/buildings/automation/desigo/building-management/desigo-cc.html
5. Siemens Desigo PXC controller family page:
https://www.siemens.com/global/en/products/buildings/desigo-building-automation/desigo-pxc.html
6. Siemens KNX building control page:
https://www.siemens.com/en-us/products/desigo/knx-building-control/

## 17. Capability Boundary Matrix v2

Date: 2026-03-20
Status: working decision matrix

Architecture assumptions for this matrix:
1. The platform is the global source of truth and global authority.
2. Schneider edge components keep local real-time responsibility inside their perimeter.
3. Hybrid variants evaluated:
- `AS-P only`
- `Field controllers only` (no automation servers)
- `AS-P + field controllers`

| Capability | Full EBO | Hybrid: AS-P only | Hybrid: Field controllers only | Hybrid: Both (AS-P + Field) | Licensing / Cost / Complexity Signal |
| --- | --- | --- | --- | --- | --- |
| Identity / user / role management | Schneider-centric or federated | Platform-owned possible; local Schneider identities optional | Platform-owned possible; edge service/device identities still required | Platform-owned possible with local operational identities | Full EBO usually implies broader software/service licensing; hybrid reduces central stack dependency but increases integration work |
| Device onboarding / fleet operations | Mostly Schneider stack | Shared or platform-led; AS-P object onboarding still required | Platform-led plus direct controller commissioning burden | Shared: AS-P mediation plus field commissioning | Field-only usually drives the highest site-by-site commissioning effort |
| Telemetry collection (raw) | Schneider-native collection path | AS-P aggregates edge telemetry; platform ingests upstream | Platform integrates directly with field protocols/controllers | Field -> AS-P -> platform pipeline | Field-only raises protocol handling effort in the platform team |
| Telemetry normalization / canonical model | Mostly Schneider model | Prefer platform canonical model | Prefer platform canonical model | Prefer platform canonical model | Canonical ownership in the platform preserves cross-partner consistency |
| Data presentation / operations dashboards | Strong native BMS UX | Split by role: local Schneider ops + platform global views | Mostly platform unless local Schneider UX is added | Split by role with clearer boundaries | Duplicate dashboards increase cost unless role boundaries are explicit |
| Command governance (idempotency/safety/routing) | Mostly Schneider-internal unless custom integration | Prefer platform governance with AS-P as controlled execution layer | Prefer platform governance with direct edge command integration | Prefer platform governance with AS-P execution relay | Aligns with central authority objective |
| Local fast control loops | Strong | Strong | Strong | Strongest combined resilience | Edge ownership for fast loops is preserved in all hybrid variants |
| Scenario ownership (design and runtime handling) | Mostly Schneider workflows | Split: local technical scenarios in Schneider, cross-domain scenarios in platform | Split but more complex: controller-local + platform orchestration | Best split model: local in Schneider edge, global in platform | Requires explicit RACI and conflict rules |
| Alarm / event handling | Strong native | Shared | Shared with more custom mapping | Shared with stronger structure | Alarm-semantics reconciliation is a recurring integration cost |
| Multi-site portfolio operations | Strong out-of-box | Platform-led portfolio plus selective Schneider services | Mostly platform-led | Platform-led plus selective Schneider portfolio overlays | Full EBO best turnkey portfolio UX; hybrid best for sovereignty and flexibility |
| API exposure to third parties | Available but Schneider-model oriented | Prefer platform API as external contract | Prefer platform API as external contract | Prefer platform API as external contract | Keeps external partner contracts uniform across ecosystems |
| MQTT exposure to third parties | Not a primary native pattern | Prefer platform MQTT distribution | Prefer platform MQTT distribution | Prefer platform MQTT distribution | Keeps telemetry distribution centralized |
| Domain add-ons (energy/security/etc.) | Native fit in Schneider stack | Selectively usable | Usable with more integration stitching | Selectively usable with clearer touchpoints | Usually requires additional commercial entitlements/services |
| Advisory/service layer (for example Building Advisor) | Native operational fit | Usable as overlay for portfolio operations | Usable, but integration effort is higher | Most practical hybrid fit for service overlays | Service-plan OPEX should be evaluated against internal ops tooling |
| BACnet handling burden in platform | Lower | Medium | Highest | Medium-low | Field-only is typically most BACnet-intensive for platform integration |
| Cyber/security operations split | Schneider-heavy | Shared | Platform-heavy | Shared/balanced | Hybrid requires explicit interface hardening and cert/key lifecycle governance |

## 17.1 Control Authority Split Decisions (Mandatory Before Final Design)

1. Final command authorization authority:
- whether all mutable actions must be centrally authorized by the platform.
2. Local override policy:
- which Schneider edge components may override central intent and under what audited conditions.
3. Conflict resolution rule:
- authoritative decision path when local control logic and central intent diverge.
4. Safety-critical fallback mode:
- behavior during WAN/API outages (hold, degrade, or local autonomy by command class).
5. Scenario ownership boundary:
- local technical control scenarios vs cross-domain/business scenarios.
6. Alarm authority:
- source of truth for incident state, acknowledgment, and closure.
7. Identity trust chain:
- mapping from central identity model to edge execution identity.
8. Audit authority:
- canonical audit-record location and linkage to edge evidence.

## 17.2 Working Conclusion (Schneider Hybrid Strategy)

1. The preferred fit for the stated authority model is typically `Hybrid: AS-P + Field`, with local execution in Schneider perimeter and global governance in the platform.
2. `Field-only` remains viable but increases BACnet/protocol integration and commissioning burden in the platform team.
3. `AS-P only` can simplify edge mediation but may reduce local device-level flexibility compared to combined topology.
4. Final selection should be validated through pilot evidence on latency, commissioning effort, fault handling, and governance traceability.

## 18. Schneider Technical Integration Summary

Date: 2026-03-20
Status: working technical conclusion

1. Not all Schneider field controllers are equal in connectivity:
- some are IP-capable (for example BACnet/IP),
- others are primarily field-bus oriented (for example MS/TP environments).

2. Direct platform-to-field-controller integration is possible in some cases, but not always practical at scale.

3. A common and recommended integration pattern for this architecture is:
- local BACnet field network (controllers/devices),
- AS-P as integration/routing boundary,
- platform integration at AS-P entry point.

4. AS-P can be used as gateway/routing boundary in mixed BACnet topologies:
- BACnet/IP + BACnet MS/TP handling,
- BBMD/routing functions where needed,
- BACnet/SC support in supported models/profiles.

5. Integration responsibility split in practice:
- integrator/BMS engineering: field commissioning, protocol mapping, controller/server setup,
- network/security specialists: segmentation, routing/firewall, secure-connectivity controls,
- platform team: connector integration to approved entry points and governance controls.

6. Recommended default for hybrid operations:
- keep platform as global authority/source of truth,
- keep Schneider edge perimeter responsible for local real-time control,
- use AS-P boundary to reduce BACnet complexity exposed to platform core services.

7. Working recommendation added:
- use AS-P server as gateway/entry point to local BACnet network as primary pattern unless site-specific direct field integration is justified.

## 20. Siemens Service Offer (BMS Scope)

For this program, Siemens offer can be split into four practical layers:

1. Supervisory BMS software layer:
- Desigo CC for building-level or multi-building supervision, alarms, trends, scheduling, and operator workflows.

2. Edge automation/controller layer:
- Desigo PXC controller family for programmable HVAC/integration control, field-bus connectivity, and local automation execution.

3. Room/control device ecosystem:
- KNX-based room automation devices (sensors, actuators, room units) plus KNX interfaces/routers/gateways.

4. Digital platform/app layer (optional but strategic for portfolio):
- Building X apps and Building X APIs (subscription model), focused on portfolio operations, analytics, and digital operations use cases.

## 21. Architectural Differences: Siemens vs Schneider

The two ecosystems overlap functionally, but differ in architecture packaging:

1. Schneider common pattern:
- Automation-server-centric edge boundary (AS-P/AS-B role) used as integration and control hub,
- plus controller/device families,
- plus optional advisory/service overlays.

2. Siemens common pattern:
- Controller-centric edge family (PXC),
- supervisory aggregation through Desigo CC,
- optional Building X platform/apps for cloud portfolio capabilities.

3. Integration implication:
- Schneider often highlights AS-P as explicit single building automation boundary.
- Siemens often reaches equivalent outcomes through PXC + KNX integration + supervisory layer (Desigo CC) depending on scope.

4. Governance implication for this program:
- In both ecosystems, keep platform global governance and canonical contracts centralized.
- Use partner stack for local real-time control and site operational execution.

## 22. AS-P vs PXC (Functional and Capacity View)

| Aspect | Schneider AS-P (automation server role) | Siemens PXC (controller family role) |
| --- | --- | --- |
| Primary positioning | Edge automation server and integration boundary | Edge programmable automation controllers |
| Typical role in architecture | Single building/server boundary for BMS integration and local automation | Field/system control execution; supervisory integration usually paired with Desigo CC |
| Edge control logic | Yes | Yes |
| Trend logging and alarm supervision | Yes | Yes (automation station/controller level) |
| Field-bus/I/O integration | Yes (model dependent; serial/IP integration) | Yes (model dependent; scalable controller variants) |
| Single-point entry behavior | Commonly framed around AS-P boundary | Usually achieved by controller + supervisory integration pattern |
| Portfolio cloud/app extension | Via separate ecosystem layers | Via Building X apps/APIs (subscription-based) |

## 23. Side-by-Side Matrix (Dedicated Entry-Point Row)

Legend:
- `native`: direct and explicit primary pattern in vendor architecture framing.
- `via gateway`: achievable with protocol gateway/interface.
- `needs supervisory layer`: typically requires supervisory BMS layer for practical centralized operation.

| Capability | Schneider (AS-P/EBO path) | Siemens (PXC/Desigo path) |
| --- | --- | --- |
| Single building entry point across BACnet/KNX/Modbus | `native` for BACnet/Modbus at AS-P boundary; KNX usually `via gateway` | BACnet/KNX/Modbus convergence typically `needs supervisory layer` (Desigo CC) and/or `via gateway` for KNX bridging |
| BACnet integration | `native` | `native` |
| KNX integration into BMS operations | `via gateway` | `via gateway` (and often normalized through supervisory stack) |
| Direct cloud/API app layer for portfolio operations | available, but often separate from AS-P boundary | strongly productized through Building X apps/APIs (subscription) |

## 24. Working Conclusion For Design

1. Do not force a strict one-to-one mapping between AS-P and PXC product roles.
2. Compare integration outcomes at architecture level (single entry point, command governance, protocol mediation, ops ownership), not only by product label.
3. For this program, maintain platform global authority while using partner edge/supervisory capabilities to reduce site integration complexity.

## 25. BACnet Glossary

1. BACnet:
- Building-automation communication protocol standard used by controllers/servers/devices and software clients.

2. BACnet/IP:
- BACnet over Ethernet/IP (commonly UDP-based).

3. BACnet MS/TP:
- BACnet over RS-485 serial field bus using token passing.

4. BACnet/SC:
- BACnet Secure Connect; secured BACnet transport profile for modern IP/certificate-based security models.

5. BBMD:
- BACnet Broadcast Management Device; forwards BACnet/IP broadcast traffic across subnets for discovery/communication scenarios.

6. COV:
- Change of Value; BACnet subscription mechanism to receive updates when values change, reducing constant polling.

7. BIBBs:
- BACnet Interoperability Building Blocks; standardized capability groups that describe which BACnet functions a product supports.

8. Device Instance:
- Unique BACnet device identifier used to identify a BACnet device on the network.

9. Object / Property:
- BACnet data-model elements; devices expose objects (for example analog input/output) with properties (for example presentValue, units, status).

10. IP:
- Network address (for example `10.20.30.40`) used to reach devices on IP networks.

11. FQDN:
- Fully Qualified Domain Name (for example `as-p-site1.company.local`) used as DNS-based endpoint identity.

12. Entry point:
- Network-reachable integration boundary used by the platform to access local building-automation domains (for example AS-P, gateway, or approved controller endpoint).

