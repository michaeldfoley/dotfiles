#!/usr/bin/env bash
# Layer: regression
# What:  stable contracts for retired features and past bugs
# Run:   bash tests/test-regressions.sh
#
# When to add tests here:
#   Permanent regression tests for stable contracts (file existence, behavioral
#   logic). NOT for grep-based source pattern checks – those are TDD scaffolding
#   that should be retired once the guarded refactor lands.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

pass=0 fail=0
_pass() { pass=$((pass + 1)); echo "  PASS: $1"; }
_fail() { fail=$((fail + 1)); echo "  FAIL: $1" >&2; }

echo "=== Retired skills ==="

# /design and /proposal-template were retired in favor of /propose.
# Their directories must not reappear (would create overlapping entry points).
for retired in design proposal-template; do
  if [[ -f "$REPO_ROOT/.agents/skills/$retired/SKILL.md" ]]; then
    _fail "/$retired skill still exists (retired in favor of /propose)"
  else
    _pass "/$retired skill removed"
  fi
done

# templates/DESIGN.md was the scaffold for /design – removed with it.
if [[ -f "$REPO_ROOT/templates/DESIGN.md" ]]; then
  _fail "templates/DESIGN.md still exists (used by retired /design)"
else
  _pass "templates/DESIGN.md removed"
fi

echo ""
echo "=== Summary ==="
echo "  pass: $pass  fail: $fail"
(( fail == 0 )) && echo "  ALL TESTS PASS" || echo "  SOME TESTS FAILED"
exit "$fail"
