# AgenticFlow AI Skills

A curated collection of open-source SKILL.md files for [AgenticFlow AI](https://agenticflow.ai).

These skills teach AI coding agents (Claude Code, Cursor, Codex, Gemini CLI) how to use the AgenticFlow platform effectively — from single agents to multi-agent workforces, MCP tool integration, model selection, and credits-first best practices.

## Skills

| Skill | Description | Author |
|-------|-------------|--------|
| [agenticflow-agent](skills/agenticflow-agent/SKILL.md) | Create, run, and iterate on single agents | PixelML |
| [agenticflow-workforce](skills/agenticflow-workforce/SKILL.md) | Deploy and operate multi-agent workforces | PixelML |
| [agenticflow-mcp](skills/agenticflow-mcp/SKILL.md) | Attach external tool providers (Sheets, Slack, Notion, etc.) | PixelML |
| [agenticflow-llm-models](skills/agenticflow-llm-models/SKILL.md) | Model selection and recommendation guide | Anton Gulin |
| [agenticflow-built-in-credits](skills/agenticflow-built-in-credits/SKILL.md) | Credits-first philosophy and BYOK decision framework | Anton Gulin |

## Quick Start

Install all skills into your AI tool's skill directory:

```bash
# For Claude Code / ~/.claude/skills/
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash

# For other tools, copy the skill folders manually
cp -r skills/* ~/.claude/skills/
```

Or install a single skill:

```bash
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent
```

## Requirements

- [AgenticFlow CLI](https://www.npmjs.com/package/@pixelml/agenticflow-cli) (`af`) — `npm install -g @pixelml/agenticflow-cli`
- An AgenticFlow AI account — [app.agenticflow.ai](https://app.agenticflow.ai)

## License

MIT — see individual SKILL.md files for full license and metadata.

## Contributing

1. Fork this repo
2. Add or edit a skill in `skills/<name>/SKILL.md`
3. Follow the existing YAML frontmatter and markdown style
4. Open a PR

## Support

- AgenticFlow docs: [docs.agenticflow.ai](https://docs.agenticflow.ai)
- CLI issues: [github.com/PixelML/agenticflow-cli](https://github.com/PixelML/agenticflow-cli)
- Community: [github.com/antongulin/agenticflow-ai-skills/discussions](https://github.com/antongulin/agenticflow-ai-skills/discussions)
