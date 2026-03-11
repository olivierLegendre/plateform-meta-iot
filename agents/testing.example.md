# Testing — Agent Instructions

> Extends [agents.md](../agents.md). Apply when writing, reviewing, or refactoring tests.

---

## Test Structure

- Use Arrange-Act-Assert.
- Verify one behavior per test.
- Name tests as behavior statements.
- Group tests by unit boundary.

## Unit Tests

- Isolate the unit and mock external boundaries.
- Assert observable behavior, not implementation details.
- Keep tests independent and deterministic.
- Use factories/builders for test data.

## Integration Tests

- Use real integrations when validating boundaries.
- Reset state between tests.
- Limit scope to one service boundary.

## E2E Tests

- Cover only critical user journeys.
- Run against staging-like environments.
- Use stable selectors or accessible roles.

## Mocking

- Mock only at the unit boundary.
- Prefer dependency injection.
- Restore mocks after each test.
- Assert expected calls and arguments.

## Coverage and CI

- Treat coverage as a signal, not a goal.
- Enforce a practical minimum threshold.
- Run full test suites before merge.
- Publish test results in CI feedback.

## File Conventions

- Co-locate unit tests with source files.
- Place integration/E2E tests in `tests/` or `e2e/`.
- Exclude test files from production artifacts.
