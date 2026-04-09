#!/usr/bin/env bash
# Gemini CLI Hook: Auto-commit after each completed task
# Called by Stop hook.
# Output: JSON decision to stdout

set -uo pipefail

# Ensure we're in a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo '{"decision": "allow"}'
  exit 0
fi

# Stage all changes
git add -A

# If there are changes to commit
if ! git diff --cached --quiet; then
  git commit -m "chore(ai): apply Gemini CLI edit"
fi

echo '{"decision": "allow"}'
exit 0
