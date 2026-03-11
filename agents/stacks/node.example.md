# Node.js / TypeScript — Stack Pack

> Extends [agents.md](../../agents.md). Apply when the project runtime is Node.js and/or TypeScript.

---

## Runtime & Tooling

- Use LTS Node.js versions unless the project explicitly requires newer.
- Prefer TypeScript strict mode for new code.
- Use a single package manager consistently (`npm`, `pnpm`, or `yarn`).

## Project Structure

- Keep transport/framework code at the edges; isolate domain logic.
- Use path aliases sparingly and keep import graphs acyclic.
- Centralize config parsing and validate env vars at startup.

## Quality Gates

- Run `lint`, `typecheck`, and tests in CI.
- Treat TypeScript errors as merge blockers.
- Avoid `any`; when unavoidable, confine and document it.

## Security & Reliability

- Use parameterized DB queries and schema validation at boundaries.
- Add timeouts/retries/circuit-breaking for outbound HTTP calls.
- Handle process signals for graceful shutdown in services.
