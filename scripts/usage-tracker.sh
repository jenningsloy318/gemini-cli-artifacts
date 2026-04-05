#!/usr/bin/env bash
# Usage tracker for super-dev extension
# Logs skill and agent invocations to ${extensionPath}/data/usage.log
#
# Called by BeforeTool hook when subagent tools are invoked.
# Input: JSON via stdin with tool_name, tool_input fields
# Output: JSON decision to stdout

set -euo pipefail

DATA_DIR="${extensionPath}/data"
mkdir -p "$DATA_DIR"

USAGE_LOG="${DATA_DIR}/usage.log"
STATS_FILE="${DATA_DIR}/stats.json"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Read tool input from stdin
INPUT=$(cat)

# Extract tool name and relevant context
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // "unknown"' 2>/dev/null || echo "unknown")

# Log the invocation
echo "{\"ts\":\"$TIMESTAMP\",\"tool\":\"$TOOL_NAME\"}" >> "$USAGE_LOG"

# Update stats.json (create if missing)
if [ ! -f "$STATS_FILE" ]; then
  cat > "$STATS_FILE" << 'INIT'
{"version":"1.0.0","total_invocations":0,"tools":{},"last_updated":""}
INIT
fi

# Increment counters using jq
UPDATED=$(jq --arg name "$TOOL_NAME" --arg ts "$TIMESTAMP" '
  .total_invocations += 1 |
  .tools[$name] = ((.tools[$name] // 0) + 1) |
  .last_updated = $ts
' "$STATS_FILE" 2>/dev/null)

if [ -n "$UPDATED" ]; then
  echo "$UPDATED" > "$STATS_FILE"
fi

# ALWAYS return a decision to stdout for Gemini CLI hooks
echo '{"decision": "allow"}'
exit 0
