#!/usr/bin/env bash
set -euo pipefail

# Bootstraps local independent git repositories in a shared "iot_services" parent directory.
# It does not configure remote origins; that is done after repository creation
# on your git hosting platform.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
META_REPO_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PARENT_DIR="$(cd "$META_REPO_DIR/.." && pwd)"

if [[ "$(basename "$PARENT_DIR")" == "iot_services" ]]; then
  DEFAULT_BASE_DIR="$PARENT_DIR"
else
  DEFAULT_BASE_DIR="$PARENT_DIR/iot_services"
fi

BASE_DIR="${1:-$DEFAULT_BASE_DIR}"

REPOS=(
  "reference-api-service:python"
  "device-ingestion-service:python"
  "automation-scenario-service:node"
  "channel-policy-router:python"
  "operator-ui:node"
  "identity-access-config:config"
  "platform-foundation:infra"
)

log() { printf '%s\n' "$*"; }

if [[ "$(basename "$PARENT_DIR")" != "iot_services" && $# -eq 0 ]]; then
  log "Note: meta-repo is not under an iot_services parent directory."
  log "Default bootstrap target will be: $BASE_DIR"
fi

create_common_files() {
  local repo_dir="$1"
  local repo_name="$2"
  cat > "$repo_dir/README.md" <<EOF
# ${repo_name}

Repository bootstrapped from \`plateform-meta-iot/scripts/bootstrap_local_repos.sh\`.

## Next Steps

1. Add remote origin.
2. Configure branch protection and required checks.
3. Add service-specific CI and code scaffolding.
EOF

  cat > "$repo_dir/.gitignore" <<'EOF'
# Common
.DS_Store
*.log

# Python
__pycache__/
.pytest_cache/
.mypy_cache/
.venv/

# Node
node_modules/
.next/
dist/
EOF
}

create_type_hint() {
  local repo_dir="$1"
  local repo_type="$2"
  case "$repo_type" in
    python)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOF'
python
EOF
      ;;
    node)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOF'
node
EOF
      ;;
    config)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOF'
config
EOF
      ;;
    infra)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOF'
infra
EOF
      ;;
    *)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOF'
unknown
EOF
      ;;
  esac
}

for entry in "${REPOS[@]}"; do
  IFS=":" read -r repo_name repo_type <<< "$entry"
  repo_dir="$BASE_DIR/$repo_name"

  if [[ -e "$repo_dir/.git" ]]; then
    log "Skipping existing git repo: $repo_dir"
    continue
  fi
  if [[ -d "$repo_dir" ]] && [[ -n "$(ls -A "$repo_dir" 2>/dev/null || true)" ]]; then
    log "Skipping non-empty directory: $repo_dir"
    continue
  fi

  mkdir -p "$repo_dir"
  create_common_files "$repo_dir" "$repo_name"
  create_type_hint "$repo_dir" "$repo_type"

  (
    cd "$repo_dir"
    git init -b main >/dev/null
    git add README.md .gitignore SERVICE_TYPE.txt
    git commit -m "chore: bootstrap repository skeleton" >/dev/null || true
  )
  log "Bootstrapped: $repo_dir ($repo_type)"
done

log
log "Done. Repositories created under: $BASE_DIR"
log "Next: add remotes and push each repository to your git hosting platform."
