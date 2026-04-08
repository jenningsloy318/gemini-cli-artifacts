#!/bin/bash
# Gate: Requirements Completeness Check
# Verifies requirements document has minimum quality and follows XML structure
#
# Usage: gate-requirements.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-requirements.sh <spec-dir>}"

# Find requirements file dynamically (suffix check)
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

echo "GATE: Requirements Completeness (XML Template Alignment)"

# Check file exists
if [ -z "$REQ_FILE" ] || [ ! -f "$REQ_FILE" ]; then
    echo "GATE FAIL: Requirements file (*-requirements.md) not found in ${SPEC_DIR}"
    exit 1
fi

# 1. Check for XML Template Wrapper
has_template=$(grep -c "<template name=\"requirements\">" "$REQ_FILE" || true)
check "Includes <template name=\"requirements\"> wrapper" "$([ "$has_template" -gt 0 ] && echo true || echo false)"

# 2. Check for Mandatory XML Sections
sections=("summary" "need" "workflow" "requirements" "options" "impact" "technical" "ac")
for section in "${sections[@]}"; do
    has_sec=$(grep -c "<section id=\"$section\"" "$REQ_FILE" || true)
    check "Includes section <section id=\"$section\" ...>" "$([ "$has_sec" -gt 0 ] && echo true || echo false)"
done

# 3. Check for specific critical subsections
subsections=("5whys" "jtbd" "ac")
for sub in "${subsections[@]}"; do
    has_sub=$(grep -c "<subsection id=\"$sub\"" "$REQ_FILE" || true)
    check "Includes subsection <subsection id=\"$sub\" ...>" "$([ "$has_sub" -gt 0 ] && echo true || echo false)"
done

# 4. Check for Acceptance Criteria items (Markdown tasks inside the AC section)
# We look for lines starting with - [ ] or - [x]
ac_items=$(grep -cE '^\s*-\s*\[[ x]\]' "$REQ_FILE" || true)
check "Has at least 2 acceptance criteria tasks (found: ${ac_items})" "$([ "$ac_items" -ge 2 ] && echo true || echo false)"

# 5. Content Depth Check
# Exclude the XML tags from character count to ensure real content exists
content_size=$(grep -vE "^<" "$REQ_FILE" | wc -c | tr -d ' ')
check "Requirement content depth (>500 non-XML chars, actual: ${content_size})" "$([ "$content_size" -gt 500 ] && echo true || echo false)"

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
