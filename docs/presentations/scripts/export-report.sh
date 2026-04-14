#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/../../.." && pwd)"
EXPORT_DIR="$ROOT_DIR/docs/presentations/exports"
CSS_PATH="$ROOT_DIR/docs/presentations/ramery-report.css"
FOOTER_HTML="$ROOT_DIR/docs/presentations/ramery-footer.html"
REF_DOCX="$ROOT_DIR/docs/presentations/templates/ramery-reference.docx"
BLOC_FILTER="$ROOT_DIR/docs/presentations/scripts/bloc-style.lua"
BUILD_REF_SCRIPT="$ROOT_DIR/docs/presentations/scripts/build-ramery-reference-docx.sh"

usage() {
  cat <<USAGE
Usage: $(basename "$0") <source.md> [formats]
  formats: html,docx,pdf (comma-separated), default: html,docx,pdf
Example:
  $(basename "$0") docs/reports/autodesk-partenaire.md
  $(basename "$0") docs/reports/integration-partenaires-corrige.md html,pdf
USAGE
}

if [[ $# -lt 1 || $# -gt 2 ]]; then
  usage
  exit 1
fi

SRC="$1"
FORMATS="${2:-html,docx,pdf}"

if [[ "$SRC" != /* ]]; then
  SRC="$ROOT_DIR/$SRC"
fi

if [[ ! -f "$SRC" ]]; then
  echo "Source not found: $SRC" >&2
  exit 1
fi

mkdir -p "$EXPORT_DIR"

# Heading sanity check: numbered n.m headings should be level-3 (###), not level-2.
if rg -n '^## [0-9]+\.[0-9]+\b' "$SRC" >/dev/null; then
  echo "ERROR: heading hierarchy check failed in $SRC" >&2
  echo "Found subsection headings (n.m) at level ##. Use ### for n.m subsections." >&2
  exit 2
fi

if [[ ! -f "$REF_DOCX" ]]; then
  "$BUILD_REF_SCRIPT"
fi

embed_flag="--self-contained"
if pandoc --help 2>/dev/null | rg -q -- "--embed-resources"; then
  embed_flag="--embed-resources"
fi

base_name="$(basename "$SRC" .md | tr '[:upper:]' '[:lower:]' | tr ' ' '-')"
prefix="$EXPORT_DIR/${base_name}"
html_out="$prefix.html"
docx_out="$prefix.docx"
pdf_out="$prefix.pdf"

IFS=',' read -r -a format_list <<< "$FORMATS"

need_html=0
need_docx=0
need_pdf=0
for f in "${format_list[@]}"; do
  case "${f,,}" in
    html) need_html=1 ;;
    docx) need_docx=1 ;;
    pdf) need_pdf=1 ;;
    *) echo "Unknown format: $f" >&2; exit 1 ;;
  esac
done

if [[ $need_html -eq 1 || $need_pdf -eq 1 ]]; then
  pandoc \
    --from markdown+autolink_bare_uris \
    --to html5 \
    --standalone \
    "$embed_flag" \
    --resource-path "$ROOT_DIR:$ROOT_DIR/docs/presentations:$ROOT_DIR/docs/presentations/assets" \
    --css "$CSS_PATH" \
    --lua-filter "$BLOC_FILTER" \
    "$SRC" \
    -o "$html_out"
fi

if [[ $need_docx -eq 1 ]]; then
  pandoc \
    --from markdown+autolink_bare_uris \
    --to docx \
    --reference-doc "$REF_DOCX" \
    --lua-filter "$BLOC_FILTER" \
    "$SRC" \
    -o "$docx_out"
fi

if [[ $need_pdf -eq 1 ]]; then
  wkhtmltopdf \
    --enable-local-file-access \
    --encoding utf-8 \
    --margin-top 20mm \
    --margin-right 20mm \
    --margin-bottom 20mm \
    --margin-left 20mm \
    --footer-html "$FOOTER_HTML" \
    --footer-spacing 6 \
    "$html_out" \
    "$pdf_out"
fi

echo "Generated:"
[[ $need_html -eq 1 ]] && echo "- $html_out"
[[ $need_docx -eq 1 ]] && echo "- $docx_out"
[[ $need_pdf -eq 1 ]] && echo "- $pdf_out"
