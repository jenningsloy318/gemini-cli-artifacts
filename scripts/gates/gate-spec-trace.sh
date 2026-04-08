#!/bin/bash
# Gate: Spec-to-BDD Traceability Check
# Verifies that every scenario in BDD file is mapped to a component/function in the spec
# Also verifies existence of separate implementation plan and task list files.
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

echo "GATE: Spec-to-BDD Traceability & Artifact Check"

# S1: BDD File Existence
if [ -n "$BDD_FILE" ] && [ -f "$BDD_FILE" ]; then
    check "S1" "BDD scenarios file found" "true"
else
    check "S1" "BDD scenarios file found" "false"
fi

# S2: Specification File Existence
if [ -n "$SPEC_FILE" ] && [ -f "$SPEC_FILE" ]; then
    check "S2" "Specification file found" "true"
else
    check "S2" "Specification file found" "false"
fi

# S3: Implementation Plan File Existence (Mandatory in v3.4+)
if [ -n "$PLAN_FILE" ] && [ -f "$PLAN_FILE" ]; then
    check "S3" "Separate implementation plan file found" "true"
else
    check "S3" "Separate implementation plan file found" "false"
fi

# S4: Task List File Existence (Mandatory in v3.4+)
if [ -n "$TASK_FILE" ] && [ -f "$TASK_FILE" ]; then
    check "S4" "Separate task list file found" "true"
else
    check "S4" "Separate task list file found" "false"
fi

# If critical files are missing, we can't continue deep checks
if [ "$FAIL" -gt 0 ] && ([ -z "$BDD_FILE" ] || [ -z "$SPEC_FILE" ]); then
    echo -e "\nCritical artifacts missing. Cannot perform traceability check."
    echo "GATE RESULT: FAIL"
    exit 1
fi

# S5: Traceability Check
# Get list of scenario IDs from BDD file
scenario_ids=$(grep -oE 'SCENARIO-[0-9]+' "$BDD_FILE" | sort -u || true)
scenario_count=$(echo "$scenario_ids" | grep -c "SCENARIO" || true)

if [ "$scenario_count" -eq 0 ]; then
    check "S5" "Has scenario IDs to trace" "false"
else
    check "S5" "Has scenario IDs to trace (found: ${scenario_count})" "true"
    
    # Check if each scenario ID is mentioned in the spec file
    for id in $scenario_ids; do
        # We search in BOTH spec and plan files for the scenario ID
        found_in_spec=$(grep -c "$id" "$SPEC_FILE" || true)
        found_in_plan=0
        if [ -f "$PLAN_FILE" ]; then
            found_in_plan=$(grep -c "$id" "$PLAN_FILE" || true)
        fi
        
        if [ "$found_in_spec" -gt 0 ] || [ "$found_in_plan" -gt 0 ]; then
            PASS=$((PASS + 1))
        else
            FAIL=$((FAIL + 1))
            ERRORS="${ERRORS}\n  FAIL S5: Scenario ${id} not traced in specification or plan"
            echo "  [FAIL] S5: Scenario ${id} not traced"
        fi
    done
fi

# S6: Content Validation (Non-redundant)
# Instead of checking for Section 8.1 in specification.md, we verify the PLAN_FILE has actual content
if [ -f "$PLAN_FILE" ]; then
    plan_size=$(wc -c < "$PLAN_FILE" | tr -d ' ')
    check "S6" "Implementation plan has content (>200 chars, actual: ${plan_size})" "$([ "$plan_size" -gt 200 ] && echo true || echo false)"
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
