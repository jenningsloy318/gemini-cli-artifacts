#!/bin/bash
# Gate: Review Verdicts Quality Check
# Verifies that both Code and Adversarial reviews have passed
#
# Usage: gate-review.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-review.sh <spec-dir>}"
REVIEW_FILE="${SPEC_DIR}/09-code-review.md"
ADV_REVIEW_FILE="${SPEC_DIR}/09.1-adversarial-review.md"

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

# Check Code Review
if [ -f "$REVIEW_FILE" ]; then
    # Verdict should be APPROVED
    verdict=$(grep -i "verdict:" "$REVIEW_FILE" | head -n 1 | cut -d':' -f2 | tr -d ' ' || true)
    check "Code Review Verdict: APPROVED (found: ${verdict:-none})" "$([ "${verdict^^}" = "APPROVED" ] && echo true || echo false)"
    
    # Critical findings should be 0
    crit_count=$(grep -i "critical:" "$REVIEW_FILE" | head -n 1 | cut -d':' -f2 | tr -d ' ' || true)
    check "Zero Critical findings (found: ${crit_count:-none})" "$([ "${crit_count:-0}" -eq 0 ] && echo true || echo false)"
    
    # High findings should be 0
    high_count=$(grep -i "high:" "$REVIEW_FILE" | head -n 1 | cut -d':' -f2 | tr -d ' ' || true)
    check "Zero High findings (found: ${high_count:-none})" "$([ "${high_count:-0}" -eq 0 ] && echo true || echo false)"
else
    check "Code Review file exists" "false"
fi

# Check Adversarial Review
if [ -f "$ADV_REVIEW_FILE" ]; then
    # Verdict should be PASS
    verdict=$(grep -i "verdict:" "$ADV_REVIEW_FILE" | head -n 1 | cut -d':' -f2 | tr -d ' ' || true)
    check "Adversarial Review Verdict: PASS (found: ${verdict:-none})" "$([ "${verdict^^}" = "PASS" ] && echo true || echo false)"
else
    check "Adversarial Review file exists" "false"
fi

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Review Verdicts"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
