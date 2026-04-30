# AgenticFlow AI Skills — Installer

Universal installer for AgenticFlow AI skills. Works with all 5 supported AI coding tools.

## One-command install (recommended)

Copy and paste into your terminal **from your project directory**:

```bash
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash
```

This installs **all 5 skills** into the correct directory for your AI tool. The script auto-detects:

| AI Tool | Installs to |
|---------|-------------|
| Claude Code | `.claude/skills/` |
| Cursor | `.cursor/skills/` |
| OpenCode | `.opencode/skills/` |
| Codex | `.codex/skills/` |
| Gemini CLI | `.gemini/skills/` |

If auto-detection fails, you can tell it where to install:

```bash
SKILLS_DIR=./skills curl -fsSL ... | bash
# or
SKILLS_DIR=~/.claude/skills curl -fsSL ... | bash
```

## Install a single skill

```bash
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent
```

Available skill names:
- `agenticflow-agent` — single agent lifecycle
- `agenticflow-workforce` — multi-agent teams
- `agenticflow-mcp` — external tool integration
- `agenticflow-llm-models` — model selection guide
- `agenticflow-built-in-credits` — credits-first approach

## Manual install

Choose your tool, create the folder, download the file:

**Claude Code**
```bash
mkdir -p .claude/skills/agenticflow-agent
curl -o .claude/skills/agenticflow-agent/SKILL.md \
  https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills/agenticflow-agent/SKILL.md
```

**Cursor**
```bash
mkdir -p .cursor/skills/agenticflow-agent
curl -o .cursor/skills/agenticflow-agent/SKILL.md \
  https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills/agenticflow-agent/SKILL.md
```

**OpenCode**
```bash
mkdir -p .opencode/skills/agenticflow-agent
curl -o .opencode/skills/agenticflow-agent/SKILL.md \
  https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills/agenticflow-agent/SKILL.md
```

**Codex**
```bash
mkdir -p .codex/skills/agenticflow-agent
curl -o .codex/skills/agenticflow-agent/SKILL.md \
  https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills/agenticflow-agent/SKILL.md
```

**Gemini CLI**
```bash
mkdir -p .gemini/skills/agenticflow-agent
curl -o .gemini/skills/agenticflow-agent/SKILL.md \
  https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills/agenticflow-agent/SKILL.md
```

Swap `agenticflow-agent` with any other skill name: `agenticflow-workforce`, `agenticflow-mcp`, `agenticflow-llm-models`, `agenticflow-built-in-credits`.

## Send a link to your AI agent

If your AI tool supports link-sharing, send this URL and ask your agent to install:

```
https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh
```

The agent will run the install script and configure the skills.

## From source

```bash
git clone https://github.com/antongulin/agenticflow-ai-skills.git
cd agenticflow-ai-skills
bash skills.sh
```

## Updating

Run the install script again — it overwrites existing skills with the latest versions.

## Requirements

- [AgenticFlow CLI](https://www.npmjs.com/package/@pixelml/agenticflow-cli): `npm install -g @pixelml/agenticflow-cli`
- AgenticFlow account: [app.agenticflow.ai](https://app.agenticflow.ai)

## License

MIT
