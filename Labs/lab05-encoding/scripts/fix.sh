#!/usr/bin/env bash
# Usage: scripts/fix.sh <source-encoding> evidence/staff-broken.csv evidence/staff-fixed.csv
# Converts to UTF-8, CRLF -> LF, and writes a UTF-8 BOM so Excel detects UTF-8 on double-click.
set -euo pipefail
SRC_ENC="$1"; IN="$2"; OUT="$3"
{ printf '\xEF\xBB\xBF'; iconv -f "$SRC_ENC" -t UTF-8 "$IN" | sed '1s/^\xEF\xBB\xBF//; s/\r$//'; } > "$OUT"
