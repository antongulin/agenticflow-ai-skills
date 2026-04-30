# Manual Installation

> **Preferred method:** Use `npx skills add antongulin/agenticflow-ai-skills` instead. This guide is the fallback for manual setup.

## Step 1: Pick your AI tool

Create the skills folder for your tool:

| Your tool | Create this folder | Download this file into it |
|-----------|-------------------|---------------------------|
| Claude Code | `.claude/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Cursor | `.agents/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| OpenCode | `.agents/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Codex | `.agents/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Gemini CLI | `.agents/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |

## Step 2: Repeat for each skill

Replace `agenticflow-agent` with:
- `agenticflow-workforce`
- `agenticflow-mcp`
- `agenticflow-llm-models`
- `agenticflow-built-in-credits`

That's it. Your AI assistant will automatically discover and use these skills.

## Requirements

- [AgenticFlow CLI](https://www.npmjs.com/package/@pixelml/agenticflow-cli): `npm install -g @pixelml/agenticflow-cli`
- AgenticFlow account: [app.agenticflow.ai](https://app.agenticflow.ai)

## License

MIT
