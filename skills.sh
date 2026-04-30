#!/usr/bin/env bash
# skills.sh — AgenticFlow AI Skills install helper
# Deprecated: Use `npx skills add` instead (official, faster, works with 50+ agents)

set -euo pipefail

REPO="antongulin/agenticflow-ai-skills"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  AgenticFlow AI Skills — skills.sh (deprecated)              ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "⚠️  This script is deprecated. Use the official skills CLI:"
echo ""
echo "   Install all skills:"
echo "     npx skills add ${REPO} --all"
echo ""
echo "   Install one skill:"
echo "     npx skills add ${REPO} --skill agenticflow-agent"
echo ""
echo "   Install globally:"
echo "     npx skills add ${REPO} --global"
echo ""
echo "   See what's available:"
echo "     npx skills add ${REPO} --list"
echo ""
echo "💡 Need help? https://github.com/${REPO}/blob/main/INSTALL.md"
echo ""

# If the user really wants to run the old behavior, allow it with FORCE_LEGACY=1
if [ "${FORCE_LEGACY:-0}" = "1" ]; then
  echo "⏳ FORCE_LEGACY=1 — running legacy install..."
  echo ""
else
  exit 0
fi

# ---- Legacy fallback (only runs with FORCE_LEGACY=1) ----

BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/skills"

detect_target_dir() {
  for dir in ".agents/skills" ".claude/skills" ".cursor/skills" ".codex/skills"; do
    [ -d "$dir" ] && { echo "$dir"; return; }
  done
  for dir in "$HOME/.agents/skills" "$HOME/.claude/skills" "$HOME/.config/opencode/skills"; do
    [ -d "$dir" ] && { echo "$dir"; return; }
  done
  echo ""
}

ALL_KNOWN_SKILLS=(
  "agenticflow-agent"
  "agenticflow-workforce"
  "agenticflow-mcp"
  "agenticflow-llm-models"
  "agenticflow-built-in-credits"
)

TARGET_DIR="${SKILLS_DIR:-$(detect_target_dir)}"

if [ -z "$TARGET_DIR" ]; then
  echo "⚠️  Could not detect your AI tool's skills directory."
  echo "   Set SKILLS_DIR=.agents/skills or SKILLS_DIR=.claude/skills"
  exit 1
fi

echo "📂 Target: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

install_skill() {
  local skill_name="$1"
  local skill_dir="$TARGET_DIR/$skill_name"
  local skill_url="${RAW_URL}/${skill_name}/SKILL.md"

  echo -n "   ${skill_name} ... "
  mkdir -p "$skill_dir"

  if curl -fsSL "$skill_url" -o "$skill_dir/SKILL.md" 2>/dev/null; then
    echo "✅"
  else
    echo "❌ (download failed)"
    return 1
  fi
}

if [ $# -gt 0 ]; then
  SKILLS=("$@")
else
  SKILLS=("${ALL_KNOWN_SKILLS[@]}")
fi

FAILED=0
for skill in "${SKILLS[@]}"; do
  install_skill "$skill" || FAILED=$((FAILED+1))
done

echo "━ Installed: $(( ${#SKILLS[@]} - FAILED ))/${#SKILLS[@]} skills to $TARGET_DIR"
[ "$FAILED" -gt 0 ] && exit 1
