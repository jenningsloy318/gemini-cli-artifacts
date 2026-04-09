#!/usr/bin/env bash
# Gemini CLI Hook: Block dangerous commands
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [ "$TOOL_NAME" != "run_shell_command" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""' 2>/dev/null || echo "")
DANGEROUS_PATTERNS=(
  "rm -rf"
  "git reset --hard"
  "git push.*--force"
  "git push.*-f\b"
  "DROP TABLE"
  "DROP DATABASE"
)

# Function to check for dangerous patterns
is_dangerous() {
  local command="$1"
  
  # Check for specific fixed strings
  for pattern in "${DANGEROUS_PATTERNS[@]}"; do
    if echo "$command" | grep -qiE "$pattern" > /dev/null 2>&1; then
      echo "$pattern"
      return 0
    fi
  done

  # Check for curl/wget/sh/bash only if they look like they are being executed
  if echo "$command" | grep -qiE "(^|[[:space:]])(curl|wget)([[:space:]]|$)" > /dev/null 2>&1; then
     echo "network command"
     return 0
  fi
  
  # Only block shell execution if it's NOT a script from this project
  if echo "$command" | grep -qiE "(^|[[:space:]])(sh|bash|zsh|dash)([[:space:]]|$)" > /dev/null 2>&1 && ! echo "$command" | grep -qiE "scripts/" > /dev/null 2>&1; then
     if echo "$command" | grep -qiE "\.sh([[:space:]]|$)" > /dev/null 2>&1; then
        echo "shell script execution"
        return 0
     fi
     echo "shell command"
     return 0
  fi

  return 1
}

MATCHED_REASON=$(is_dangerous "$CMD" || echo "")
if [ -n "$MATCHED_REASON" ]; then
  REASON="Blocked: '$CMD' matches dangerous pattern rule ($MATCHED_REASON). Propose a safer alternative."
  jq -n --arg reason "$REASON" '{decision: "deny", reason: $reason}'
  exit 0
fi

echo '{"decision": "allow"}'
exit 0
