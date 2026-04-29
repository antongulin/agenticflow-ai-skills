---
name: agenticflow-built-in-credits
description: "Use AgenticFlow's built-in features and account credits first — before adding external API keys (BYOK). Use this skill whenever the user asks about image generation without API keys, wants to use their existing credits, asks about built-in vs BYOK, or mentions agenticflow_generate_image, web_search, web_retrieval, or credit-efficient workflows. BYOK is only for extension when unsatisfied or explicitly requested."
compatibility: Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI
metadata:
  author: Anton Gulin (https://github.com/antongulin)
  version: "1.0.0"
  license: MIT
---

# AgenticFlow: Credits-First Approach

**Primary Philosophy:** Use your **existing account credits** with built-in features  
**Extension Path:** BYOK (Bring Your Own Key) only if unsatisfied or explicitly requested  
**Goal:** Spend your available credits first, upgrade only when needed

---

## When NOT to use this skill

If the user explicitly wants to use external API keys (BYOK) like DALL-E, Stable Diffusion, or OpenAI, use `agenticflow-mcp` skill instead. If they need specific model recommendations or want to compare available models, use `agenticflow-llm-models` skill. This skill is for users who want to maximize their existing account credits first.

## Orient first

```bash
af bootstrap --json
```

From the response, extract:

- `auth.workspace_id` — your workspace identifier
- `models[]` — available models that consume credits (source of truth, don't hardcode)
- `agents[]` — existing agents to avoid duplication
- `_links.workspace` — **surface this URL to the user right away**: *"Your workspace is at `<_links.workspace>` — open it anytime to see what I'm building."*

If `data_fresh: false` in the response, the backend is degraded — **do not mutate**. Fix auth/network before proceeding.

---

## Primary Philosophy: Credits-First

### DEFAULT: Use Your Existing Credits

**When using this skill, the DEFAULT approach is:**
1. **Start with a blueprint** — `af agent init --blueprint <id>` (never create from scratch if a blueprint exists)
2. Use built-in nodes that consume your **existing account credits**
3. Leverage `agenticflow_generate_image` (PixelML backend)
4. Use `llm`, `web_search`, `web_retrieval` (built-in)
5. Deploy blueprints: `content-creator`, `research-assistant`, `research-pair`

> Blueprint first, custom agent second. If the user needs image generation, use `af agent init --blueprint content-creator`. If they need research, use `af agent init --blueprint research-assistant`. Only create a custom agent with `af agent create --body '...'` if no blueprint fits the use case.

### EXTENSION: BYOK Only When Needed

**Only consider BYOK (external API keys) if:**
- You're **NOT satisfied** with built-in results
- User **explicitly requests** specific providers (DALL-E, SD, etc.)
- You need to **extend** beyond built-in capabilities

---

## TL;DR — Built-In First, Extend Later

### Phase 1: Use These (Your Existing Credits)

| Node Type | Category | Typical Credits/Run | Status |
|-----------|----------|---------------------|--------|
| `agenticflow_generate_image` | **Image** | 10-30 | **PRIMARY** - Use this first |
| `llm` / `pml_llm` | **Text** | 1-40 | Built-in, use freely |
| `web_search` | **Research** | 1-5 | Built-in, use freely |
| `web_retrieval` | **Research** | 1-5 | Built-in, use freely |

### Phase 2: Extension (Only If Unsatisfied)

| Node Type | Why Extend | Requires |
|-----------|------------|----------|
| `generate_image` + DALL-E | Better photorealism | BYOK - OpenAI API key |
| `generate_image` + Stable Diffusion | More artistic control | BYOK - SD API key |
| `openai_*` nodes | Specific OpenAI features | BYOK - OpenAI API key |

---

## The Decision Framework (Inspect Before Extend)

> **The Golden Rule:** Never jump to BYOK as the first option. Always try built-in first.

### BEFORE Using Any External API Key, Ask:

```
1. Did I try the built-in version first? (agenticflow_generate_image)
   └─ If NO → Use built-in first

2. Am I satisfied with the built-in results?
   └─ If YES → Stick with built-in, save external costs

3. Does the user EXPLICITLY request a specific provider?
   └─ If NO → Stay with built-in

4. Is the unsatisfactory result a blocker?
   └─ If NO → Accept and iterate with prompts
   └─ If YES → Consider BYOK extension
```

---

## Verified Built-In Features (Use Your Credits)

### Rung 0-2: Workflow Blueprints (Start Here)

```bash
# DEFAULT: These use YOUR credits only, no setup needed
af workflow init --blueprint llm-hello --json        # ~1-5 credits
af workflow init --blueprint llm-chain --json        # ~2-10 credits
af workflow init --blueprint summarize-url --json    # ~3-15 credits
af workflow init --blueprint api-summary --json      # ~3-15 credits
```

### Rung 3: Agent Blueprints (Credits-First)

When a user needs image generation or research, **always prefer blueprints over custom agents**. Blueprints are pre-configured with the right built-in nodes.

```bash
# DEFAULT: These agents use YOUR existing credits
af agent init --blueprint research-assistant --json  # web_search, web_retrieval
af agent init --blueprint content-creator --json     # agenticflow_generate_image
af agent init --blueprint api-helper --json          # api_call, string_to_json
```

Only create custom agents if no blueprint fits the user's use case.

**Always preview with `--dry-run` first:**
```bash
af agent init --blueprint content-creator --dry-run --json
af agent init --blueprint content-creator --json
```

### Rung 6: Workforce Blueprints (Credits-First)

```bash
# DEFAULT: Multi-agent using YOUR credits only
af workforce init --blueprint research-pair --json   # web_search + web_retrieval
af workforce init --blueprint content-duo --json     # verify: uses YOUR credits
af workforce init --blueprint api-pipeline --json     # api_call
af workforce init --blueprint fact-check-loop --json # web_retrieval
af workforce init --blueprint parallel-research --json # web_search
```

---

## Extension Path: When to Consider BYOK

### Scenario 1: User Explicitly Requests

**User says:** *"I want this specific image from DALL-E 3"*

**Action:**
```bash
# User explicitly requested DALL-E
# → Load agenticflow-mcp skill for BYOK connection setup
# → Go to UI → Connections → Add OpenAI API key
# → Use generate_image with provider=dall-e
```

> When the user needs BYOK, **load the `agenticflow-mcp` skill** for detailed connection setup instructions.

### Scenario 2: Unsatisfactory Results

**After 3 iterations with built-in:** *"Image quality isn't good enough for this use case"*

**Action:**
```bash
# Try improving prompts first
# If still unsatisfied → Load agenticflow-mcp skill for BYOK upgrade
```

### Scenario 3: Feature Not Available Built-In

**Need:** *"GPT-4 vision analysis"* (not available in built-in)

**Action:**
```bash
# Feature genuinely requires external provider
# → Add API key for that specific feature only
```

---

## Managing Your Credit Spending

### Credit-Efficient Workflow (Credits-First)

**Step 1: Low-cost validation**
```bash
# Use cheap LLM to validate concept
af workflow init --blueprint llm-hello --json
# ~1-5 credits to test the idea
```

**Step 2: Built-in generation**
```bash
# Use agenticflow_generate_image for actual output
af agent run --agent-id <content-creator> --message "Create image..."
# ~10-30 credits
```

**Step 3: Evaluate results**
- **Satisfied?** → Done! Stick with built-in.
- **Not satisfied?** → Ask: iterate prompts OR extend to BYOK?

**Step 4: Extension (only if justified)**
```bash
# Only if built-in truly insufficient
# Add connection in UI, use external provider
# Factor in external API costs + AgenticFlow credits
```

### Cost Comparison Example

| Approach | Image Cost | External Cost | Total |
|----------|------------|-----------------|-------|
| Built-in (agenticflow) | 20 credits | $0 | Just credits |
| BYOK (DALL-E) | 20 credits | ~$0.02-0.04 | Credits + API cost |
| BYOK (SD API) | 20 credits | ~$0.01-0.02 | Credits + API cost |

**Recommendation:** Only pay extra if built-in truly insufficient.

---

## Prompt Engineering Before BYOK

### Try These Before Upgrading

**Built-in image quality not good?**
```
# Try better prompts first:
"High resolution, detailed, professional photography style,
8k, sharp focus, studio lighting..."

# Try different aspect ratios
# Try negative prompts
# Try multiple generations and pick best
```

**Still not satisfied after 3-5 prompt iterations?**  
→ **Then** consider BYOK extension.

---

## The ANTI-Patterns (Don't Do This)

### Wrong Approach
```
User: "I need an image"
→ Immediately: "Let me set up DALL-E API key"
```

### Correct Approach
```
User: "I need an image"
→ "I'll use your existing credits with built-in generation first.
    If you're not satisfied with results, we can upgrade to DALL-E."
→ Generate with agenticflow_generate_image
→ Evaluate: Satisfied? Done. Not satisfied? Discuss extension.
```

---

## Verifying Credits-Only Operation

### Confirm You're Using Built-In

```bash
# Check workflow nodes (should be agenticflow_* or built-ins)
af workflow get --workflow-id <id> --json | jq '.nodes[].type'

# SAFE types (your credits only):
# agenticflow_generate_image
# llm, pml_llm
# web_search, web_retrieval

# EXTENSION types (verify before using):
# generate_image (check provider setting)
# openai_generate_image (BYOK required)
```

### Check Before Creating

```bash
# ALWAYS inspect before deploying
af schema agent --field mcp_clients --json
af agent init --blueprint <id> --dry-run --json
```

---

## Smoke Test After Deploy

```bash
# Verify built-in features work with your credits
af agent run --agent-id <id> --message "Generate a simple test image" --json
# Expect: status "completed" and actual credit consumption (not external API call)
```

---

## Cleanup

Resources consume credits while running. Delete test deploys:

```bash
af agent delete --agent-id <id> --json
af workforce delete --workforce-id <id> --json
```

Both return `{"schema":"agenticflow.delete.v1","deleted":true,"id":"...","resource":"..."}` on success.

---

## Summary: The Credits-First Checklist

When user asks for anything:

- [ ] **Try built-in first** (agenticflow_generate_image, llm, web_search)
- [ ] **Use YOUR existing credits** (check `af bootstrap --json`)
- [ ] **Iterate with prompts** before considering alternatives
- [ ] **Evaluate satisfaction** after built-in results
- [ ] **Only if unsatisfied OR explicit request** → Discuss BYOK extension
- [ ] **Never default to BYOK** as first option

---

## Quick Reference: Default vs Extension

| Request | DEFAULT (Credits-First) | Extension (BYOK) |
|---------|-------------------------|------------------|
| "Generate image" | `agenticflow_generate_image` | Only if unsatisfied → DALL-E/SD |
| "Write blog post" | `llm` node | Only if need GPT-4 specifically |
| "Research topic" | `web_search` + `web_retrieval` | Only if need specific APIs |
| "Create video" | `create_video` (verify) | Only if need advanced editing |
| "Any task" | Built-in blueprints | Only for specific provider features |

---

## Related Skills

| Load This Skill | When You Need |
|-----------------|---------------|
| `agenticflow-agent` (official) | Single agent operations |
| `agenticflow-workforce` (official) | Multi-agent orchestration |
| `agenticflow-mcp` (official) | **Extension**: External connections |
| `agenticflow-llm-models` | Model selection and comparison |
| **THIS SKILL** | **Credits-first philosophy** |

**Flow:** This skill → Try built-in → (if unsatisfied) → agenticflow-mcp for BYOK setup

---

## On errors

Every API error returns a consistent envelope with an actionable `hint`:

- **402 / Payment Required** → Credits exhausted, check workspace billing
- **429 / Rate Limited** → Too many requests, retry after delay
- **400 / Invalid tool** → Tool not available, check `models[]` from bootstrap
- **404** → Run the matching `list` command to see available IDs (or double-check the ID)
- **422** → Check `details.payload` for field-level errors

When `hint` is non-empty, follow it before retrying.

---

## Philosophy Recap

### The Golden Rule
**"Your existing credits are valuable. Spend them first. Only bring external keys if the built-in path doesn't deliver satisfaction."**

### For Skill Users
1. **Default to built-in** nodes that use your credits
2. **Prompt engineer** before upgrading
3. **Evaluate results** objectively
4. **Extend only when justified** (explicit request or unsatisfactory results)

### For Skill Sharers
This skill teaches the **credits-first mindset**. Share it to help others maximize their existing AgenticFlow investment before adding external costs.

---

**Version:** 1.0.0  
**Philosophy:** Credits-First, Extend Only When Needed  
**Author:** Anton Gulin (https://github.com/antongulin)  
**License:** MIT

---

**Remember:** The built-in features are powerful. Many users never need BYOK. Start with what you have, extend only when you must.
