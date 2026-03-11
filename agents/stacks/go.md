# Go — Stack Pack

> Extends [agents.md](../../agents.md). Apply when the project language is Go.

---

## Runtime & Tooling

- Pin a supported Go version in `go.mod` and CI.
- Use standard tooling first: `go fmt`, `go test`, `go vet`.
- Keep module dependencies minimal and review indirect additions.

## Project Structure

- Prefer small packages with explicit responsibilities.
- Keep interfaces close to consumers; avoid speculative abstractions.
- Pass `context.Context` through request-scoped call chains.

## Quality Gates

- Run formatting, vetting, tests, and race checks where relevant.
- Fail CI on lints and test failures.
- Add table-driven tests for boundary-heavy logic.

## Security & Reliability

- Set server/client timeouts explicitly.
- Validate all external input and normalize errors at boundaries.
- Ensure graceful shutdown for servers and worker processes.
