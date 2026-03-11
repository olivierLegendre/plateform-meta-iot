# Security — Agent Instructions

> Extends [agents.md](../agents.md). Apply when handling auth, authorization, sensitive data, or external communication.

---

## Input and Injection

- Validate all external input at system boundaries.
- Prefer allowlists over denylists.
- Reject invalid input early.
- Sanitize untrusted content before HTML rendering.
- Use parameterized queries; never interpolate untrusted input.

## Authentication and Authorization

- Use established protocols and libraries.
- Hash passwords with `argon2`, `bcrypt`, or `scrypt`.
- Enforce rate limits and lockout controls on login.
- Enforce authorization server-side on every request.
- Apply least privilege by default.

## Secrets and Credentials

- Store secrets in a secret manager or environment variables.
- Rotate credentials regularly and on compromise.
- Prefer short-lived credentials.
- Never hard-code or commit secrets.

## Transport and Crypto

- Enforce TLS 1.2+ for all external traffic.
- Verify certificates in production.
- Set HSTS, CSP, X-Frame-Options, and X-Content-Type-Options.
- Use vetted crypto libraries only.
- Use secure random generators.
- Never reuse nonces/IVs with the same key.

## Logging and Data Protection

- Log auth events with timestamps and minimal source identifiers.
- Alert on anomalous access patterns.
- Minimize security telemetry collection.
- Retain logs only per policy and legal requirements.
- Encrypt sensitive data at rest.
- Minimize retained personal data.
- Anonymize non-production datasets.

## Dependency and Supply Chain

- Run dependency and image vulnerability scans in CI.
- Keep dependencies updated; review breaking/security notes.
- Prefer actively maintained packages.

## OWASP Top 10

- Validate mitigations for A01-A10 on all web-facing surfaces.
