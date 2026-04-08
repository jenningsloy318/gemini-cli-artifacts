#!/usr/bin/env bash
# Test script for Gemini CLI hooks

set -euo pipefail

echo "Testing block-dangerous.sh..."

# Test safe command
SAFE_RESULT=$(echo '{"tool_name": "run_shell_command", "tool_input": {"command": "ls"}}' | bash scripts/hooks/block-dangerous.sh)
if [[ "$SAFE_RESULT" == *"allow"* ]]; then
  echo "✅ Safe command allowed"
else
  echo "❌ Safe command blocked: $SAFE_RESULT"
  exit 1
fi

# Test dangerous command
DANGEROUS_RESULT=$(echo '{"tool_name": "run_shell_command", "tool_input": {"command": "rm -rf /"}}' | bash scripts/hooks/block-dangerous.sh)
if [[ "$DANGEROUS_RESULT" == *"deny"* ]]; then
  echo "✅ Dangerous command blocked"
else
  echo "❌ Dangerous command allowed!"
  exit 1
fi

# Test project script
SCRIPT_RESULT=$(echo '{"tool_name": "run_shell_command", "tool_input": {"command": "bash scripts/hooks/auto-commit.sh"}}' | bash scripts/hooks/block-dangerous.sh)
if [[ "$SCRIPT_RESULT" == *"allow"* ]]; then
  echo "✅ Project script allowed"
else
  echo "❌ Project script blocked: $SCRIPT_RESULT"
  exit 1
fi

echo "Testing protect-files.sh..."

# Test safe file
SAFE_FILE_RESULT=$(echo '{"tool_name": "write_file", "tool_input": {"file_path": "README.md"}}' | bash scripts/hooks/protect-files.sh)
if [[ "$SAFE_FILE_RESULT" == *"allow"* ]]; then
  echo "✅ Safe file allowed"
else
  echo "❌ Safe file blocked: $SAFE_FILE_RESULT"
  exit 1
fi

# Test protected file
PROTECTED_FILE_RESULT=$(echo '{"tool_name": "write_file", "tool_input": {"file_path": "gemini-extension.json"}}' | bash scripts/hooks/protect-files.sh)
if [[ "$PROTECTED_FILE_RESULT" == *"deny"* ]]; then
  echo "✅ Protected file blocked"
else
  echo "❌ Protected file allowed!"
  exit 1
fi

echo "All tests passed! 🎉"
