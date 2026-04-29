---
name: agenticflow-llm-models
description: "Select and configure LLM models for AgenticFlow agents and workforces. Use this skill whenever the user asks which model to use, needs reasoning capabilities, wants fast/cheaper options, gets finish_reason=length errors, or asks about model speed/quality/intelligence trade-offs. Covers the top 5 recommended models, models to avoid, reasoning configuration, and max_tokens settings."
compatibility: Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI
metadata:
  author: Anton Gulin (https://github.com/antongulin)
  version: "1.0.0"
  license: MIT
---

# AgenticFlow LLM Models

Choose the right model for your agent based on capability needs, speed requirements, and reasoning depth. Use built-in credits for all models listed here.

## When NOT to use this skill

Use `agenticflow-built-in-credits` skill instead for pricing, credits, or billing questions. Use `agenticflow-mcp` skill if they need external API keys (BYOK). This skill covers model selection and capabilities, not account management or credit usage.

## Orient first

```bash
af bootstrap --json
```

Extract `models[]` — this is the source of truth for available models. Never hardcode model lists; they change between CLI releases.

## Top 5 recommended models

Based on speed, reasoning quality, and reliability:

| Model | Speed | Reasoning | Best for |
|-------|-------|-----------|----------|
| `agenticflow/glm-4.7-flash` | 18s | 931 tokens | Default choice — reasoning, tools, best all-rounder |
| `agenticflow/gemini-2.5-flash-lite` | 13s | Hidden by default | Fastest, media support, good fallback |
| `agenticflow/gpt-5-nano` | 19s | 1,792 tokens | Reasoning + vision, needs max_tokens ≥ 4000 |
| `agenticflow/qwen-3.5-flash` | 33s | 5,016 tokens | Deep verification, deepest thinker |
| `agenticflow/deepseek-v3.2-speciale` | 51s | 1,308 tokens | Heavyweight reasoning, high intelligence |

## Fast non-reasoning models

For simple tasks where speed matters most:

| Model | Speed | Best for |
|-------|-------|----------|
| `agenticflow/gpt-4o-mini` | 6s | Simple agents, high-volume |
| `agenticflow/gemma-4-31b-it` | 7s | General purpose, correct |
| `agenticflow/gemma-4-26b-a4b-it` | 8s | General purpose, correct |

## Model selection guide

**Need a default?**
```bash
# Start with GLM-4.7 Flash — best all-rounder with reasoning
af agent create --body '{"name":"My Agent","model":"agenticflow/glm-4.7-flash","project_id":"<id>"}' --json

# If you need maximum speed and don't need reasoning, use Gemini 2.5 Flash Lite
af agent create --body '{"name":"My Agent","model":"agenticflow/gemini-2.5-flash-lite","project_id":"<id>"}' --json
```

**Need reasoning?**
- Default reasoning: `glm-4.7-flash` (18s, 931 tokens) — already the default above
- Vision + reasoning: `gpt-5-nano` (19s)
- Deep verification: `qwen-3.5-flash` (33s, 5K reasoning tokens)
- Maximum reasoning: `deepseek-v3.2-speciale` (51s)

**Need speed only?**
- Fastest correct: `gpt-4o-mini` (6s)
- Fast + large context: `gemma-4-31b-it` (7s)

## Workforce model selection

All agents in a workforce inherit the model:
```bash
af workforce init --blueprint dev-shop --model agenticflow/glm-4.7-flash --name "My Team" --json
```

## Reasoning configuration

Expose reasoning tokens (where supported):
```bash
af schema agent --field model_user_config --json
```

Check the full agent schema (for all fields):
```bash
af schema agent --json
```

For Gemini 2.5 Flash Lite, reasoning is hidden by default. Configure via `thinking_config` to expose.

## Verify model availability

```bash
# Always dry-run first
af agent create --body @agent.json --dry-run --json
```

The CLI validates the model string at create time. Typos fail fast with an actionable hint listing known models.

## Avoid these models

Based on benchmark testing (April 2026):

| Model | Issue |
|-------|-------|
| `agenticflow/claude-3-5-haiku` | Fast (4s) but wrong on reasoning tasks. Use for writing only, never logic. |
| `agenticflow/gemini-2.0-flash` | Deprecated, replaced by 2.5 Flash Lite |
| `agenticflow/gemini-2.0-flash-lite` | Deprecated, replaced by 2.5 Flash Lite |
| `agenticflow/google-gemini-1.5-flash` | Legacy, may be deprecated |
| `agenticflow/gpt-oss-120b` | Intermittent failures (Groq backend issues) |
| `agenticflow/gpt-oss-20b` | Intermittent failures |

## Fallback reasoning models

If top 5 unavailable:

| Model | Speed | Notes |
|-------|-------|-------|
| `agenticflow/qwen-3.5-9b` | 41s | Flaky (finish_reason=error despite correct reasoning) |
| `agenticflow/glm-4.5-air` | 48s | Needs max_tokens ≥ 4000 or truncates |
| `agenticflow/deepseek-v3.2` | 55s | Works but slower than Speciale |
| `agenticflow/deepseek-v3.2-exp` | 29s | Correct without exposing reasoning tokens |

## Cleanup

Test agents consume credits. Delete when done:
```bash
af agent delete --agent-id <id> --json
```

## On errors

- **400 / Invalid model** → Check `models[]` from bootstrap; model may have been renamed
- **402 / Payment Required** → Model requires credits; see `agenticflow-built-in-credits` skill
- **422 / Model not available** → Model temporarily unavailable; the `hint` suggests alternatives
- **finish_reason=length** → Increase `max_tokens` (especially for GPT-5 Nano and GLM-4.5 Air)

When `hint` is non-empty, follow it before retrying.
