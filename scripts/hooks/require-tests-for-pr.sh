#!/usr/bin/env bash
# Gemini CLI Hook: Require passing tests before creating a PR
# Called by BeforeTool hook.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -uo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""')

if [ "$TOOL_NAME" != "mcp_github_create_pull_request" ]; then
  echo '{"decision": "allow"}'
  exit 0
fi

# 1. Extract Head Branch
HEAD_BRANCH=$(echo "$INPUT" | jq -r '.tool_input.head // ""')

# 2. Determine Working Directory for Tests
# If head branch looks like a spec branch (e.g., "01-auth-fix"), check if a worktree exists
TEST_DIR="."
if [ -n "$HEAD_BRANCH" ]; then
  if [ -d ".worktree/$HEAD_BRANCH" ]; then
    TEST_DIR=".worktree/$HEAD_BRANCH"
  fi
fi

# 3. Run tests in the identified directory
# Note: we use (cd $TEST_DIR && ...) to ensure we don't change the script's own CWD permanently
# and to be robust against TEST_DIR being "."
if (cd "$TEST_DIR" && npm run test --silent > /dev/null 2>&1) || [ $? -eq 0 ]; then
  echo '{"decision": "allow"}'
else
  echo "{\"decision\": \"deny\", \"reason\": \"Blocked: Tests are failing in $TEST_DIR. Fix all test failures before creating a PR for $HEAD_BRANCH.\"}"
fi

exit 0
