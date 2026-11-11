#!/usr/bin/env bash
# Reverse Engineering Suite Installer for Unix/Linux/macOS
# Installs: reverse-api-engineer, replica-skill, craft-anything, rea-agents

set -e

echo "=== Installing Reverse Engineering Suite ==="

LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$LOCAL_BIN"

# 1. reverse-api-engineer
echo "--> Installing reverse-api-engineer..."
if command -v uv >/dev/null 2>&1; then
    uv tool install "reverse-api-engineer[manual]" --force || true
elif command -v pip3 >/dev/null 2>&1; then
    pip3 install "reverse-api-engineer[manual]" || true
fi

# 2. replica-skill
echo "--> Installing replica-skill..."
SKILL_TARGETS=(
    "$HOME/.gemini/config/skills"
    "$HOME/.claude/skills"
    "$HOME/.agents/skills"
)
TEMP_DIR=$(mktemp -d)
git clone --depth 1 https://github.com/Jakeschincariol/replica-skill.git "$TEMP_DIR"

for TARGET in "${SKILL_TARGETS[@]}"; do
    PARENT=$(dirname "$TARGET")
    if [ -d "$PARENT" ]; then
        mkdir -p "$TARGET"
        cp -r "$TEMP_DIR"/replica-* "$TARGET"/ 2>/dev/null || true
        echo "Copied skills to $TARGET"
    fi
done
rm -rf "$TEMP_DIR"

# 3. REA Agents
echo "--> Setting up REA agents..."
if command -v npx >/dev/null 2>&1; then
    npx --yes rea-agents setup --yes || true
fi

echo "=== Installation complete ==="
