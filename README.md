# AgenticFlow AI Skills

Open-source skills that teach AI coding agents how to use [AgenticFlow AI](https://agenticflow.ai).

No coding required. Copy one command, paste it into your terminal, and your AI assistant learns to build agents, teams, connect tools, pick models, and manage credits.

---

## Install (pick your option)

### Option 1 — One command (easiest)

Open your terminal **in your project folder** and run:

```bash
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash
```

This installs all 5 skills. Works with Claude Code, Cursor, OpenCode, Codex, and Gemini CLI.

### Option 2 — Send a link to your AI agent

Copy this URL and send it to your AI coding tool:

```
https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh
```

Your AI agent will read the installer and set up the skills automatically.

### Option 3 — Install one specific skill

```bash
curl -fsSL https://raw.githubusercontent.com/antongulin/agenticflow-ai-skills/main/skills.sh | bash -s -- agenticflow-agent
```

Replace `agenticflow-agent` with any skill name from the table below.

### Option 4 — Manual (one file copy)

Pick your AI tool from the table, create the folder, and download the skill file into it:

| Your tool | Create this folder | Download this file into it |
|-----------|-------------------|---------------------------|
| Claude Code | `.claude/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Cursor | `.cursor/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| OpenCode | `.opencode/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Codex | `.codex/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |
| Gemini CLI | `.gemini/skills/agenticflow-agent/` | [SKILL.md](skills/agenticflow-agent/SKILL.md) |

Repeat for any other skills you want (swap `agenticflow-agent` with `agenticflow-workforce`, `agenticflow-mcp`, `agenticflow-llm-models`, or `agenticflow-built-in-credits`).

[Full install guide →](INSTALL.md)

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

| Tool | Skill location |
|------|---------------|
| Claude Code | `.claude/skills/` or `~/.claude/skills/` |
| Cursor | `.cursor/skills/` |
| OpenCode | `.opencode/skills/` or `~/.config/opencode/skills/` |
| Codex | `.codex/skills/` |
| Gemini CLI | `.gemini/skills/` |

---

## License

MIT

---

## Links

- [AgenticFlow docs](https://docs.agenticflow.ai)
- [CLI source](https://github.com/PixelML/agenticflow-cli)
- [Discussions](https://github.com/antongulin/agenticflow-ai-skills/discussions)
