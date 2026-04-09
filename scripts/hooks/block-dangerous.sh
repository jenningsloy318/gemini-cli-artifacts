#!/usr/bin/env bash
# Gemini CLI Hook: Block dangerous commands
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" != "run_shell_command" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

CMD=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
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
    if echo "$command" | grep -qiE "$pattern" > /dev/null; then
      echo "$pattern"
      return 0
    fi
  done

  # Check for curl/wget/sh/bash only if they look like they are being executed
  # We use word boundaries where possible or specific prefixes
  # Note: be careful not to block local scripts used by the extension itself
  if echo "$command" | grep -qiE "(^|[[:space:]])(curl|wget)([[:space:]]|$)"; then
     echo "network command"
     return 0
  fi
  
  # Only block shell execution if it's NOT a script from this project
  if echo "$command" | grep -qiE "(^|[[:space:]])(sh|bash|zsh|dash)([[:space:]]|$)" && ! echo "$command" | grep -qiE "scripts/"; then
     if echo "$command" | grep -qiE "\.sh([[:space:]]|$)"; then
        echo "shell script execution"
        return 0
     fi
     echo "shell command"
     return 0
  fi

  return 1
}

# Fix: Use || true to prevent set -e from exiting on non-match
MATCHED_REASON=$(is_dangerous "$CMD" || echo "")
if [ -n "$MATCHED_REASON" ]; then
  echo "{\"decision\": \"deny\", \"reason\": \"Blocked: '$CMD' matches dangerous pattern rule ($MATCHED_REASON). Propose a safer alternative.\"}"
  exit 0
fi

echo '{"decision": "allow"}'
exit 0
