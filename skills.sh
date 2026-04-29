#!/usr/bin/env bash
# skills.sh — Install AgenticFlow AI skills into your project
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash        # install all
#   curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent  # install one

set -euo pipefail

REPO="antongulin/agenticflow-ai-skills"
BRANCH="main"
API_URL="https://api.github.com/repos/${REPO}/contents/skills"
RAW_URL="https://raw.githubusercontent.com/${REPO}/${BRANCH}/skills"

# Detect target directory
detect_target_dir() {
  if [ -d ".claude/skills" ]; then
    echo ".claude/skills"
  elif [ -d ". cursor/skills" ]; then
    echo ".cursor/skills"
  elif [ -d "skills" ]; then
    echo "skills"
  else
    echo ""
  fi
}

echo "🔧 AgenticFlow AI Skills Installer"
echo "==================================="
echo ""

# Allow override
TARGET_DIR="${SKILLS_DIR:-$(detect_target_dir)}"

if [ -z "$TARGET_DIR" ]; then
  echo "⚠️  Could not auto-detect skills directory."
  echo "    Set SKILLS_DIR to specify where to install, e.g.:"
  echo "    SKILLS_DIR=./skills curl -fsSL ... | bash"
  exit 1
fi

echo "📂 Installing to: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

install_skill() {
  local skill_name="$1"
  local skill_dir="$TARGET_DIR/$skill_name"
  local skill_url="${RAW_URL}/${skill_name}/SKILL.md"

  echo "  📥 Installing: $skill_name"
  mkdir -p "$skill_dir"
  
  if curl -fsSL "$skill_url" -o "$skill_dir/SKILL.md" 2>/dev/null; then
    echo "     ✅ $skill_name installed"
  else
    echo "     ❌ Failed to download $skill_name"
    return 1
  fi
}

# Determine which skills to install
if [ $# -eq 0 ]; then
  echo "🚀 Installing ALL skills..."
  echo ""
  
  # List all skills from the repository
  echo "  📋 Listing available skills..."
  
  skills=()
  while IFS= read -r line; do
    name=$(echo "$line" | grep -o '"name":"[^"]*"' | cut -d'"' -f4)
    type=$(echo "$line" | grep -o '"type":"[^"]*"' | cut -d'"' -f4)
    if [ "$type" = "dir" ] && [ -n "$name" ]; then
      skills+=("$name")
    fi
  done < <(curl -fsSL "$API_URL?ref=$BRANCH" | tr '}' '\n')
  
  if [ ${#skills[@]} -eq 0 ]; then
    # Fallback to known skills if API fails
    skills=("agenticflow-agent" "agenticflow-workforce" "agenticflow-mcp" "agenticflow-llm-models" "agenticflow-built-in-credits")
    echo "  ⚠️  Could not fetch from API, using built-in list"
  fi
  
  for skill in "${skills[@]}"; do
    install_skill "$skill"
  done
else
  # Install specific skill(s)
  for skill_name in "$@"; do
    install_skill "$skill_name"
  done
fi

echo ""
echo "✅ Done! Skills installed to: $TARGET_DIR"
echo ""
echo "🎯 Next steps:"
echo "    1. Make sure you have the AgenticFlow CLI: npm install -g @pixelml/agenticflow-cli"
echo "    2. Run: af bootstrap --json"
echo "    3. Check your AI tool docs for how to load local skills"
echo ""
echo "📚 Read more: https://github.com/${REPO}"
