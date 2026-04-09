#!/usr/bin/env bash
# Gemini CLI Hook: Phase gate validation
# Called by BeforeTool hook for 'generalist' and subagent tools.
# Validates prerequisite artifacts exist before spawning phase agents.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

# We disable set -e here because we MUST return a valid JSON decision
# even if an internal command fails.
set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

# Standard allow if parsing failed or tool doesn't match
if [[ -z "$TOOL_NAME" || ( "$TOOL_NAME" != "generalist" && "$TOOL_NAME" != "codebase_investigator" ) ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

REQUEST=$(echo "$INPUT" | jq -r '.tool_input.request // .tool_input.objective // ""' 2>/dev/null || echo "")

# Extract agent type from request (e.g., "Act as the requirements-clarifier subagent")
# Using standard grep + sed for maximum portability across macOS/Linux
AGENT_NAME=$(echo "$REQUEST" | grep -o "Act as the [a-zA-Z0-9_-]\+" | head -1 | sed 's/Act as the //' || echo "")
AGENT_TYPE="super-dev:$AGENT_NAME"

# Skip if no agent name found or it's Tech Lead
if [[ -z "$AGENT_NAME" || "$AGENT_NAME" == "tech-lead" ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Load manifest
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Look for manifest in a predictable location relative to the script
MANIFEST="${SCRIPT_DIR}/../../hooks/phase-manifest.json"

if [ ! -f "$MANIFEST" ]; then
  # Fallback: try to find it via git if possible, but don't fail if it fails
  GIT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "")
  if [ -n "$GIT_ROOT" ]; then
    MANIFEST="$GIT_ROOT/hooks/phase-manifest.json"
  fi
fi

if [ ! -f "$MANIFEST" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Check if this agent type has gate requirements
GATE=$(jq -r --arg agent "$AGENT_TYPE" '.gates[$agent] // empty' "$MANIFEST" 2>/dev/null)
if [ -z "$GATE" ]; then
  # Try fuzzy match if exact match fails
  GATE=$(jq -r --arg name "$AGENT_NAME" '.gates | to_entries[] | select(.key | contains($name)) | .value' "$MANIFEST" | head -1 2>/dev/null || echo "")
fi

if [ -z "$GATE" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

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

# If we can't find the spec directory, allow
if [ -z "$SPEC_DIR" ] || [ ! -d "$SPEC_DIR" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Check required files
PHASE=$(echo "$GATE" | jq -r '.phase' 2>/dev/null || echo "unknown")
DESCRIPTION=$(echo "$GATE" | jq -r '.description' 2>/dev/null || echo "check requirements")
MISSING=""

# Extract requirements array safely
REQUIRES=$(echo "$GATE" | jq -r '.requires[]? // empty' 2>/dev/null)

if [ -n "$REQUIRES" ]; then
  while IFS= read -r req_file; do
    [ -z "$req_file" ] && continue

    # Replace [doc-index] with * for shell globbing
    glob_pattern="${req_file/\[doc-index\]/*}"

    found=false
    # Search in spec directory
    # Using find to be robust against missing files or glob failures
    candidate=$(find "$SPEC_DIR" -maxdepth 1 -name "$glob_pattern" -size +0c 2>/dev/null | head -1)
    
    if [ -n "$candidate" ] && [ -f "$candidate" ]; then
      # Check required sections if defined in manifest
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
    fi

    if [ "$found" = false ] && ! echo -e "$MISSING" | grep -q "$req_file"; then
      MISSING="${MISSING}  - ${req_file} (not found or empty in ${SPEC_DIR})\n"
    fi
  done <<< "$REQUIRES"
fi

if [ -n "$MISSING" ]; then
  # Format error for Gemini CLI decision
  REASON="PHASE GATE BLOCKED: Cannot start Phase ${PHASE} (${AGENT_TYPE}).\nReason: ${DESCRIPTION}\nMissing prerequisite artifacts in ${SPEC_DIR}:\n${MISSING}\nComplete the previous phase(s) and ensure all artifacts are written before proceeding."
  # Use jq to produce a valid JSON response even if the REASON has weird characters
  jq -n --arg reason "$(echo -e "$REASON")" '{decision: "deny", reason: $reason}'
  exit 0
fi

echo '{"decision": "allow"}'
exit 0
