# DevOps / CI/CD — Agent Instructions

> Extends [agents.md](../agents.md). Apply when designing pipelines, infrastructure, and deployment workflows.

---

## CI

- Run CI on every push and pull request.
- Keep PR pipeline duration short.
- Fail fast through ordered stages.
- Cache dependencies to reduce cycle time.
- Store secrets in CI secret stores only.
- Pin third-party actions to commit SHAs.

## CD

- Use short-lived branches or trunk-based flow.
- Auto-deploy main to staging.
- Require explicit approval for production deploys.
- Prefer canary or blue/green rollouts.
- Auto-rollback on failed post-deploy health checks.
- Tag production releases with semantic versions.

## IaC and Containers

- Manage infrastructure only through code.
- Review plan/preview before apply.
- Use remote state with locking.
- Tag resources with ownership and environment metadata.
- Use multi-stage images and non-root users.
- Pin base images to immutable digests.
- Scan images before registry push.

## Kubernetes and Secrets

- Set resource requests and limits.
- Configure readiness and liveness probes.
- Store config in `ConfigMap` and secrets in `Secret` or external managers.
- Restrict east-west traffic with network policies.
- Isolate environments with namespaces.
- Rotate credentials and prefer short-lived identities.

## Monitoring and Incident Response

- Monitor uptime, error rates, latency, and saturation.
- Attach runbooks to production alerts.
- Maintain on-call ownership and escalation paths.
- Write postmortems for significant incidents.
- Track and close incident action items.

## Environment Parity

- Keep dev, staging, and prod as close as possible.
- Use feature flags to decouple release from deploy.
- Seed staging with anonymized production-like data.
