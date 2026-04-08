#!/bin/bash
# Gate: Review Verdicts Quality Check
# Verifies that both Code and Adversarial reviews have passed
#
# Usage: gate-review.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-review.sh <spec-dir>}"

# Find review files dynamically
REVIEW_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-code-review.md" | head -1)
ADV_REVIEW_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-adversarial-review.md" | head -1)

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

echo "GATE: Review Verdicts (Dynamic Resolution)"

# 1. Check Code Review
if [ -n "$REVIEW_FILE" ] && [ -f "$REVIEW_FILE" ]; then
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
    check "Code Review file (*-code-review.md) found" "false"
fi

# 2. Check Adversarial Review
if [ -n "$ADV_REVIEW_FILE" ] && [ -f "$ADV_REVIEW_FILE" ]; then
    # Verdict should be PASS
    verdict=$(grep -i "verdict:" "$ADV_REVIEW_FILE" | head -n 1 | cut -d':' -f2 | tr -d ' ' || true)
    check "Adversarial Review Verdict: PASS (found: ${verdict:-none})" "$([ "${verdict^^}" = "PASS" ] && echo true || echo false)"
else
    check "Adversarial Review file (*-adversarial-review.md) found" "false"
fi

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
