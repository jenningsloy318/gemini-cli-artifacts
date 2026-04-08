#!/bin/bash
# Gate: Build & Test Quality Check
# Verifies code compiles and tests pass
#
# Usage: gate-build.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-build.sh <spec-dir>}"

# Find test report dynamically
TEST_REPORT=$(find "$SPEC_DIR" -maxdepth 1 -name "*-test-report.md" | head -1)

PASS=0
FAIL=0
ERRORS=""

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "true" ]; then
        PASS=$((PASS + 1))
        echo "  [PASS] ${desc}"
    else
        FAIL=$((FAIL + 1))
        ERRORS="${ERRORS}\n  FAIL: ${desc}"
        echo "  [FAIL] ${desc}"
    fi
}

echo "GATE: Build & Test (Dynamic Resolution)"

# Check report file exists
if [ -z "$TEST_REPORT" ] || [ ! -f "$TEST_REPORT" ]; then
    echo "GATE FAIL: Test report (*-test-report.md) not found in ${SPEC_DIR}"
    exit 1
fi

# Check build status
has_build_pass=$(grep -ci "build.*pass\|compilation.*success" "$TEST_REPORT" || true)
check "Build/Compilation passing" "$([ "$has_build_pass" -gt 0 ] && echo true || echo false)"

# Check test status
has_test_pass=$(grep -ci "tests.*pass\|test.*success" "$TEST_REPORT" || true)
check "Unit tests passing" "$([ "$has_test_pass" -gt 0 ] && echo true || echo false)"

# Check for failing tests (should be 0)
fail_count=$(grep -oE '[0-9]+ (failing|failed)' "$TEST_REPORT" | grep -oE '[0-9]+' | head -n 1 || true)
if [ -z "$fail_count" ]; then
  # Alternative format check
  fail_count=$(grep -ci "FAILURES\|ERRORS" "$TEST_REPORT" || true)
fi
check "Zero failing tests (found: ${fail_count:-0})" "$([ "${fail_count:-0}" -eq 0 ] && echo true || echo false)"

# Check for lint status
has_lint_pass=$(grep -ci "lint.*pass\|linting.*success" "$TEST_REPORT" || true)
check "Linting passing" "$([ "$has_lint_pass" -gt 0 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo -e "\nFinal Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
