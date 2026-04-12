#!/usr/bin/env bash

# Integration script for Antigravity, a Google IDE.
# Maps gemini-cli-artifacts directly into the Antigravity global environment.

set -e

# Get the absolute path to this project directory
PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ANTIGRAVITY_BASE="$HOME/.gemini/antigravity"

# Paths
SKILL_TARGET="$ANTIGRAVITY_BASE/skills/super-dev"
WORKFLOW_TARGET="$ANTIGRAVITY_BASE/global_workflows"

echo "=== Installing super-dev into Antigravity ==="

# 1. Symlink the Skill
if [ -d "$SKILL_TARGET" ] || [ -L "$SKILL_TARGET" ]; then
    echo "Backing up existing super-dev skill installation..."
    mv "$SKILL_TARGET" "$SKILL_TARGET.bak.$(date +%Y%m%d%H%M%S)"
fi

echo "Creating symlink for super-dev skill..."
ln -s "$PROJECT_ROOT" "$SKILL_TARGET"
echo "  ✓ Linked $PROJECT_ROOT -> $SKILL_TARGET"

# 2. Symlink Commands to Global Workflows
echo "Creating symlinks for commands/ into global_workflows..."
for CMD_FILE in "$PROJECT_ROOT/commands"/*.md; do
    if [ -f "$CMD_FILE" ]; then
        BASE_NAME=$(basename "$CMD_FILE")
        # Rename execution maps to namespace e.g. execute.md -> super-dev:execute.md
        SYM_TARGET="$WORKFLOW_TARGET/super-dev:$BASE_NAME"
        
        # Clean up existing
        if [ -L "$SYM_TARGET" ] || [ -f "$SYM_TARGET" ]; then
            rm -f "$SYM_TARGET"
        fi

        ln -s "$CMD_FILE" "$SYM_TARGET"
        echo "  ✓ Linked $BASE_NAME -> super-dev:$BASE_NAME"
    fi
done

echo "=== Installation complete. Changes will appear instantly in Antigravity! ==="
