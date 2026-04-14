# Autodesk Partner Research (Tandem + Tandem Connect)

Date: 2026-04-02  
Status: working research baseline (to be updated as we refine decisions)  
Audience: platform manager, functional stakeholders, sponsors

## 1. Executive summary

Autodesk provides two complementary offers:

1. **Autodesk Tandem**: the digital twin platform (asset context, facility model, operations context, time-series visualization/monitoring support).
2. **Autodesk Tandem Connect**: a low-code integration layer to connect external systems (BMS, CMMS, IoT hubs, MQTT, APIs, etc.) to Tandem.

For our platform strategy, the strongest fit is:

1. Keep **our platform** as the governance and canonical integration backbone.
2. Use **Tandem** as the digital twin/context layer.
3. Use **Tandem Connect** selectively where it accelerates partner/system integrations (especially when prebuilt plugins reduce delivery time).

## 2. What each service does

### 2.1 Autodesk Tandem (core digital twin)

Tandem is positioned as a data-rich digital twin platform linking BIM and operations data for monitoring and optimization.

Relevant capabilities from official sources:

1. Facility digital twin model (assets, spaces, systems, relationships).
2. Time-series stream support for sensor data.
3. Operations context and near-real-time + historical data usage.
4. API-based access to read/write asset information and custom schema properties.

### 2.2 Autodesk Tandem Connect (integration layer)

Tandem Connect is presented as vendor-agnostic, low-code, drag-and-drop integration tooling with a plugin/pipeline model.

Relevant capabilities from official sources:

1. Pre-packaged plugin library (Autodesk page currently states 46 plugins and counting).
2. Pipelines can connect cloud systems and (depending on offering/architecture) local systems.
3. Plugin categories include Stream, Gateway, Connector, Service, Mapper, Filter, Channel.
4. Concrete OT/IoT-relevant plugins include BACnet Stream, MQTT Stream/Gateway/Channel/Connector, OPC UA Stream/Subscribe, Kafka Stream, Tridium NDS Stream, Azure IoTHub Stream.

## 3. Integration options with our platform

There is not one single mandatory pattern. We can choose among several.

### 3.1 Pattern A - API-led integration (our platform to Tandem Data API)

Flow:

1. Our platform keeps ingestion/governance.
2. Our adapter/service writes/updates in Tandem via API.
3. Optional: subscribe to Tandem webhooks for event-driven workflows.

When to use:

1. We want maximum control over contracts and governance.
2. We already have strong internal integration services.
3. We want to avoid over-dependency on an additional low-code runtime.

### 3.2 Pattern B - Direct stream ingestion from sensors/gateways to Tandem

Autodesk documents direct stream ingestion options:

1. Sensor/gateway posts numeric payloads to stream ingestion endpoints.
2. Basic auth (stream secret) or OAuth can be used.
3. Minimum interval and payload constraints apply.

When to use:

1. Narrow pilot, low complexity.
2. We accept less mediation in our platform layer.

Tradeoff:

1. Fast to start.
2. Potentially weaker governance consistency if we bypass our canonical ingestion path.

### 3.3 Pattern C - Tandem Connect as integration fabric

Flow:

1. Tandem Connect pipelines pull/push from source systems.
2. Tandem Connect plugins transform/map data.
3. Data and property updates go to Tandem via Tandem plugins.

When to use:

1. We need rapid connectors to heterogeneous systems.
2. Prebuilt plugins reduce custom development effort.

Tradeoff:

1. Faster connector delivery.
2. Additional runtime/governance surface (capacity, plugins, lifecycle, operations).

### 3.4 Pattern D - Hybrid (recommended baseline for our roadmap)

Flow:

1. Our platform remains canonical for identity, tenancy, command governance, and API/MQTT contracts.
2. Tandem is the twin/context consumer and event source.
3. Tandem Connect is used where it clearly accelerates integration and does not break governance boundaries.

This pattern aligns best with our current program direction.

## 4. What Autodesk needs from us

Regardless of pattern, Autodesk-side success depends on input quality from us.

Minimum integration package:

1. Stable facility/site/building/floor/space hierarchy.
2. Asset model with durable IDs and metadata strategy.
3. Point-to-asset mapping (sensor/stream to equipment/space/system).
4. Telemetry contract (unit, timestamp, quality, retention intent).
5. Integration credentials/secrets lifecycle (rotation, least privilege).
6. Governance rules for write authority and audit lineage.

Additional for Tandem Connect:

1. Pipeline design ownership and CI/release process.
2. Plugin-level secrets and endpoint management.
3. Runtime placement decisions (cloud execution vs outpost/local execution where applicable).

## 5. What Tandem/Tandem Connect can offer functionally

For stakeholders, the value is mostly in operations visibility and cross-system context:

1. A digital twin layer linking BIM + operations + streams.
2. Faster troubleshooting via contextualized assets/spaces/systems.
3. Alert-driven workflows (via thresholds and webhook events).
4. Potential integration acceleration with prebuilt connectors and low-code pipelines.
5. Better bridge between engineering data and facility operations workflows.

## 6. Costs and licensing signals (important)

Commercial details are evolving; we should validate quotes before decisions.

French-market validation (as checked on 2026-04-02):

1. Autodesk product page includes **France** in regional options.
2. Autodesk states Tandem Covered Content can be primarily stored in the **EU** regional offering.
3. Public commercial page displays list prices in USD and notes "*includes estimated VAT*".

Public product page currently indicates:

1. Tandem: around **$3,200/year** (public page value at time of research).
2. Tandem Connect: around **$5,000/year** (public page value at time of research).
3. Free tiers exist for both Tandem and Tandem Connect.

Indicative EUR conversion (working estimate):

1. FX assumption used: **1 EUR = 1.153 USD** (market snapshot, March 2026).
2. Tandem: **~EUR 2,775/year** (indicative).
3. Tandem Connect: **~EUR 4,337/year** (indicative).

Important:

1. These EUR values are **planning estimates**, not contractual quotes.
2. Final France pricing must be confirmed through Autodesk/reseller quote (billing currency, VAT treatment, discounts, capacity add-ons).

Autodesk terms also describe:

1. Capacity-based and tiered usage logic (assets, data points, streams, plugins, brokers, messages, outpost availability depending on tier/era).
2. Tandem Connect plugin-pack and MQTT broker add-on logic in specific offering modes.
3. Time-series/history and capacity limits depending on subscription type.
4. Contract/model changes around 2026 capacity-based subscriptions.

Practical implication:

1. We must treat cost as **capacity architecture**, not only user-seat architecture.
2. Pilot sizing should explicitly estimate assets, streams/data points, plugin packs, and MQTT broker needs.

## 7. Known bottlenecks and delivery risks

Most risks are integration/governance, not UI.

1. **Semantic mapping risk**: BIM/twin schema vs IoT/BMS point semantics.
2. **Identity/authority risk**: ambiguous ownership of mutable writes.
3. **Data quality risk**: unit mismatch, timestamp drift, noisy/invalid streams.
4. **Operational risk**: pipeline sprawl and plugin lifecycle governance.
5. **Capacity/cost drift**: underestimating data points/plugins/broker usage.
6. **Latency/event assumptions**: webhook delivery is asynchronous; external orchestrations must be resilient.
7. **Security risk**: stream secrets/OAuth scopes and endpoint exposure must be controlled.

## 8. MQTT-specific implications (for our architecture)

From Tandem Connect plugin model and Autodesk terms:

1. Tandem Connect supports MQTT ingestion and publication patterns (stream/gateway/channel/connector plugin family).
2. MQTT broker capacity is a licensed/add-on dimension in relevant offering models.
3. Pipelines are cloud-authored and can be deployed according to offering capabilities (including outpost in supported tiers).

Design implication for us:

1. We can connect Tandem Connect to our MQTT ecosystem, but we must define:
   - topic governance,
   - QoS/retention behavior,
   - data normalization ownership,
   - broker/security boundaries.

## 9. Recommended pilot plan (functional level)

Suggested pilot (small but representative):

1. One building.
2. 20-30 telemetry points, 5-10 controlled mapped assets.
3. One API-based flow + one Tandem Connect pipeline flow (A/B validation).
4. One webhook-driven workflow (e.g., alert to ticket orchestration).
5. Explicit success criteria:
   - mapping quality,
   - data freshness/quality,
   - governance traceability,
   - operational effort per connector,
   - monthly capacity/cost estimate confidence.

## 10. Decision framing for stakeholders

The key decision is not "Tandem or not Tandem"; it is:

1. Where to place system-of-record authority.
2. Which integration paths to standardize (API-first vs Connect-first vs hybrid).
3. How much capacity/cost volatility we accept in exchange for integration acceleration.

Current recommendation:

1. Start with **hybrid**, keeping our platform as canonical governance layer.
2. Use Tandem for context/twin value.
3. Use Tandem Connect only where plugin-led acceleration clearly beats custom adapters.

## 11. Sources (official)

1. Autodesk Tandem overview/pricing:  
https://www.autodesk.com/products/tandem/overview
2. Tandem Connect integrations library page:  
https://intandem.autodesk.com/integrations-tandem-connect/
3. Tandem as a platform (API roadmap, push/pull positioning):  
https://intandem.autodesk.com/tandem-as-a-platform/
4. APS Tandem Data API overview:  
https://aps.autodesk.com/developer/overview/tandem-data-api
5. APS blog - Adding IoT sensors into Tandem API (ingestion options, auth, limits):  
https://aps.autodesk.com/blog/adding-iot-sensors-tandem-api
6. APS blog - Stream creation guide:  
https://aps.autodesk.com/blog/tandem-data-api-guide-stream-creation
7. APS blog - Deleting stream data (time-series operations):  
https://aps.autodesk.com/blog/tandem-api-deleting-stream-data
8. APS blog - Tandem webhook events (event types, async behavior):  
https://aps.autodesk.com/blog/tandem-webhook-events
9. Autodesk Terms of Use - Offerings (Tandem/Tandem Connect tiers, plugins, MQTT broker add-ons, outpost definitions):  
https://www.autodesk.com/company/terms-of-use/en/offering-types-and-benefits
10. Autodesk Terms of Use - subscription/capacity wording around 2026 transitions:  
https://www.autodesk.com/company/terms-of-use/en/subscription-types
11. USD/EUR market reference used for indicative conversion:  
https://www.investing.com/currencies/eur-usd
