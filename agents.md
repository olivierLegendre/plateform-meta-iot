# Default Agent Instructions

## Rule Precedence

1. Follow the direct user request for the current task.
2. Follow project-local overrides in `agents/project.md`.
3. Follow this core `agents.md`.
4. Follow specialized files only when requested by scope.

When same-level rules conflict, choose the safer option.

## Agent Workflow

1. Read relevant files before editing.
2. Make the smallest reversible change that solves the task.
3. Run available checks.
4. Report changes and verification.
5. State blockers and the next action when blocked.

## Task Clarity and Challenge

- Ask clarifying questions only when ambiguity can materially change scope, design, risk, or output.
- Implement directly when requirements are clear and low-risk.
- Pause implementation until goals, constraints, and acceptance criteria are clear when ambiguity is material.
- State assumptions explicitly when proceeding without answers is required.
- Offer alternatives when multiple valid approaches exist.
- Explain tradeoffs for each alternative (speed, complexity, risk, maintainability).
- Challenge incorrect, inconsistent, or unsafe user assumptions with concrete reasons.
- Refuse unsafe actions and propose safer options.

## Code Style

- Follow existing project conventions first.
- Use 2 spaces for JS/TS/JSON/YAML and 4 spaces for Python.
- Keep lines under 120 characters.
- Remove trailing whitespace and end files with one newline.
- Prefer explicit APIs over implicit behavior.

## Naming

- Use `camelCase` for variables/functions.
- Use `PascalCase` for classes/types.
- Use `UPPER_SNAKE_CASE` for constants.
- Prefix booleans with `is`, `has`, `can`, or `should`.
- Use verb-first function names.

## Error Handling

- Never swallow errors.
- Use structured errors instead of plain strings.
- Handle async failures explicitly.
- Use guard clauses to reduce nesting.
- Return actionable error messages.

## Documentation

- Write self-documenting code first.
- Document public APIs and modules.
- Keep comments synchronized with code.
- Use `TODO(name):` and `FIXME(name):` with context.

## Security Basics

- Validate and sanitize all external input.
- Enforce authorization on the server.
- Store secrets in environment variables or a secret manager.
- Never commit secrets.

See [agents/security.md](./agents/security.md) for details.

## Testing Basics

- Add tests with code changes.
- Cover happy path, edge cases, and failures.
- Keep tests deterministic.

See [agents/testing.md](./agents/testing.md) for details.

## Dependency, Performance, and Logging

- Add minimal, maintained dependencies and keep lockfiles updated.
- Optimize only after measuring bottlenecks.
- Use structured logs and never log sensitive data.

## Large Task Execution

- Treat tasks as large when they involve multiple subsystems, unclear scope, or high risk.
- Break large tasks into small, testable chunks with clear outcomes.
- Before each chunk, present: goal, planned change, validation method.
- Request user confirmation only for medium/high-risk or irreversible chunks.
- Implement one chunk at a time.
- After each chunk, report results and request approval to continue.
- Re-plan remaining chunks if new information appears.

## Specialized Topics

- Load [agents/project.md](./agents/project.md) on every task only if it is populated with project-specific rules.
- Load [agents/english.md](./agents/english.md) on every task.
- Load [agents/backend.md](./agents/backend.md) for tasks mentioning backend APIs, services, workers, or data layers.
- Load [agents/security.md](./agents/security.md) for tasks mentioning auth, secrets, privacy, encryption, vulnerabilities, or sensitive data.
- Load [agents/testing.md](./agents/testing.md) for tasks mentioning tests, coverage, or test refactors.
- Load [agents/frontend.md](./agents/frontend.md) for tasks mentioning frontend/UI, components, styles, or accessibility.
- Load [agents/devops.md](./agents/devops.md) for tasks mentioning CI/CD, deployment, infrastructure, containers, or operations.
- Load [agents/architecture.md](./agents/architecture.md) for tasks mentioning architecture, patterns, boundaries, or design refactors. 
- Load [agents/patterns/architecture.md](./agents/patterns/architecture.md) for tasks mentioning layering, boundaries, or module decomposition.
- Load [agents/patterns/behavior.md](./agents/patterns/behavior.md) for tasks mentioning algorithm choice, state handling, or workflow orchestration.
- Load [agents/patterns/data-access.md](./agents/patterns/data-access.md) for tasks mentioning persistence, repositories, transactions, or query modeling.
- Load [agents/patterns/integration.md](./agents/patterns/integration.md) for tasks mentioning external APIs, messaging, retries, or resiliency.
- Load [agents/references/patterns.md](./agents/references/patterns.md) only when the user asks for rationale or examples.
