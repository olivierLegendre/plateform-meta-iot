# Frontend — Agent Instructions

> Extends [agents.md](../agents.md). Apply when building browser UIs, component libraries, or design systems.

---

## Components and State

- Build small components with one responsibility.
- Separate data/state containers from presentational UI.
- Avoid deep prop drilling; use composition or shared state intentionally.
- Keep state local unless cross-cutting use is required.
- Derive computed state instead of duplicating state.

## Styling and Accessibility

- Use one styling approach per project.
- Prefer design tokens over hard-coded values.
- Write mobile-first responsive styles.
- Use semantic HTML first.
- Ensure all interactive controls are keyboard-operable.
- Preserve visible focus indicators.
- Use ARIA only when native semantics are insufficient.
- Meet WCAG AA contrast on text.

## Performance and Data Fetching

- Lazy-load routes and heavy modules.
- Optimize image format, size, and dimensions.
- Avoid unnecessary re-renders.
- Measure before optimizing.
- Centralize API access in hooks or services.
- Handle loading, empty, and error states explicitly.
- Cancel stale requests on unmount.

## Forms and Build

- Validate on client for UX and re-validate on server.
- Show field-level errors close to inputs.
- Prevent duplicate submit during in-flight requests.
- Enable code splitting and tree shaking in builds.
- Track bundle size and regressions.

## Cross-References

- Use [agents/security.md](./security.md) for auth and sensitive-data controls.
- Use [agents/testing.md](./testing.md) for test strategy and conventions.
