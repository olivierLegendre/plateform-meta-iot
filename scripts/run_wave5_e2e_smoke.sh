#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BASE="$(cd "$ROOT/.." && pwd)"

AUTOMATION_SRC="$BASE/automation-scenario-service/src"
CHANNEL_SRC="$BASE/channel-policy-router/src"
PYTHON_BIN="${PYTHON_BIN:-$BASE/channel-policy-router/.venv/bin/python}"

if [[ ! -d "$AUTOMATION_SRC" || ! -d "$CHANNEL_SRC" ]]; then
  echo "Missing service src directories" >&2
  exit 1
fi

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "Python runtime not found: $PYTHON_BIN" >&2
  exit 1
fi

PYTHONPATH="$AUTOMATION_SRC:$CHANNEL_SRC:${PYTHONPATH:-}" "$PYTHON_BIN" - <<'PY'
import os
from datetime import UTC, datetime, timedelta

import jwt
from fastapi.testclient import TestClient

JWT_SECRET = "dev-wave6-change-me-32-byte-minimum-key"
os.environ.setdefault("AUTOMATION_SCENARIO_AUTH_JWT_SECRET", JWT_SECRET)
os.environ.setdefault("CHANNEL_POLICY_ROUTER_AUTH_JWT_SECRET", JWT_SECRET)

from automation_scenario_service.main import create_app as create_automation_app
from channel_policy_router.main import create_app as create_channel_app


def jwt_for_roles(*roles: str) -> str:
    payload = {
        "realm_access": {"roles": list(roles)},
        "exp": datetime.now(tz=UTC) + timedelta(minutes=15),
    }
    return str(jwt.encode(payload, JWT_SECRET, algorithm="HS256"))


automation = TestClient(create_automation_app())
channel = TestClient(create_channel_app())

submit = channel.post(
    "/api/v1/commands",
    json={
        "organization_id": "org-1",
        "site_id": "site-1",
        "point_id": "point-1",
        "command_class": "interactive_control",
        "payload": {"target": 20},
        "idempotency_key": "idem-wave5",
        "correlation_id": "corr-wave5",
    },
)
assert submit.status_code == 202, submit.text
command_id = submit.json()["command"]["command_id"]

dispatch = channel.post("/api/v1/dispatch-next", json={"site_id": "site-1", "point_id": "point-1"})
assert dispatch.status_code == 200, dispatch.text

reconcile = channel.post(f"/api/v1/commands/{command_id}/reconcile", json={"observed_match": False})
assert reconcile.status_code == 200, reconcile.text
assert reconcile.json()["status"] == "failed"

service_token = jwt_for_roles("service_automation")
approver_token = jwt_for_roles("approver")
admin_token = jwt_for_roles("org_admin")

started = automation.post(
    "/api/v1/workflows/runs",
    json={
        "scenario_key": "safety-incident-triage",
        "organization_id": "org-1",
        "site_id": "site-1",
        "command_id": command_id,
        "command_lineage_root_id": command_id,
    },
    headers={"Authorization": f"Bearer {service_token}"},
)
assert started.status_code == 200, started.text
run_id = started.json()["run_id"]

approved = automation.post(
    f"/api/v1/workflows/runs/{run_id}/tasks/manual_approval/complete",
    json={"actor_user_id": "ops-user", "decision": "approved", "comment": "approved from e2e"},
    headers={"Authorization": f"Bearer {approver_token}"},
)
assert approved.status_code == 200, approved.text
assert approved.json()["outcome"] == "approved"

reissued = channel.post(
    f"/api/v1/commands/{command_id}/reissue",
    json={"actor_role": "org_admin", "reason": "workflow approved reissue"},
    headers={"Authorization": f"Bearer {admin_token}"},
)
assert reissued.status_code == 202, reissued.text
assert reissued.json()["command"]["parent_command_id"] == command_id

print("Wave 5 e2e smoke: PASS")
PY
