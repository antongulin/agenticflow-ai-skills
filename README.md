# AgenticFlow AI Skills

[![skills.sh](https://skills.sh/b/antongulin/agenticflow-ai-skills)](https://skills.sh/antongulin/agenticflow-ai-skills)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

AI agent skills for [AgenticFlow AI](https://agenticflow.ai) — create agents, deploy teams, connect tools, pick models, and manage credits.

> **Author**: Anton Gulin · **Tool**: [opencode-skill-creator](https://github.com/antongulin/opencode-skill-creator) · **GitHub**: [@antongulin](https://github.com/antongulin) · **Registry**: [skills.sh](https://www.skills.sh/docs)

Skills package providing AI coding assistants with structured instructions for using the AgenticFlow AI platform. No coding required — copy one command, paste it into your terminal, and your AI assistant learns to build agents, teams, connect tools, pick models, and manage credits.

## Skills

### [agenticflow-agent](/skills/agenticflow-agent)

Create, run, and iterate on a single AI agent — chatbots, support assistants, prompt experiments. Covers `af agent create/update/run/delete`, the `--patch` partial-update pattern, schema inspection, and safe iteration loops.

*Author: PixelML*

### [agenticflow-workforce](/skills/agenticflow-workforce)

Deploy multi-agent teams that hand off to each other — dev shops, marketing agencies, sales pipelines, content studios. Covers `af workforce *`, blueprint decisions, graph wiring, MCP attach recipes, and public URL publishing.

*Author: PixelML*

### [agenticflow-mcp](/skills/agenticflow-mcp)

Attach external tool providers (Google Docs, Google Sheets, Slack, Notion, GitHub, Apify) to an agent via MCP clients. Covers `af mcp-clients list/inspect`, Pipedream vs Composio distinction for parametric writes.

*Author: PixelML*

### [agenticflow-built-in-credits](/skills/agenticflow-built-in-credits)

Purchase and manage built-in credits — the prepaid balance for agent and workforce runs. Covers `af credit purchase/receipts/usage/plans`, auto-recharge, payment card setup via `af setup`, and usage monitoring.

*Author: Anton Gulin*

### [agenticflow-llm-models](/skills/agenticflow-llm-models)

List, filter, and recommend LLM models available in your workspace. Uses the live `af get /models` as the authoritative source. Covers reasoning vs speed trade-offs, cost comparisons, and model selection for specific tasks.

*Author: Anton Gulin*

## Installation

### Using the Skills CLI (recommended)

```bash
npx skills add antongulin/agenticflow-ai-skills --all
```

This installs all 5 skills automatically. Works with 50+ AI coding tools including Claude Code, Cursor, OpenCode, Codex, and Gemini CLI.

**Install a specific skill:**
```bash
npx skills add antongulin/agenticflow-ai-skills --skill agenticflow-agent
```

**Global scope (all projects):**
```bash
npx skills add antongulin/agenticflow-ai-skills --global
```

**Preview before installing:**
```bash
npx skills add antongulin/agenticflow-ai-skills --list
```

### Manual

Clone the repo and copy the skills to your agent's skills path:

```bash
git clone https://github.com/antongulin/agenticflow-ai-skills.git
cp -r agenticflow-ai-skills/skills/* <agent-skills-path>/
```

Replace `<agent-skills-path>` with your agent's skills directory. Common paths:

| Agent | Path |
|-------|------|
| Universal | `~/.agents/skills/` |
| OpenCode | `~/.config/opencode/skills/` |
| Claude Code | `~/.claude/skills/` |
| GitHub Copilot | `~/.copilot/skills/` |
| Cursor | `~/.cursor/skills/` |
| Gemini CLI | `~/.gemini/skills/` |
| Codex | `~/.codex/skills/` |
| Cline | `~/.agents/skills/` |

See the [manual install guide](INSTALL.md) for detailed setup instructions.

## Requirements

You need two things (both free to start):

1. **AgenticFlow CLI** — `npm install -g @pixelml/agenticflow-cli`
2. **AgenticFlow account** — [app.agenticflow.ai](https://app.agenticflow.ai)

No API keys needed to get started.

## Try these prompts

After installing, ask your AI agent:

- "Create a customer support agent for my website"
- "Deploy a dev shop team with CEO, engineer, and QA agents"
- "Connect my agent to Google Sheets so it can log outputs"
- "What's the best model for deep reasoning tasks?"
- "I want to generate an image using my existing credits"
- "Export all my agents so I can move them to another workspace"

## Compatibility

Skills are compatible with AI coding assistants that support the [skills.sh](https://www.skills.sh/docs) skill format, including OpenCode, Claude Code, Copilot CLI, Cursor, Codex, Cline, Gemini CLI, and 50+ others.

## Related

- [AgenticFlow AI](https://agenticflow.ai) — The platform these skills support
- [AgenticFlow CLI](https://github.com/PixelML/agenticflow-cli) — CLI source
- [AgenticFlow docs](https://docs.agenticflow.ai) — Official documentation
- [mole-skills](https://github.com/antongulin/mole-skills) — macOS system maintenance skills by the same author
- [bundle-social-api-skill](https://github.com/antongulin/bundle-social-api-skill) — Bundle.social API skills by the same author
