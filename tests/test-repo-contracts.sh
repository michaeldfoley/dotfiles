#!/usr/bin/env bash
# Layer: static / contracts
# What:  validates structured config (JSON, GitHub workflows)
# Run:   bash tests/test-repo-contracts.sh
# Add tests here: for new structured config formats that should auto-discover files
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

pass=0 fail=0 skip=0
_pass() { pass=$((pass + 1)); echo "  PASS: $1"; }
_fail() { fail=$((fail + 1)); echo "  FAIL: $1" >&2; }
_skip() { skip=$((skip + 1)); echo "  SKIP: $1"; }

_check_json() {
  local file="$1"
  if python3 - "$file" >/dev/null 2>&1 <<'PY'
import json
import sys

with open(sys.argv[1], encoding="utf-8") as fh:
    json.load(fh)
PY
  then
    _pass "json parses: ${file#"$REPO_ROOT"/}"
  else
    _fail "json parses: ${file#"$REPO_ROOT"/}"
  fi
}

echo "=== Workflows ==="

workflow_files=()
while IFS= read -r -d '' file; do
  [[ -f "$REPO_ROOT/$file" ]] || continue
  workflow_files+=("$REPO_ROOT/$file")
done < <(git -C "$REPO_ROOT" ls-files -z -- '.github/workflows/*.yml' '.github/workflows/*.yaml')

if [[ ${#workflow_files[@]} -eq 0 ]]; then
  _skip "no workflow files discovered"
else
  _pass "workflow files discovered: ${#workflow_files[@]}"
  actionlint_bin="${ACTIONLINT:-$(command -v actionlint || true)}"
  if [[ -n "$actionlint_bin" ]]; then
    if "$actionlint_bin" -color "${workflow_files[@]}"; then
      _pass "workflow syntax: actionlint"
    else
      _fail "workflow syntax: actionlint"
    fi
  else
    _skip "workflow syntax: actionlint not installed (brew install actionlint or set ACTIONLINT=/path)"
  fi
fi

echo ""
echo "=== JSON ==="

json_files=()
while IFS= read -r -d '' file; do
  [[ -f "$REPO_ROOT/$file" ]] || continue
  json_files+=("$REPO_ROOT/$file")
done < <(git -C "$REPO_ROOT" ls-files -z -- '*.json')

if [[ ${#json_files[@]} -eq 0 ]]; then
  _skip "no json files discovered"
else
  _pass "json files discovered: ${#json_files[@]}"
  for file in "${json_files[@]}"; do
    _check_json "$file"
  done
fi

echo ""
echo "=== Summary ==="
echo "  pass: $pass  fail: $fail  skip: $skip"
(( fail == 0 )) && echo "  ALL TESTS PASS" || echo "  SOME TESTS FAILED"
exit "$fail"
