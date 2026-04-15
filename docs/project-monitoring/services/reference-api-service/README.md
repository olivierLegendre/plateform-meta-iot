# reference-api-service Monitoring

Purpose: track ongoing execution for the service repo at `/home/olivier/work/iot_services/reference-api-service`.

## Execution checklist

- [x] Confirm current readiness state in `docs/project-monitoring/overview/service-readiness-tracker.md`.
- [ ] Confirm scope parity versus `docs/specs/v1-system-specification.md`.
- [x] Run local quality gates and attach evidence links.
- [ ] Track blockers, owner, and target date.

## Evidence pointers

1. Local repo status and relevant reports.
2. Wave artifacts under `docs/project-monitoring/waves/`.
3. Normative specs under `docs/specs/`.
4. Local check results (2026-04-14):
- `ruff check .` PASS
- `mypy src` PASS
- `pytest -q` PASS (`10 passed, 2 skipped`)
- `./scripts/run_postgres_integration_tests.sh` PASS (`2 passed`)
5. Shared observability evidence:
- `platform-foundation/observability/prometheus/rules/wave6-critical-path-alerts.yaml`
- `platform-foundation/observability/metric-name-mapping.yaml`
- `platform-foundation/observability/reports/w1-observability-baseline-report.json` (`status=PASS`, refreshed 2026-04-14)
6. Real-environment release evidence (2026-04-14):
- `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/README.md`
- `docs/project-monitoring/services/reference-api-service/evidence/2026-04-14-real-env-release/evidence-summary.json`
