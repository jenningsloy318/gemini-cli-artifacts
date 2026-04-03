#!/bin/bash
# Gate: Spec-to-BDD Traceability Check
# Verifies that every scenario in BDD file is mapped to a component/function in the spec
#
# Usage: gate-spec-trace.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-trace.sh <spec-dir>}"
BDD_FILE="${SPEC_DIR}/01.1-behavior-scenarios.md"
SPEC_FILE="${SPEC_DIR}/02-specification.md"

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

# Check files exist
if [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: BDD scenarios file not found: ${BDD_FILE}"
    exit 1
fi

if [ ! -f "$SPEC_FILE" ]; then
    echo "GATE FAIL: Specification file not found: ${SPEC_FILE}"
    exit 1
fi

# Get list of scenario IDs from BDD file
scenario_ids=$(grep -oE 'SCENARIO-[0-9]+' "$BDD_FILE" | sort -u || true)
scenario_count=$(echo "$scenario_ids" | grep -c "SCENARIO" || true)

if [ "$scenario_count" -eq 0 ]; then
    check "Has scenario IDs to trace" "false"
else
    check "Has scenario IDs to trace (found: ${scenario_count})" "true"
    
    # Check if each scenario ID is mentioned in the spec file
    for id in $scenario_ids; do
        found=$(grep -c "$id" "$SPEC_FILE" || true)
        if [ "$found" -gt 0 ]; then
            PASS=$((PASS + 1))
        else
            FAIL=$((FAIL + 1))
            ERRORS="${ERRORS}\n  FAIL: Scenario ${id} not traced in specification"
        fi
    done
fi

# Check for implementation plan section in spec
has_plan=$(grep -ci "implementation plan\|plan" "$SPEC_FILE" || true)
check "Has implementation plan section" "$([ "$has_plan" -gt 0 ] && echo true || echo false)"

# Report
TOTAL=$((PASS + FAIL))
echo "GATE: Spec-to-BDD Traceability"
echo "  Score: ${PASS}/${TOTAL} checks passed"

if [ "$FAIL" -gt 0 ]; then
    echo -e "  Failures:${ERRORS}"
    echo "GATE RESULT: FAIL"
    exit 1
else
    echo "GATE RESULT: PASS"
    exit 0
fi
