#!/usr/bin/env bash
# Gemini CLI Hook: Protect sensitive files from edits
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null || echo "")

if [[ -z "$TOOL_NAME" || ( "$TOOL_NAME" != "write_file" && "$TOOL_NAME" != "replace" ) ]]; then
  echo '{"decision": "allow"}'
  exit 0
fi

FILE=$(echo "$INPUT" | jq -r '.tool_input.file_path // ""' 2>/dev/null || echo "")
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
  # Use standard grep for portability
  if echo "$FILE" | grep -qiE "^${pattern//\*/.*}$" > /dev/null 2>&1; then
    REASON="Blocked: '$FILE' is protected. Explain why this edit is necessary."
    jq -n --arg reason "$REASON" '{decision: "deny", reason: $reason}'
    exit 0
  fi
done

echo '{"decision": "allow"}'
exit 0
