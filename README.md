# AgenticFlow AI Skills

[![skills.sh](https://skills.sh/b/antongulin/agenticflow-ai-skills)](https://skills.sh/antongulin/agenticflow-ai-skills)
[![License](https://img.shields.io/badge/License-MIT-yellow?style=flat-square)](LICENSE)

Open-source skills that teach AI coding agents how to use [AgenticFlow AI](https://agenticflow.ai).

No coding required. Copy one command, paste it into your terminal, and your AI assistant learns to build agents, teams, connect tools, pick models, and manage credits.

---

## Install

### Option 1 — `npx skills add` (recommended)

Open your terminal **in your project folder** and run:

```bash
npx skills add antongulin/agenticflow-ai-skills --all
```

This installs all 5 skills automatically. Works with 50+ AI coding tools including Claude Code, Cursor, OpenCode, Codex, and Gemini CLI.

#### Install a specific skill

```bash
npx skills add antongulin/agenticflow-ai-skills --skill agenticflow-agent
```

Replace `agenticflow-agent` with any skill name from the table below.

#### Install globally (available across all projects)

```bash
npx skills add antongulin/agenticflow-ai-skills --global
```

#### See what's available before installing

```bash
npx skills add antongulin/agenticflow-ai-skills --list
```

### Option 2 — Manual install

Prefer to set up skills by hand? See the [manual install guide →](INSTALL.md)

---

## What's included

| Skill | What it does | Author |
|-------|-------------|--------|
| **agenticflow-agent** | Create single AI agents — chatbots, support bots, assistants | PixelML |
| **agenticflow-workforce** | Deploy teams of agents that work together — dev shops, marketing teams, sales pipelines | PixelML |
| **agenticflow-mcp** | Connect agents to Google Sheets, Slack, Notion, GitHub, and more | PixelML |
| **agenticflow-llm-models** | Choose the right AI model — speed vs reasoning vs cost | Anton Gulin |
| **agenticflow-built-in-credits** | Use your existing credits first before paying extra for external APIs | Anton Gulin |

---

## After installing — try these

Ask your AI agent any of these:

```
"Create a customer support agent for my website"
"Deploy a dev shop team with CEO, engineer, and QA agents"
"Connect my agent to Google Sheets so it can log outputs"
"What's the best model for deep reasoning tasks?"
"I want to generate an image using my existing credits"
"Export all my agents so I can move them to another workspace"
```

---

## Requirements

You need two things (both free to start):

1. **AgenticFlow CLI** — `npm install -g @pixelml/agenticflow-cli`
2. **AgenticFlow account** — [app.agenticflow.ai](https://app.agenticflow.ai)

No API keys needed to get started.

---

## Supported AI tools

The skills.sh CLI automatically detects your installed agents and supports 50+ coding tools. Here's a quick reference for the most common ones:

| Tool | Skill location |
|------|---------------|
| Claude Code | `.claude/skills/` or `~/.claude/skills/` |
| Cursor | `.agents/skills/` |
| OpenCode | `.agents/skills/` or `~/.config/opencode/skills/` |
| Codex | `.agents/skills/` |
| Gemini CLI | `.agents/skills/` |

---

## License

MIT

---

## Links

- [AgenticFlow docs](https://docs.agenticflow.ai)
- [CLI source](https://github.com/PixelML/agenticflow-cli)
- [Discussions](https://github.com/antongulin/agenticflow-ai-skills/discussions)
