---
name: agenticflow-agent
description: "Create, run, and iterate on a single AgenticFlow AI agent — one chat endpoint, one assistant, one persona. Use when the user wants a customer-facing bot, a support assistant, a single task agent, or a prompt experiment. Choose this skill over agenticflow-workforce when there's no orchestration between roles (no handoff, no coordinator → workers). Covers `af agent create/update/run/delete`, the `--patch` partial-update pattern for iteration, `af schema agent --field <name>` for nested payload shapes (including suggested_messages, mcp_clients, response_format), the `model_user_config` / `code_execution_tool_config` settings, and safe iteration loops."
compatibility: Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI
metadata:
  author: PixelML
  version: "4.0.0"
  license: MIT
triggers:
  - "create an agent"
  - "build an agent"
  - "agent configuration"
  - "system prompt"
  - "support bot"
  - "customer-facing bot"
  - "single agent"
  - "agent persona"
  - "agent update"
  - "patch agent"
  - "iterate on agent"
  - "agent run"
  - "agent delete"
---

# AgenticFlow Agent

A single AI agent with a system prompt, model, optional MCP tool attachments, and an optional code-execution sandbox. Use this when one chat surface + one set of rules is enough.

## When NOT to use this skill

If the user needs **multiple agents that hand off to each other** (research → write, triage → specialist, a pre-built team template), use `agenticflow-workforce` instead. Don't over-engineer — a support bot with "if billing/refunds/privacy, escalate to email" is one agent, not three.

## Orient first

```bash
af bootstrap --json
```

From the response, extract:

- `auth.project_id` — **required** on agent create (server does not auto-inject for agents, unlike workforces)
- `auth.workspace_id`
- `_links.workspace` — **surface this URL to the user right away**: *"Your AgenticFlow workspace is at `<_links.workspace>` — open it anytime to see what I'm building."* Anchors a human-first mental model before any mutation
- `models[]` — use as source of truth for model ids (don't hardcode — they change between CLI releases)
- `agents[]` — so you don't duplicate existing work

If `data_fresh: false` in the response, the backend is degraded — don't mutate. Run `af doctor --json --strict` and fix auth/network first.

## Discovery & health

```bash
af changelog --json           # What's new in the CLI since your last install
af context --json              # AI agent orientation, env vars, invocation guidance
af bootstrap --strict --json   # Health check — exits non-zero if backend degraded
```

`af bootstrap` returns an `invocation` block telling you the correct CLI binary to use. `af bootstrap --strict` exits non-zero when the backend is unhealthy, so CI/automation can abort before mutating against a degraded workspace.

## Inspect payload shape before writing

```bash
af schema agent --json
af schema agent --field mcp_clients --json          # Nested attach shape
af schema agent --field suggested_messages --json   # {title, label, action} — NOT strings
af schema agent --field response_format --json      # Structured output config
af schema agent --field update --json               # Update + null-rejected fields list
```

The `--field` drilldown returns the documented shape for a single field. Use it instead of guessing.

### New fields (v1.10.x)

| Field | Type | What it does |
|-------|------|--------------|
| `welcome_message` | `string` | Greeting shown on new thread |
| `agent_type` | `standard \| autonomous` | Default: `standard` |
| `recursion_limit` | `number (10-500)` | Default: **100** (was 25) |
| `model_user_config` | `{ temperature?, max_tokens?, max_input_tokens?, reasoning_effort? }` | Fine-tune the model |
| `code_execution_tool_config` | `{ enable: bool, enable_file_operations?: bool }` | Python/JS sandbox |
| `file_system_tool_config` | `object \| null` | Enable file system tool |
| `attachment_config` | `object \| null` | File attachment config |
| `response_format` | `object \| null` | Structured output schema (JSON mode) for the final response |
| `knowledge` | `object \| null` | Knowledge base / RAG configuration |
| `skills_config` | `object \| null` | Skill pack configuration |
| `task_management_config` | `object \| null` | Task queue / scheduling |
| `sub_agents` | `array` | Sub-agent configurations for agent teams |
| `plugins` | `array` | Plugin configurations (e.g. `web_search`, `web_retrieval`) |
| `suggested_messages` | `[ { title, label, action } ]` | Pre-populated prompts. **NOT** an array of strings — server rejects strings |

### Null-rejected fields on update

These fields must be **OMITTED** (not sent as `null`) on `af agent update` — the server rejects null:

```
suggest_replies_model, suggest_replies_model_user_config, suggest_replies_prompt_template,
knowledge, task_management_config, recursion_limit,
file_system_tool_config, attachment_config, response_format, skills_config
```

The CLI auto-strips them even without `--patch`. Stripped fields are logged to stderr.

```bash
af schema agent --field update --json   # See the full list
```

## Create (always preview first)

```bash
af agent create --body @agent.json --dry-run --json
af agent create --body @agent.json --json
```

Minimum valid payload:

```json
{
  "name": "My Support Assistant",
  "tools": [],
  "project_id": "<from bootstrap auth.project_id>",
  "model": "agenticflow/gpt-4o-mini",
  "system_prompt": "You are ..."
}
```

> **Default model change:** Since CLI v1.8.1, the upstream default is `agenticflow/gpt-4o-mini` (was `gemini-2.0-flash`). GPT-4o-mini follows system prompts reliably and calls tools without refusing. Use your preferred model via `--model <id>`.
>
> **recursion_limit** defaults to 100 (was 25). If an agent returns `completed_empty`, check if `recursion_limit` was lower.

**Available models** live in `af bootstrap --json > models[]` — always read from there rather than hardcoding a list in your logic (models ship between CLI releases). The CLI validates your model string at create time: typos fail fast with an actionable hint listing the known set. If you pass a `vendor/model-name`-shaped string not in the known list, it warns-but-proceeds so brand-new models work before the CLI is updated.

## Run (smoke test)

```bash
af agent run --agent-id <id> --message "Test prompt" --json
# Returns {response, thread_id, status}.

af agent run --agent-id <id> --thread-id <tid> --message "continue" --json
# Pass the same thread_id to keep conversation context; omit it to start fresh.

af agent run --agent-id <id> --message "Test" --wait --timeout 60 --json
# Polls until terminal status. Exits code 2 if final status is failed/cancelled/error.

af agent stream --agent-id <id> --message "Test" --json
# SSE token-level streaming.
```

### completed_empty (v1.8.2)

The backend sometimes returns `{status: "completed", response: ""}` when the agent exhausts its `recursion_limit` in a tool loop. The CLI now reclassifies this as:

```json
{ "status": "completed_empty", "warning": "..." }
```

**Exit code 2** — bash `&&` chains halt automatically.

**Remediation:**
1. Inspect thread messages: `af agent-threads messages --thread-id <tid> --json`
2. Raise recursion_limit: `af agent update --agent-id <id> --patch --body '{"recursion_limit":100}' --json`
3. Refine prompt to reduce loop depth

**Do NOT** treat `completed_empty` as success — the response is empty.

---

## Get agent (aliases + fields)

```bash
af agent get --agent-id <id> --json              # Canonical
af agent get --id <id> --json                     # Alias (v1.8.1+)
af agent get --id <id> --fields id,name,model --json   # Response projection
```

## Iterate with --patch (the cornerstone pattern)

Never round-trip the full agent body to change one field:

```bash
# WRONG — full-body replace loses attached MCPs / tools / code_exec config if omitted
af agent update --agent-id <id> --body @updated.json

# RIGHT — partial update, everything else preserved
af agent update --agent-id <id> --patch --body '{"system_prompt":"new prompt"}' --json
af agent update --agent-id <id> --patch --body '{"model":"agenticflow/gpt-4o-mini"}' --json
af agent update --agent-id <id> --patch --body '{"mcp_clients":[{"mcp_client_id":"<id>","run_behavior":"auto_run","tools":{}}]}' --json
```

The CLI auto-strips null-rejected fields (`knowledge`, `recursion_limit`, `task_management_config`, `suggest_replies_*`, `file_system_tool_config`, `attachment_config`, `response_format`, `skills_config`). Stripped fields are logged to stderr so bots don't think they cleared a field they didn't.

## Attach an MCP tool provider

See the `agenticflow-mcp` skill for the full inspect-before-attach flow. Short version:

```bash
af mcp-clients list --name-contains "google sheets" --fields id,name --json
af mcp-clients inspect --id <mcp_id> --json
# Only proceed if pattern != "pipedream" with write_capable_tools
af agent update --agent-id <agent_id> --patch --body '{"mcp_clients":[{...}]}' --json
```

## Cleanup

```bash
af agent delete --agent-id <id> --json
# Returns {"schema":"agenticflow.delete.v1","deleted":true,"id":"...","resource":"agent"}
```

## On errors

Every API error returns a consistent envelope with an actionable `hint`. Common 4xx and their hints:

- **404** → "Run the matching `list` command to see available IDs" (or double-check the ID)
- **422** → "Check `details.payload` for field-level errors" (pydantic returns the offending field)
- **401** → "Run `af whoami` / `af login`"

When `hint` is non-empty, follow it before retrying.