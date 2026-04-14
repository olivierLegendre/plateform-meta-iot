# Architecture Context Snapshot

## Core Principle
Platform-level governance remains central; partner/system edge handles local real-time control.

## System Roles
1. `device-ingestion-service`: ingest and normalize telemetry.
2. `reference-api-service`: canonical API and metadata.
3. `channel-policy-router`: command governance and routing policy.
4. `automation-scenario-service`: orchestration workflows.
5. `operator-ui`: operational UX.
6. `partner-integration-layer`: partner protocol adapters.

## Integration Direction
- Keep canonical contracts in platform services.
- Treat partner stacks as bounded integration domains.
