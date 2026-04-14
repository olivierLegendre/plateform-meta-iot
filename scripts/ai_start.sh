#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "=== AI Session Start ==="
echo "Repo: $ROOT"
echo
echo "1) Bootstrap"
sed -n '1,200p' "$ROOT/ai/session-bootstrap.md"
echo
echo "2) Active Tasks"
sed -n '1,200p' "$ROOT/ai/tasks/active-wave.md"
echo
echo "3) Agent Registry"
sed -n '1,240p' "$ROOT/ai/agents.yaml"
echo
echo "=== Ready: orchestrator context loaded ==="
