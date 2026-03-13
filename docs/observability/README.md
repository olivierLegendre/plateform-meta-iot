# Observability Artifacts

## Wave 4 dashboard

- File: `channel-policy-router-wave4-dashboard.json`
- Purpose: make Wave 4 acceptance criterion "Reconciliation SLA measurement is visible in dashboards" concrete and reproducible.

Import steps (Grafana OSS):

1. Create/verify a PostgreSQL datasource with UID `platform-postgres`.
2. Import `channel-policy-router-wave4-dashboard.json`.
3. Set `site_id` variable to your pilot site.
4. Validate that panels show data after command traffic is generated.

Notes:
- Panel queries assume `commands` and `incident_hook_events` tables from `channel-policy-router` schema.
- If your datasource UID differs, edit dashboard datasource UID before import.
