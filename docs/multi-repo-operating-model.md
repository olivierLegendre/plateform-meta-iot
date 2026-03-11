# Multi-Repo Operating Model

Status: Draft v1.0  
Date: 2026-03-11

## 1. Goal

Define how to run this platform with one meta-repository and multiple independent service
repositories.

## 2. Repository Topology

## 2.1 Meta repository

Repository: `plateform-meta-iot` (this repo)

Responsibilities:

1. Architecture and product specifications.
2. Shared contracts and compatibility policy.
3. Cross-service integration test orchestration.
4. Environment bootstrap and operational runbooks.
5. Governance artifacts (ADRs, standards, release policy).

Must not contain:

1. Production business logic for service domains.
2. Service-specific persistence code.

## 2.2 Service repositories

Recommended repositories:

1. `reference-api-service` (Python)
2. `device-ingestion-service` (Python + `paho-mqtt`)
3. `automation-scenario-service` (Camunda integration layer, TypeScript)
4. `operator-ui` (Next.js)
5. `identity-access-config` (Keycloak realm/client/policy IaC)
6. `platform-foundation` (runtime infrastructure and secrets bootstrap)

Post-V1 adapters:

1. `schneider-bacnet-adapter`
2. `tandem-connect-adapter`
3. `siemens-buildingx-adapter`

## 3. Why Multi-Repo Instead Of One Monorepo

1. Independent release cadence and rollback per service.
2. Smaller blast radius for changes.
3. Clear ownership boundaries and permissions.
4. Better isolation for security-sensitive components.
5. Simpler integration with external teams or vendors.

## 4. Git Hosting Configuration (Per Repository)

Apply these defaults on your git platform:

1. Default branch: `main`.
2. Protected branch:
  - no direct push
  - require pull request
  - require status checks
  - require linear history or squash merge
3. Required checks:
  - lint
  - unit tests
  - security scan
  - contract compatibility checks (where applicable)
4. Tag pattern:
  - `vMAJOR.MINOR.PATCH`
5. CODEOWNERS enabled.
6. Signed commits or verified commits (recommended).

## 5. Cross-Repo Governance

## 5.1 Contracts

1. API and event contracts are versioned in the owning service repo.
2. Meta repo tracks accepted versions in a compatibility matrix.
3. Breaking change process:
  - publish migration guide
  - deprecation overlap 90 days
  - `410 Gone` after overlap

## 5.2 CI orchestration

1. Each service repo has its own CI pipeline.
2. Meta repo has integration pipeline that:
  - checks pinned service versions/branches
  - runs end-to-end scenarios
  - validates compatibility matrix

## 5.3 Change policy

1. Service behavior change:
  - service repo PR
  - if contract impact, also update meta repo docs/matrix
2. Cross-cutting architecture change:
  - ADR in meta repo
  - referenced by service PRs

## 6. Local Development Modes

Recommended modes:

1. Single-service mode:
  - run one service locally
  - use shared remote/dev dependencies
2. Integration mode:
  - launch selected services via compose in meta repo
3. Full-system mode:
  - launch all required V1 services and test suite

## 7. Suggested Directory Layout On Developer Machine

Example local parent directory:

```text
~/work/platform/
  plateform-meta-iot/
  reference-api-service/
  device-ingestion-service/
  automation-scenario-service/
  operator-ui/
  identity-access-config/
  platform-foundation/
```

## 8. How To Start

1. Keep this repo as architecture and integration control plane.
2. Create each service as an independent git repository.
3. Register the repositories in `repos/repos.manifest.yaml`.
4. Use `scripts/bootstrap_local_repos.sh` to initialize local repositories quickly.
5. Start with `reference-api-service` and `device-ingestion-service`.

## 9. Context Window Note

Storing specs in `docs/` does not consume runtime context by itself. Context is consumed only when
files are opened or pasted in a session.

