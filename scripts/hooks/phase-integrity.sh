#!/usr/bin/env bash
# Gemini CLI Hook: Phase Integrity Check
# Called by BeforeTool hook.
# Triggers on generalist calls that start a new phase.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" != "generalist" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

REQUEST=$(echo "$INPUT" | jq -r '.tool_input.request // ""')

# Extract phase number from the request
PHASE=$(echo "$REQUEST" | grep -oE "Phase [0-9.]+" | head -1 | awk '{print $2}' || echo "")

if [ -z "$PHASE" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# 1. Try to find the full path if it already contains .worktree
ACTUAL_SPEC_DIR=$(echo "$REQUEST" | grep -oE "\.worktree/[^ ]+/specification/[^ ]+" | head -1 | sed 's/[,;]$//' || echo "")

# 2. If not found, try to extract worktree and spec_dir separately
if [ -z "$ACTUAL_SPEC_DIR" ]; then
  # Extract worktree (stop at first space or punctuation)
  WORKTREE=$(echo "$REQUEST" | grep -oE "\.worktree/[a-zA-Z0-9_-]+" | head -1 || echo "")
  # Extract spec dir
  SPEC_DIR_REL=$(echo "$REQUEST" | grep -oE "specification/[a-zA-Z0-9_-]+" | head -1 || echo "")
  
  if [ -n "$WORKTREE" ] && [ -n "$SPEC_DIR_REL" ]; then
    ACTUAL_SPEC_DIR="$WORKTREE/$SPEC_DIR_REL"
  elif [ -n "$SPEC_DIR_REL" ]; then
    ACTUAL_SPEC_DIR="$SPEC_DIR_REL"
  fi
fi

# If we can't find the spec directory, we can't check integrity
if [ -z "$ACTUAL_SPEC_DIR" ] || [ ! -d "$ACTUAL_SPEC_DIR" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Helper function to check for file existence by suffix (dynamic indexing)
check_file() {
  local suffix="$1"
  # Look for files ending in -suffix
  local found=$(find "$ACTUAL_SPEC_DIR" -maxdepth 1 -name "*-$suffix" | head -1)
  if [ -n "$found" ] && [ -f "$found" ]; then
    return 0
  else
    return 1
  fi
}

# Integrity checks based on current phase
case "$PHASE" in
  "2.5")
    # Check Phase 2 (Requirements)
    if ! check_file "requirements.md"; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 2 requirements (*-requirements.md) are missing in $ACTUAL_SPEC_DIR. Complete Phase 2 before starting Phase 2.5.\"}"
      exit 0
    fi
    ;;
  "3")
    # Check Phase 2.5 (BDD Scenarios)
    if ! check_file "scenarios.md"; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 2.5 BDD scenarios (*-scenarios.md) are missing in $ACTUAL_SPEC_DIR. Complete Phase 2.5 before starting Phase 3.\"}"
      exit 0
    fi
    ;;
  "5")
    # Check Phase 3 (Research)
    if ! check_file "research.md"; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 3 research (*-research.md) is missing in $ACTUAL_SPEC_DIR. Complete Phase 3 before starting Phase 5.\"}"
      exit 0
    fi
    ;;
  "6")
    # Check Phase 5 (Assessment/Design)
    if ! check_file "assessment.md"; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 5 assessment (*-assessment.md) is missing in $ACTUAL_SPEC_DIR. Complete Phase 5 before starting Phase 6.\"}"
      exit 0
    fi
    ;;
  "8")
    # Check Phase 6 & 7 (Spec & Plan)
    if ! check_file "specification.md" || ! check_file "plan.md"; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 6/7 specification or plan is missing in $ACTUAL_SPEC_DIR. Complete specification writing and review before execution.\"}"
      exit 0
    fi
    ;;
esac

echo '{"decision": "allow"}'
exit 0
