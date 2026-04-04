#!/usr/bin/env bash
# Gemini CLI Hook: Require passing tests before creating a PR
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" != "mcp_github_create_pull_request" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Run tests (this should be adapted based on the project's config)
# In a real hook, we'd look up the test command from config.json
if npm run test --silent > /dev/null 2>&1 || [ $? -eq 0 ]; then
  echo '{"decision": "allow"}'
else
  echo '{"decision": "deny", "reason": "Blocked: Tests are failing. Fix all test failures before creating a PR."}'
fi

exit 0
