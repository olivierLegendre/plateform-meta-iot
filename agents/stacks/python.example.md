# Python — Stack Pack

> Extends [agents.md](../../agents.md). Apply when the project runtime is Python.

---

## Runtime & Tooling

- Target one explicit Python minor version per project.
- Use virtual environments and a lockfile-capable dependency manager.
- Format and lint consistently (`ruff`/`black` or project standard).

## Project Structure

- Keep business logic framework-agnostic where practical.
- Use type hints on public interfaces and critical internal paths.
- Validate settings/env vars at startup with a schema/model.

## Quality Gates

- Run lint, type checks (`mypy`/`pyright`), and tests in CI.
- Keep tests deterministic and isolate external dependencies.
- Prefer fixtures/factories over large static fixtures.

## Security & Reliability

- Validate and sanitize boundary inputs (API, CLI, file, env).
- Use parameterized queries/ORMs; avoid string-built SQL.
- Use timeouts for network I/O and explicit retry policies.
