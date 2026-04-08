#!/usr/bin/env bash
# Gemini CLI Hook: Phase gate validation
# Called by BeforeTool hook for 'generalist' and subagent tools.
# Validates prerequisite artifacts exist before spawning phase agents.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

# We handle both generic 'generalist' calls and specific subagent tool calls
# (though in super-dev, generalist is the primary mechanism for phases)
if [[ "$TOOL_NAME" != "generalist" && "$TOOL_NAME" != "codebase_investigator" ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

REQUEST=$(echo "$INPUT" | jq -r '.tool_input.request // .tool_input.objective // ""')

# Extract agent type from request (e.g., "Act as the requirements-clarifier subagent")
# In super-dev, we use the format super-dev:[agent-name]
AGENT_NAME=$(echo "$REQUEST" | grep -oP "Act as the \K[a-zA-Z0-9_-]+" | head -1 || echo "")
AGENT_TYPE="super-dev:$AGENT_NAME"

# Skip if no agent name found or it's TechLead
if [[ -z "$AGENT_NAME" || "$AGENT_NAME" == "TechLead" ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Load manifest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Try to find manifest in project root hooks/ or relative to script
MANIFEST="$(git rev-parse --show-toplevel)/hooks/phase-manifest.json"
if [ ! -f "$MANIFEST" ]; then
  # Fallback to current directory of the script if git fails or manifest not at root
  MANIFEST="${SCRIPT_DIR}/../../hooks/phase-manifest.json"
fi

[ ! -f "$MANIFEST" ] && echo '{"decision": "allow"}' && exit 0

# Check if this agent type has gate requirements
GATE=$(jq -r --arg agent "$AGENT_TYPE" '.gates[$agent] // empty' "$MANIFEST" 2>/dev/null)
if [ -z "$GATE" ]; then
  # Try fuzzy match if exact match fails
  GATE=$(jq -r --arg name "$AGENT_NAME" '.gates | to_entries[] | select(.key | contains($name)) | .value' "$MANIFEST" | head -1 || echo "")
fi

[ -z "$GATE" ] && echo '{"decision": "allow"}' && exit 0

# Resolve Spec Directory (Worktree aware)
# 1. Try to find the full path if it already contains .worktree
SPEC_DIR=$(echo "$REQUEST" | grep -oE "\.worktree/[^ ]+/specification/[^ ]+" | head -1 | sed 's/[,;]$//' || echo "")

# 2. If not found, try to extract worktree and spec_dir separately
if [ -z "$SPEC_DIR" ]; then
  WORKTREE=$(echo "$REQUEST" | grep -oE "\.worktree/[a-zA-Z0-9_-]+" | head -1 || echo "")
  SPEC_DIR_REL=$(echo "$REQUEST" | grep -oE "specification/[a-zA-Z0-9_-]+" | head -1 || echo "")
  
  if [ -n "$WORKTREE" ] && [ -n "$SPEC_DIR_REL" ]; then
    SPEC_DIR="$WORKTREE/$SPEC_DIR_REL"
  elif [ -n "$SPEC_DIR_REL" ]; then
    SPEC_DIR="$SPEC_DIR_REL"
  fi
fi

# If we can't find the spec directory, allow (early phases might not have it yet or it's hard to parse)
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Check required files
PHASE=$(echo "$GATE" | jq -r '.phase')
DESCRIPTION=$(echo "$GATE" | jq -r '.description')
MISSING=""

while IFS= read -r req_file; do
  [ -z "$req_file" ] && continue

  # Replace [doc-index] with * for shell globbing
  glob_pattern="${req_file/\[doc-index\]/*}"

  found=false
  # Search in spec directory
  for candidate in "$SPEC_DIR"/$glob_pattern; do
    if [ -f "$candidate" ] && [ -s "$candidate" ]; then
      # Check required sections if defined in manifest
      # We use jq to get the array of sections for this specific required file
      SECTIONS=$(echo "$GATE" | jq -r --arg f "$req_file" '.sections[$f][]? // empty' 2>/dev/null || echo "")

      if [ -n "$SECTIONS" ]; then
        section_ok=true
        while IFS= read -r section; do
          [ -z "$section" ] && continue
          if ! grep -qi "$section" "$candidate" 2>/dev/null; then
            MISSING="${MISSING}  - ${req_file} (exists but missing required section: '${section}')\n"
            section_ok=false
            break
          fi
        done <<< "$SECTIONS"

        if [ "$section_ok" = true ]; then
          found=true
        fi
      else
        found=true
      fi
      break
    fi
  done

  if [ "$found" = false ] && ! echo -e "$MISSING" | grep -q "$req_file"; then
    MISSING="${MISSING}  - ${req_file} (not found or empty in ${SPEC_DIR})\n"
  fi
done < <(echo "$GATE" | jq -r '.requires[]' 2>/dev/null)

if [ -n "$MISSING" ]; then
  # Format error for Gemini CLI decision
  REASON="PHASE GATE BLOCKED: Cannot start Phase ${PHASE} (${AGENT_TYPE}).\nReason: ${DESCRIPTION}\nMissing prerequisite artifacts in ${SPEC_DIR}:\n${MISSING}\nComplete the previous phase(s) and ensure all artifacts are written before proceeding."
  # Escape for JSON
  REASON=$(echo -e "$REASON" | jq -Rs .)
  echo "{\"decision\": \"deny\", \"reason\": $REASON}"
  exit 0
fi

echo '{"decision": "allow"}'
exit 0
