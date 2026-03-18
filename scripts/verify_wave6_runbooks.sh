#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPORT_PATH="${1:-$ROOT/plateform-meta-iot/docs/wave-6-runbook-verification-report.md}"

repos=(
  reference-api-service
  device-ingestion-service
  automation-scenario-service
  channel-policy-router
  operator-ui
)

required_sections=(
  "## Scope"
  "## Incident Response"
  "## Rollback"
  "## Recovery Validation"
  "## Post-Incident"
)

status_ok=true
{
  echo "# Wave 6 Runbook Verification Report"
  echo
  echo "Date: $(date -u +%F)"
  echo
  echo "## Results"
  echo
  echo "| Repo | Runbook file | README link | Section checks | Status |"
  echo "| --- | --- | --- | --- | --- |"

  for repo in "${repos[@]}"; do
    runbook="$ROOT/$repo/docs/runbooks/incident-rollback-recovery.md"
    readme="$ROOT/$repo/README.md"

    file_ok="yes"
    readme_ok="yes"
    section_ok="yes"

    if [[ ! -f "$runbook" ]]; then
      file_ok="no"
      section_ok="no"
      status_ok=false
    fi

    if [[ ! -f "$readme" ]] || ! rg -n "docs/runbooks/incident-rollback-recovery\.md" "$readme" >/dev/null 2>&1; then
      readme_ok="no"
      status_ok=false
    fi

    if [[ -f "$runbook" ]]; then
      for section in "${required_sections[@]}"; do
        if ! rg -n "^${section}$" "$runbook" >/dev/null 2>&1; then
          section_ok="no"
          status_ok=false
        fi
      done
    fi

    row_status="PASS"
    if [[ "$file_ok" != "yes" || "$readme_ok" != "yes" || "$section_ok" != "yes" ]]; then
      row_status="FAIL"
    fi

    echo "| $repo | $file_ok | $readme_ok | $section_ok | $row_status |"
  done

  echo
  echo "## Summary"
  echo
  if [[ "$status_ok" == "true" ]]; then
    echo "- Overall: PASS"
    echo "- Baseline W6-08 runbook controls are present in all target repos."
  else
    echo "- Overall: FAIL"
    echo "- At least one runbook control is missing."
  fi

  echo
  echo "## Notes"
  echo
  echo "- This verifies structural baseline only (file/link/sections)."
  echo "- Service owner operational sign-off remains a governance step outside this script."

} > "$REPORT_PATH"

echo "wrote report: $REPORT_PATH"
if [[ "$status_ok" == "true" ]]; then
  echo "verification=PASS"
  exit 0
fi

echo "verification=FAIL"
exit 1
