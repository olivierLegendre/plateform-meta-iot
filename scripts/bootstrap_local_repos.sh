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
  cat > "$repo_dir/README.md" <<EOT
# ${repo_name}

Repository bootstrapped from \`plateform-meta-iot/scripts/bootstrap_local_repos.sh\`.

## Next Steps

1. Add remote origin.
2. Configure branch protection and required checks.
3. Add service-specific CI and code scaffolding.
EOT

  cat > "$repo_dir/.gitignore" <<'EOT'
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
EOT
}

create_python_setup_script() {
  local repo_dir="$1"
  mkdir -p "$repo_dir/scripts"
  cat > "$repo_dir/scripts/setup_dev.sh" <<'EOT'
#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_DIR"

PYTHON_BIN="${PYTHON_BIN:-python3}"
VENV_DIR="${VENV_DIR:-.venv}"

if ! command -v "$PYTHON_BIN" >/dev/null 2>&1; then
  echo "Error: '$PYTHON_BIN' is not available in PATH." >&2
  exit 1
fi

TARGET_VERSION="$($PYTHON_BIN -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")')"

if [[ -x "$VENV_DIR/bin/python" ]]; then
  CURRENT_VERSION="$($VENV_DIR/bin/python -c 'import sys; print(f"{sys.version_info.major}.{sys.version_info.minor}")' || true)"
  if [[ "$CURRENT_VERSION" != "$TARGET_VERSION" ]]; then
    echo "Existing venv uses Python $CURRENT_VERSION, expected $TARGET_VERSION. Recreating..."
    rm -rf "$VENV_DIR"
  fi
fi

"$PYTHON_BIN" -m venv "$VENV_DIR"
# shellcheck disable=SC1091
source "$VENV_DIR/bin/activate"
python -m pip install --upgrade pip

if [[ -f "pyproject.toml" ]]; then
  python -m pip install -e '.[dev]'
elif [[ -f "requirements-dev.txt" ]]; then
  python -m pip install -r requirements-dev.txt
elif [[ -f "requirements.txt" ]]; then
  python -m pip install -r requirements.txt
else
  echo "No dependency manifest found (pyproject.toml / requirements*.txt)."
fi

echo "Environment ready. Activate with: source $VENV_DIR/bin/activate"
EOT
  chmod +x "$repo_dir/scripts/setup_dev.sh"
}

create_type_hint() {
  local repo_dir="$1"
  local repo_type="$2"
  case "$repo_type" in
    python)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOT'
python
EOT
      ;;
    node)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOT'
node
EOT
      ;;
    config)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOT'
config
EOT
      ;;
    infra)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOT'
infra
EOT
      ;;
    *)
      cat > "$repo_dir/SERVICE_TYPE.txt" <<'EOT'
unknown
EOT
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

  if [[ "$repo_type" == "python" ]]; then
    create_python_setup_script "$repo_dir"
  fi

  (
    cd "$repo_dir"
    git init -b main >/dev/null
    if [[ "$repo_type" == "python" ]]; then
      git add README.md .gitignore SERVICE_TYPE.txt scripts/setup_dev.sh
    else
      git add README.md .gitignore SERVICE_TYPE.txt
    fi
    git commit -m "chore: bootstrap repository skeleton" >/dev/null || true
  )
  log "Bootstrapped: $repo_dir ($repo_type)"
done

log
log "Done. Repositories created under: $BASE_DIR"
log "Next: add remotes and push each repository to your git hosting platform."
