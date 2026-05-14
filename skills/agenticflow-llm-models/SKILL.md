---
name: agenticflow-llm-models
description: "List, filter, and recommend LLM models available in the AgenticFlow AI workspace for use in agents and workforce nodes. Should trigger whenever the user mentions LLM models, choosing a provider/model for an agent, model capabilities (reasoning, speed, cost), model selection for specific tasks, or understanding which models are available and their trade-offs. Use the live `af get /models` as the authoritative source. The rest of this skill provides recommendations and context but never overrides the live response."
compatibility: Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI
metadata:
  author: Anton Gulin (https://github.com/antongulin)
  version: "4.0.0"
  license: MIT
triggers:
  - "what models are available"
---

> **Author**: Anton Gulin · **Tool**: [opencode-skill-creator](https://github.com/antongulin/opencode-skill-creator) · **GitHub**: [@antongulin](https://github.com/antongulin) · **Registry**: [skills.sh](https://www.skills.sh/docs)


# AgenticFlow LLM Models

Choose the right model for your agent based on capability needs, speed requirements, and reasoning depth. Use built-in credits for all models listed here.

## When NOT to use this skill

Use `agenticflow-built-in-credits` skill instead for pricing, credits, or billing questions. Use `agenticflow-mcp` skill if they need external API keys (BYOK). This skill covers model selection and capabilities, not account management or credit usage.

## Orient first

```bash
af bootstrap --json
```

Extract `models[]` — this is the **source of truth** for available models in your workspace. Never hardcode model lists; they change between CLI releases and backend deployments. The models below are recommendations, but the live `models[]` array is the final authority.

## Discover & health

```bash
af changelog --json           # What's new in the CLI — model additions/removals
af context --json              # AI agent orientation, env vars, invocation guidance
af bootstrap --strict --json   # Health check — exits non-zero if degraded
```

`af bootstrap` returns an `invocation` block and `data_fresh` boolean. If `data_fresh: false`, the backend is degraded — don't rely on stale model data from a degraded response. `af bootstrap --strict` exits non-zero when the backend is unhealthy, so CI/automation can abort before choosing models against a degraded workspace.

> **Verification rule:** Before recommending any model, check `models[]` from `af bootstrap --json`. If a model is absent from that list, warn the user and fall back to a confirmed model.

---

## Author's Top 3 Recommendations

These are the author's personal picks based on reliability, reasoning quality, and speed:

| Rank | Model | Role | Why |
|------|-------|------|-----|
| 1st | `deepseek-v4-flash` | **Primary default** | Best all-rounder — strong reasoning, reliable tool use, good speed. Replaces the older GLM 4.7 Flash default. |
| 2nd | `gemini-2.5-flash-lite` | **Fallback / media** | Fastest option with media support. Use when speed matters more than reasoning depth. |
| 3rd | `qwen-3.5-flash` | **Deep verification** | Deepest thinker — use when reasoning depth and verification matter most. |

> **Note:** `deepseek-v4-flash` and `gemini-2.5-flash-lite` may not appear in every CLI release's hardcoded `KNOWN_MODELS` list if they ship between releases. Always verify against `af bootstrap --json > models[]`. If absent, the backend may still serve them — proceed with a dry-run to confirm.

---

## Upstream Canonical Models

The CLI's built-in validator recognizes these models as of v1.10.5. They are always safe to use:

```
agenticflow/deepseek-v3.2
agenticflow/gemma-4-31b-it
agenticflow/gemma-4-26b-a4b-it
agenticflow/gemini-2.0-flash
agenticflow/gpt-4o-mini
agenticflow/qwen-3.5-flash
```

### Model characteristics

| Model | Speed | Reasoning | Best for |
|-------|-------|-----------|----------|
| `agenticflow/deepseek-v3.2` | Medium | Strong | Reliable reasoning, good tool use |
| `agenticflow/gemma-4-31b-it` | Fast | Light | General purpose, high-volume |
| `agenticflow/gemma-4-26b-a4b-it` | Fast | Light | General purpose, slightly smaller context |
| `agenticflow/gemini-2.0-flash` | Fast | Light | **Deprecated** — still served but being replaced by 2.5 Flash Lite |
| `agenticflow/gpt-4o-mini` | Fast | Light | **Default for blueprints** (v1.8.1+) — follows system prompts reliably, good for tool calling |
| `agenticflow/qwen-3.5-flash` | Medium-Deep | Very strong | Deep verification, complex reasoning |

### Default model change (v1.8.1+)

- **Before v1.8.1:** Default was `agenticflow/gemini-2.0-flash`
- **After v1.8.1:** Default is `agenticflow/gpt-4o-mini`
- **Reason for change:** Gemini 2.0 Flash refuses `web_search` on "latest X" prompts citing knowledge cutoff, even with explicit system prompt rules. GPT-4o-mini follows system prompts and calls tools reliably.

---

## Model selection guide

**Need a default?**
```bash
# Author's primary recommendation — deepseek-v4-flash
af agent create --body '{"name":"My Agent","model":"deepseek-v4-flash","project_id":"<id>"}' --json

# Or use the upstream blueprint default — gpt-4o-mini
af agent create --body '{"name":"My Agent","model":"agenticflow/gpt-4o-mini","project_id":"<id>"}' --json

# For maximum speed with media support
af agent create --body '{"name":"My Agent","model":"gemini-2.5-flash-lite","project_id":"<id>"}' --json
```

**Need reasoning?**
- Deep verification: `qwen-3.5-flash` — deepest thinker
- Reliable tool use + reasoning: `deepseek-v3.2` or `deepseek-v4-flash`

**Need speed only?**
- Fastest correct: `gpt-4o-mini` or `gemma-4-31b-it`

---

## Workforce model selection

All agents in a workforce inherit the model:
```bash
# Default (v1.8.1+)
af workforce init --blueprint dev-shop --model agenticflow/gpt-4o-mini --name "My Team" --json

# Or use author's primary pick
af workforce init --blueprint dev-shop --model deepseek-v4-flash --name "My Team" --json
```

---

## Reasoning configuration

Expose reasoning tokens (where supported):
```bash
af schema agent --field model_user_config --json
```

Check the full agent schema (for all fields):
```bash
af schema agent --json
```

For models with hidden reasoning (e.g. some Gemini variants), configure via `thinking_config` to expose reasoning tokens.

---

## Verify model availability

```bash
# Always dry-run first
af agent create --body @agent.json --dry-run --json
```

The CLI validates the model string at create time. Typos fail fast with an actionable hint listing known models. If you pass a `vendor/model-name`-shaped string not in the known list, the CLI warns but allows it to proceed — so brand-new models work before the CLI is updated.

---

## Avoid these models

Based on upstream changelog and known issues:

| Model | Issue |
|-------|-------|
| `agenticflow/gemini-2.0-flash` | Deprecated, replaced by 2.5 Flash Lite. Still served but default changed to gpt-4o-mini. |
| `agenticflow/gemini-2.0-flash-lite` | Deprecated, replaced by 2.5 Flash Lite |

> In general, if a model is absent from `af bootstrap --json > models[]`, it may have been deprecated or renamed. Check the `hint` field on 400/422 errors for alternatives.

---

## Fallback model guide

If your preferred model is unavailable:

1. Run `af bootstrap --json` and check `models[]`
2. Pick the closest match from the confirmed list above
3. Use `--dry-run` on create to validate before deploying
4. For reasoning-heavy tasks: fall back to `qwen-3.5-flash` or `deepseek-v3.2`
5. For speed-first tasks: fall back to `gpt-4o-mini` or `gemma-4-31b-it`

---

## Cleanup

Test agents consume credits. Delete when done:
```bash
af agent delete --agent-id <id> --json
```

---

## On errors

- **400 / Invalid model** → Check `models[]` from bootstrap; model may have been renamed or is not yet in the CLI's hardcoded list. Try `--dry-run` first.
- **402 / Payment Required** → Model requires credits; see `agenticflow-built-in-credits` skill
- **422 / Model not available** → Model temporarily unavailable; the `hint` suggests alternatives
- **finish_reason=length** → Increase `max_tokens` in `model_user_config`

When `hint` is non-empty, follow it before retrying.
