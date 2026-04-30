#!/usr/bin/env bash
# skills.sh — Install AgenticFlow AI skills
# Supports: Claude Code, Cursor, OpenCode, Codex, Gemini CLI
#
# Install all:
#   curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash
#
# Install one:
#   curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent

set -euo pipefail

REPO="antongulin/agenticflow-ai-skills"
BRANCH="main"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/skills"

# Auto-detect which AI tool we're in
detect_target_dir() {
  # Check project-level first (cwd), then global
  for dir in \
    ".claude/skills" \
    ".cursor/skills" \
    ".opencode/skills" \
    ".codex/skills" \
    ".gemini/skills"; do
    if [ -d "$dir" ]; then
      echo "$dir"
      return
    fi
  done

  # Check global install locations
  for dir in \
    "$HOME/.claude/skills" \
    "$HOME/.config/opencode/skills" \
    "$HOME/.cursor/skills" \
    "$HOME/.codex/skills" \
    "$HOME/.gemini/skills"; do
    if [ -d "$dir" ]; then
      echo "$dir"
      return
    fi
  done

  # Guess based on common config files
  for marker in ".claude" ".cursor" ".opencode" ".codex" ".gemini"; do
    if [ -d "$marker" ]; then
      echo "${marker}/skills"
      return
    fi
  done

  # Nothing detected — create a .skills/ fallback
  echo ""
}

echo "╔══════════════════════════════════════════╗"
echo "║   AgenticFlow AI Skills Installer        ║"
echo "╚══════════════════════════════════════════╝"
echo ""

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
  echo ""
  echo "   Tell me where to install by setting SKILLS_DIR:"
  echo ""
  echo "   Claude Code:   SKILLS_DIR=.claude/skills"
  echo "   Cursor:        SKILLS_DIR=.cursor/skills"
  echo "   OpenCode:      SKILLS_DIR=.opencode/skills"
  echo "   Codex:         SKILLS_DIR=.codex/skills"
  echo "   Gemini CLI:    SKILLS_DIR=.gemini/skills"
  echo ""
  echo "   Example:"
  echo "   SKILLS_DIR=.claude/skills curl -fsSL ... | bash"
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

# Which skills to install
if [ $# -gt 0 ]; then
  SKILLS=("$@")
else
  SKILLS=("${ALL_KNOWN_SKILLS[@]}")
  echo "🚀 Installing all ${#SKILLS[@]} skills..."
fi
echo ""

FAILED=0
for skill in "${SKILLS[@]}"; do
  install_skill "$skill" || FAILED=$((FAILED+1))
done

echo ""
echo "━ Installed: $(( ${#SKILLS[@]} - FAILED ))/${#SKILLS[@]} skills to $TARGET_DIR"
if [ $FAILED -gt 0 ]; then
  echo "━ Failed: $FAILED"
fi
echo ""

if [ $FAILED -eq 0 ]; then
  echo "✅ Ready — ask your AI agent to help, e.g.:"
  echo "   'create an agent for customer support'"
  echo "   'deploy a dev shop workforce'"
  echo "   'attach google sheets to my agent'"
  echo "   'what model should i use'"
  echo "   'generate an image using my credits'"
  echo ""
  echo "💡 Prerequisite: npm install -g @pixelml/agenticflow-cli"
  echo "📖 Docs: https://github.com/${REPO}"
else
  echo "⚠️  $FAILED skill(s) failed to install. Check your connection and try again."
  exit 1
fi
