# Container Image And Tagging Policy

Date: 2026-03-18
Owner: Platform Architecture
Registry org (temporary): `olivierlegendre`

## 1. Purpose

Define canonical container image naming and tag rules for all deployable services.
This policy applies to production manifests and release gates.

## 2. Registry and visibility

TODO (post-development migration): create GitHub organization `ramery`, migrate images from `ghcr.io/olivierlegendre/...` to `ghcr.io/ramery/...`, and update manifests/policies accordingly.

1. Registry: `ghcr.io`
2. Organization namespace (current): `olivierlegendre`
3. Visibility: private by default

## 3. Naming convention

Image repository format:

`ghcr.io/olivierlegendre/<service-name>`

Service names are kebab-case and match repository/component ownership names.

## 4. Tagging convention

Use immutable tags for deployment manifests.

Allowed immutable tags:
1. release semver: `v<MAJOR>.<MINOR>.<PATCH>` (example: `v1.0.0`)
2. commit tag: `sha-<12+ hex chars>` (example: `sha-a1b2c3d4e5f6`)

Non-immutable tags such as `latest` or branch names are forbidden in production manifests.

## 5. Canonical service map

1. `reference-api-service` -> `ghcr.io/olivierlegendre/reference-api-service`
2. `device-ingestion-service` -> `ghcr.io/olivierlegendre/device-ingestion-service`
3. `channel-policy-router` -> `ghcr.io/olivierlegendre/channel-policy-router`
4. `automation-scenario-service` -> `ghcr.io/olivierlegendre/automation-scenario-service`
5. `operator-ui` -> `ghcr.io/olivierlegendre/operator-ui`
6. `identity-access-config` helpers (if containerized) -> `ghcr.io/olivierlegendre/identity-access-config`
7. `runtime-secrets-validator` -> `ghcr.io/olivierlegendre/runtime-secrets-validator`

Official third-party runtime images may remain upstream-published (for example `hashicorp/vault`).

## 6. Release requirements

Before declaring a wave production-ready:
1. all production manifests use `ghcr.io/olivierlegendre/...` (or approved third-party images);
2. all internal service images use immutable tags;
3. image tags are published and pullable by deployment runtime credentials;
4. topology and readiness gates are green;
5. owner signoff is recorded.

## 7. Deferred Hardening TODOs (Post-Baseline)

These items are explicitly deferred and do not block baseline Wave 6 "pipeline-ready image" closure:

1. Add signed provenance/SBOM attestation workflow and verification gate.
2. Add vulnerability scanning policy gate with agreed severity thresholds.
3. Migrate publish identity to OIDC least-privilege pattern.
4. Migrate image namespace from `ghcr.io/olivierlegendre/...` to `ghcr.io/ramery/...`.
