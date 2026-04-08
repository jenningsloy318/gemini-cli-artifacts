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

# Extract phase number from the request if present (e.g., "Act as the requirements-clarifier subagent for Phase 2")
# Fix: Use || echo "" to prevent set -e from exiting on non-match
PHASE=$(echo "$REQUEST" | grep -oE "Phase [0-9.]+" | head -1 | awk '{print $2}' || echo "")

if [ -z "$PHASE" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Extract spec directory from the request
# We look for paths like .worktree/.../specification/... or just specification/...
SPEC_DIR=$(echo "$REQUEST" | grep -oE "(\.worktree/[^/]+/)?specification/[^ ]+" | head -1 || echo "")

if [ -z "$SPEC_DIR" ]; then
  # Try to find spec directory in the request string if it's not preceded by 'specification/'
  SPEC_DIR=$(echo "$REQUEST" | grep -oE "(\.worktree/[^/]+/)?specification/[a-zA-Z0-9_-]+" | head -1 || echo "")
fi

# If we can't find the spec directory, we can't check integrity
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Integrity checks based on current phase
case "$PHASE" in
  "2.5")
    # Check Phase 2 (Requirements)
    if [ ! -f "$SPEC_DIR/01-requirements.md" ]; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 2 requirements (01-requirements.md) are missing. Complete Phase 2 before starting Phase 2.5.\"}"
      exit 0
    fi
    ;;
  "3")
    # Check Phase 2.5 (BDD Scenarios)
    if [ ! -f "$SPEC_DIR/01.1-behavior-scenarios.md" ]; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 2.5 BDD scenarios (01.1-behavior-scenarios.md) are missing. Complete Phase 2.5 before starting Phase 3.\"}"
      exit 0
    fi
    ;;
  "5")
    # Check Phase 3 (Research)
    if [ ! -f "$SPEC_DIR/02-research.md" ]; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 3 research (02-research.md) is missing. Complete Phase 3 before starting Phase 5.\"}"
      exit 0
    fi
    ;;
  "6")
    # Check Phase 5 (Assessment/Design)
    if [ ! -f "$SPEC_DIR/04-assessment.md" ]; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 5 assessment (04-assessment.md) is missing. Complete Phase 5 before starting Phase 6.\"}"
      exit 0
    fi
    ;;
  "8")
    # Check Phase 6 & 7 (Spec & Plan)
    if [ ! -f "$SPEC_DIR/06-specification.md" ] || [ ! -f "$SPEC_DIR/07-implementation-plan.md" ]; then
      echo "{\"decision\": \"deny\", \"reason\": \"Integrity Failure: Phase 6/7 specification or plan is missing. Complete specification writing and review before execution.\"}"
      exit 0
    fi
    ;;
esac

echo '{"decision": "allow"}'
exit 0
