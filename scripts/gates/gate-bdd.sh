#!/bin/bash
# Gate: BDD Scenario Quality Check
# Verifies behavior scenarios follow XML structure and are traceable to AC
#
# Usage: gate-bdd.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-bdd.sh <spec-dir>}"

# Find files dynamically
BDD_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-behavior-scenarios.md" -o -name "*-scenarios.md" | head -1)
REQ_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-requirements.md" | head -1)

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

echo "GATE: BDD Scenario Quality (XML Template Alignment)"

# Check BDD file exists
if [ -z "$BDD_FILE" ] || [ ! -f "$BDD_FILE" ]; then
    echo "GATE FAIL: BDD scenarios file (*-scenarios.md) not found in ${SPEC_DIR}"
    exit 1
fi

# 1. Check for XML Template Wrapper
has_template=$(grep -c "<template name=\"bdd-scenarios\">" "$BDD_FILE" || true)
check "Includes <template name=\"bdd-scenarios\"> wrapper" "$([ "$has_template" -gt 0 ] && echo true || echo false)"

# 2. Check for Mandatory XML Sections
sections=("scenarios" "traceability" "summary" "quality")
for section in "${sections[@]}"; do
    has_sec=$(grep -c "<section id=\"$section\"" "$BDD_FILE" || true)
    check "Includes section <section id=\"$section\" ...>" "$([ "$has_sec" -gt 0 ] && echo true || echo false)"
done

# 3. Check for SCENARIO-XXX IDs
scenario_count=$(grep -cE 'SCENARIO-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has SCENARIO-IDs (found: ${scenario_count})" "$([ "$scenario_count" -ge 1 ] && echo true || echo false)"

# 4. Check for Given/When/Then structure
gwt_count=$(grep -ciE '^\s*(given|when|then|and)\b' "$BDD_FILE" 2>/dev/null || true)
check "Has Given/When/Then structure (found: ${gwt_count} keywords)" "$([ "$gwt_count" -ge 3 ] && echo true || echo false)"

# 5. Check for AC references (traceability)
ac_refs=$(grep -cE 'AC-[0-9]+' "$BDD_FILE" 2>/dev/null || true)
check "Has AC references for traceability (found: ${ac_refs})" "$([ "$ac_refs" -ge 1 ] && echo true || echo false)"

# 6. Check scenario count >= acceptance criteria count (if requirements exist)
if [ -n "$REQ_FILE" ] && [ -f "$REQ_FILE" ]; then
    ac_count=$(grep -cE '^\s*-\s*\[[ x]\]' "$REQ_FILE" 2>/dev/null || true)
    check "Scenarios (${scenario_count}) >= requirements AC items (${ac_count})" "$([ "$scenario_count" -ge "$ac_count" ] && echo true || echo false)"
fi

# 7. Content Depth Check (Exclude XML tags)
content_size=$(grep -vE "^<" "$BDD_FILE" | wc -c | tr -d ' ')
check "BDD content depth (>300 non-XML chars, actual: ${content_size})" "$([ "$content_size" -gt 300 ] && echo true || echo false)"

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
