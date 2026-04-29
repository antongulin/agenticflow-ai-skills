# AgenticFlow AI Skills

> For AI agents using this repository. For human contributors, see [README.md](README.md).

## Repository Overview

This repository publishes 5 open-source SKILL.md files for the AgenticFlow AI platform:

- **`agenticflow-agent`** — Single agent lifecycle (create, patch, run, delete, MCP attach)
- **`agenticflow-workforce`** — Multi-agent team / workforce deployment with blueprints
- **`agenticflow-mcp`** — External tool integration (Sheets, Slack, Notion, GitHub, etc.)
- **`agenticflow-llm-models`** — Model selection guide with top-5 recommendations
- **`agenticflow-built-in-credits`** — Credits-first philosophy and BYOK decision framework

## Install a skill

```bash
# Clone one skill into your project
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent

# Or install all
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash
```

## Skill format

Each skill is a `SKILL.md` file with:
- **YAML frontmatter** — `name`, `description`, `compatibility` (Claude Code, Cursor, Codex, Gemini CLI), `metadata` (author, version, license), and `triggers`
- **Markdown body** — commands, examples, and decision trees for the `af` CLI

## Multi-LLM compatibility

| Skill | Claude Code | Cursor | Codex | Gemini CLI |
|-------|-------------|--------|-------|------------|
| agenticflow-agent | ✅ | ✅ | ✅ | ✅ |
| agenticflow-workforce | ✅ | ✅ | ✅ | ✅ |
| agenticflow-mcp | ✅ | ✅ | ✅ | ✅ |
| agenticflow-llm-models | ✅ | ✅ | ✅ | ✅ |
| agenticflow-built-in-credits | ✅ | ✅ | ✅ | ✅ |

## Contributing

1. Add a new folder under `skills/<skill-name>/`
2. Write `SKILL.md` with valid YAML frontmatter and markdown body
3. Keep skills CLI-command-oriented (all use the `af` CLI)
4. Do not hardcode model lists — always reference `af bootstrap --json`
5. Include `triggers:` in frontmatter so discovery tools know when to activate the skill