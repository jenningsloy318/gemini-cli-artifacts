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
  "DROP TABLE"
  "DROP DATABASE"
  "curl.*|.*sh"
  "wget.*|.*bash"
)

for pattern in "${DANGEROUS_PATTERNS[@]}"; do
  if echo "$CMD" | grep -qiE "$pattern"; then
    echo "{\"decision\": \"deny\", \"reason\": \"Blocked: '$CMD' matches dangerous pattern '$pattern'. Propose a safer alternative.\"}"
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0
