#!/usr/bin/env bash
# Gemini CLI Hook: Log every command run
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

DATA_DIR="${extensionPath}/data"
mkdir -p "$DATA_DIR"
COMMAND_LOG="${DATA_DIR}/command-log.txt"

printf '%s %s\n' "$(date -Is)" "$CMD" >> "$COMMAND_LOG"

echo '{"decision": "allow"}'
exit 0
