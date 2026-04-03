#!/bin/bash
# Gate: Documentation-Code Drift Quality Check
# Verifies that documentation was updated if code was changed
#
# Usage: gate-docs-drift.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-docs-drift.sh <spec-dir>}"
DOCS_UPDATE_FILE="${SPEC_DIR}/10-docs-update.md"

PASS=0
FAIL=0
ERRORS=""

check() {
    local desc="$1"
    local result="$2"
    if [ "$result" = "true" ]; then
        PASS=$((PASS + 1))
    else
        FAIL=$((FAIL + 1))
        ERRORS="${ERRORS}\n  FAIL: ${desc}"
    fi
}

# Check docs update file exists
if [ ! -f "$DOCS_UPDATE_FILE" ]; then
    echo "GATE FAIL: Documentation update report not found: ${DOCS_UPDATE_FILE}"
    exit 1
fi

# Check for "updated files" section
has_files=$(grep -ci "updated files\|files updated" "$DOCS_UPDATE_FILE" || true)
check "Lists updated documentation files" "$([ "$has_files" -gt 0 ] && echo true || echo false)"

# Check for status: complete
is_complete=$(grep -ci "status:.*complete" "$DOCS_UPDATE_FILE" || true)
check "Documentation update status: COMPLETE" "$([ "$is_complete" -gt 0 ] && echo true || echo false)"

# Check for "drift analysis" or similar
has_analysis=$(grep -ci "drift analysis\|gap analysis" "$DOCS_UPDATE_FILE" || true)
check "Has documentation gap/drift analysis" "$([ "$has_analysis" -gt 0 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Documentation-Code Drift"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
