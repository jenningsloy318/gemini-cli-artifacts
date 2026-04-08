#!/bin/bash
# Gate: Documentation-Code Drift Quality Check
# Verifies that documentation was updated following XML structure
#
# Usage: gate-docs-drift.sh <spec-dir>
# Exit 0 = PASS, Exit 1 = FAIL

set -euo pipefail

SPEC_DIR="${1:?Usage: gate-docs-drift.sh <spec-dir>}"

# Find docs update file dynamically
DOCS_UPDATE_FILE=$(find "$SPEC_DIR" -maxdepth 1 -name "*-docs-update.md" -o -name "*-documentation-updates.md" | head -1)

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

echo "GATE: Documentation-Code Drift (XML Template Alignment)"

# Check file exists
if [ -z "$DOCS_UPDATE_FILE" ] || [ ! -f "$DOCS_UPDATE_FILE" ]; then
    echo "GATE FAIL: Documentation update report (*-docs-update.md) not found in ${SPEC_DIR}"
    exit 1
fi

# 1. Check for XML Template Wrapper (Generic check for docs-update or handoff if final)
has_template=$(grep -cE "<template name=\"(docs-update|handoff)\">" "$DOCS_UPDATE_FILE" || true)
check "Includes <template> wrapper" "$([ "$has_template" -gt 0 ] && echo true || echo false)"

# 2. Check for "updated files" or "changes made" section
has_files=$(grep -ci "updated files\|files updated\|changes made" "$DOCS_UPDATE_FILE" || true)
check "Lists updated documentation files / changes" "$([ "$has_files" -gt 0 ] && echo true || echo false)"

# 3. Check for status: complete or PASS
is_complete=$(grep -ciE "status:.*(complete|PASS)" "$DOCS_UPDATE_FILE" || true)
check "Documentation update status is COMPLETE or PASS" "$([ "$is_complete" -gt 0 ] && echo true || echo false)"

# 4. Check for content depth (Exclude XML tags)
content_size=$(grep -vE "^<" "$DOCS_UPDATE_FILE" | wc -c | tr -d ' ')
check "Report content depth (>200 non-XML chars, actual: ${content_size})" "$([ "$content_size" -gt 200 ] && echo true || echo false)"

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
