#!/bin/bash
# Gate: Spec-to-BDD Traceability Check
# Verifies that every scenario in BDD file is mapped to a component/function in the spec
# Also verifies XML structure of specification and implementation plan.
#
# Usage: gate-spec-trace.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-spec-trace.sh <spec-dir>}"

# Find files dynamically by suffix
BDD_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-behavior-scenarios.md" -o -name "*-scenarios.md" | head -1)
SPEC_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-specification.md" | head -1)
PLAN_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-implementation-plan.md" -o -name "*-plan.md" | head -1)
TASK_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-task-list.md" | head -1)

PASS=0
FAIL=0
ERRORS=""

check() {
    local id="$1"
    local desc="$2"
    local result="$3"
    if [ "$result" = "true" ]; then
        PASS=$((PASS + 1))
        echo "  [PASS] ${id}: ${desc}"
    else
        FAIL=$((FAIL + 1))
        ERRORS="${ERRORS}\n  FAIL ${id}: ${desc}"
        echo "  [FAIL] ${id}: ${desc}"
    fi
}

echo "GATE: Spec-to-BDD Traceability (XML Template Alignment)"

# 1. Existence Checks
[ -n "$BDD_FILE" ] && [ -f "$BDD_FILE" ] && check "S1" "BDD scenarios file found" "true" || check "S1" "BDD scenarios file found" "false"
[ -n "$SPEC_FILE" ] && [ -f "$SPEC_FILE" ] && check "S2" "Specification file found" "true" || check "S2" "Specification file found" "false"
[ -n "$PLAN_FILE" ] && [ -f "$PLAN_FILE" ] && check "S3" "Implementation plan file found" "true" || check "S3" "Implementation plan file found" "false"
[ -n "$TASK_FILE" ] && [ -f "$TASK_FILE" ] && check "S4" "Task list file found" "true" || check "S4" "Task list file found" "false"

# If critical files are missing, we can't continue
if [ -z "$BDD_FILE" ] || [ -z "$SPEC_FILE" ] || [ -z "$PLAN_FILE" ]; then
    echo -e "\nCritical artifacts missing. Cannot perform deep validation."
    echo "GATE RESULT: FAIL"
    exit 1
fi

# 2. XML Wrapper Checks
grep -q "<template name=\"specification\">" "$SPEC_FILE" && check "S2.1" "Spec has <template> wrapper" "true" || check "S2.1" "Spec has <template> wrapper" "false"
grep -q "<template name=\"implementation-plan\">" "$PLAN_FILE" && check "S3.1" "Plan has <template> wrapper" "true" || check "S3.1" "Plan has <template> wrapper" "false"

# 3. Traceability Check
scenario_ids=$(grep -oE 'SCENARIO-[0-9]+' "$BDD_FILE" | sort -u || true)
scenario_count=$(echo "$scenario_ids" | grep -c "SCENARIO" || true)

if [ "$scenario_count" -eq 0 ]; then
    check "S5" "Has scenario IDs to trace" "false"
else
    check "S5" "Has scenario IDs to trace (found: ${scenario_count})" "true"
    for id in $scenario_ids; do
        found_in_spec=$(grep -c "$id" "$SPEC_FILE" || true)
        found_in_plan=$(grep -c "$id" "$PLAN_FILE" || true)
        if [ "$found_in_spec" -gt 0 ] || [ "$found_in_plan" -gt 0 ]; then
            PASS=$((PASS + 1))
        else
            FAIL=$((FAIL + 1))
            ERRORS="${ERRORS}\n  FAIL S5: Scenario ${id} not traced"
            echo "  [FAIL] S5: Scenario ${id} not traced"
        fi
    done
fi

# 4. Content Depth (Exclude XML)
spec_size=$(grep -vE "^<" "$SPEC_FILE" | wc -c | tr -d ' ')
check "S6" "Spec content depth (>500 non-XML chars, actual: ${spec_size})" "$([ "$spec_size" -gt 500 ] && echo true || echo false)"

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
