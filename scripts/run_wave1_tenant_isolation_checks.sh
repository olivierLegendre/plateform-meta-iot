#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE_DIR="$(cd "$ROOT_DIR/.." && pwd)"
REPORT_PATH="${REPORT_PATH:-$ROOT_DIR/docs/wave-1-tenant-isolation-report.json}"
TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

checks=(
  "reference_api::cd $WORKSPACE_DIR/reference-api-service && ./scripts/run_postgres_integration_tests.sh"
  "device_ingestion::cd $WORKSPACE_DIR/device-ingestion-service && ./scripts/run_postgres_integration_tests.sh"
  "channel_policy_router::cd $WORKSPACE_DIR/channel-policy-router && ./scripts/run_postgres_integration_tests.sh"
  "automation_scenario::cd $WORKSPACE_DIR/automation-scenario-service && source .venv/bin/activate && pytest -q tests/test_api_smoke.py::test_list_runs_is_site_scoped"
)

status="PASS"

for entry in "${checks[@]}"; do
  id="${entry%%::*}"
  cmd="${entry#*::}"
  log="$TMP_DIR/$id.log"

  if bash -lc "$cmd" >"$log" 2>&1; then
    printf '[PASS] %s\n' "$id"
    printf 'PASS' >"$TMP_DIR/$id.status"
  else
    printf '[FAIL] %s\n' "$id"
    printf 'FAIL' >"$TMP_DIR/$id.status"
    status="FAIL"
  fi
done

python3 - "$REPORT_PATH" "$TMP_DIR" "$status" <<'PY'
from __future__ import annotations

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

report_path = Path(sys.argv[1])
tmp_dir = Path(sys.argv[2])
status = sys.argv[3]

commands = {
    "reference_api": "cd /home/olivier/work/iot_services/reference-api-service && ./scripts/run_postgres_integration_tests.sh",
    "device_ingestion": "cd /home/olivier/work/iot_services/device-ingestion-service && ./scripts/run_postgres_integration_tests.sh",
    "channel_policy_router": "cd /home/olivier/work/iot_services/channel-policy-router && ./scripts/run_postgres_integration_tests.sh",
    "automation_scenario": "cd /home/olivier/work/iot_services/automation-scenario-service && source .venv/bin/activate && pytest -q tests/test_api_smoke.py::test_list_runs_is_site_scoped",
}

checks = {}
findings: list[str] = []
for check_id, cmd in commands.items():
    st = (tmp_dir / f"{check_id}.status").read_text(encoding="utf-8").strip()
    log_text = (tmp_dir / f"{check_id}.log").read_text(encoding="utf-8")
    checks[check_id] = {
        "status": st,
        "command": cmd,
        "output_tail": "\n".join(log_text.strip().splitlines()[-8:]),
    }
    if st != "PASS":
        findings.append(f"{check_id} failed")

report = {
    "status": status,
    "finding_count": len(findings),
    "findings": findings,
    "generated_at": datetime.now(timezone.utc).isoformat(),
    "checks": checks,
}

report_path.parent.mkdir(parents=True, exist_ok=True)
report_path.write_text(json.dumps(report, indent=2) + "\n", encoding="utf-8")
print(f"wrote report: {report_path}")
print(f"status: {status}")
PY

if [[ "$status" != "PASS" ]]; then
  exit 1
fi
