#!/usr/bin/env bash
# Gemini CLI Hook: Protect sensitive files from edits
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" != "write_file" ] && [ "$TOOL_NAME" != "replace" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""')
PROTECTED=(
  ".env*"
  ".git/*"
  "package-lock.json"
  "yarn.lock"
  "*.pem"
  "*.key"
  "secrets/*"
  "hooks/hooks.json"
  "gemini-extension.json"
)

for pattern in "${PROTECTED[@]}"; do
  if echo "$FILE" | grep -qiE "^${pattern//\*/.*}$"; then
    echo "{\"decision\": \"deny\", \"reason\": \"Blocked: '$FILE' is protected. Explain why this edit is necessary.\"}"
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0
