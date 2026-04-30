---
name: agenticflow-workforce
description: "Deploy and operate a multi-agent AgenticFlow workforce — a DAG of agents that hand off to each other (trigger → coordinator → worker agents → output). Use when the user asks for a team, pipeline, or multi-agent system: research-then-write, triage-then-specialist, dev shop, marketing agency, sales team, content studio, support center, Amazon seller team. Choose this skill over agenticflow-agent when the ask mentions 'team', 'workforce', 'pipeline', 'multiple agents', 'delegation', 'handoff', or names a built-in blueprint. Provides the `af workforce *` command surface, blueprint decisions, graph wiring, MCP attach recipes, and public URL publishing."
compatibility: Claude Code, Claude Desktop, Codex, Cursor, Gemini CLI
metadata:
  author: PixelML
  version: "4.0.0"
  license: MIT
triggers:
  - "workforce"
  - "multi-agent"
  - "agent team"
  - "deploy a team"
  - "agent pipeline"
  - "research-then-write"
  - "triage-then-specialist"
  - "dev shop"
  - "marketing agency"
  - "sales team"
  - "content studio"
  - "support center"
  - "amazon seller"
  - "blueprint"
---

# AgenticFlow Workforce

A workforce is an AgenticFlow-native **DAG of agents** — typically `trigger → coordinator agent → worker agents → output` — that hand off structured results to each other. Use this when orchestration between roles matters.

## When NOT to use this skill

If the user wants a **single chat endpoint, a customer-facing bot, one assistant, or routing-by-prompt inside one agent**, use `agenticflow-agent` instead. A single-agent solution with rules in the system prompt is simpler, cheaper, and easier to iterate on. Workforces are for genuine multi-role orchestration.

## Orient first

```bash
af bootstrap --json
```

Returns `auth`, `agents`, `workforces`, `blueprints`, `commands`, `playbooks`, `whats_new`, `_links`. Extract:

- `auth.project_id` — required for agent creation (the agents inside your workforce)
- `auth.workspace_id`
- `_links.workspace` — **surface this URL to the user right away**: *"Your workspace is at `<_links.workspace>` — open it anytime to see the workforce I'm building."* The user needs a human-first anchor before the first mutation
- `blueprints[]` — the built-in team templates, each with required/optional slot counts
- `workforces[]` — any existing workforces in the workspace (empty initially is normal; check `data_fresh` if false — that means the backend was unreachable, not the workspace empty)

If `data_fresh: false` in the bootstrap response, the backend is degraded — **do not mutate**. Run `af doctor --json --strict` and fix auth/network before proceeding.

## Discovery & health

```bash
af changelog --json           # What's new in the CLI since your last install
af context --json              # AI agent orientation, env vars, invocation guidance
af bootstrap --strict --json   # Health check — exits non-zero if degraded
```

`af bootstrap` returns an `invocation` block telling you the correct CLI binary to use. `af bootstrap --strict` exits non-zero when the backend is unhealthy, so CI/automation can abort before mutating against a degraded workspace.

## The built-in blueprints

| Blueprint | Required slots | Optional |
| --- | --- | --- |
| `dev-shop` | ceo, engineer | designer, qa |
| `marketing-agency` | ceo, cmo, designer | researcher |
| `sales-team` | ceo, researcher, general | — |
| `content-studio` | ceo, cmo, engineer | designer |
| `support-center` | ceo, general | researcher |
| `amazon-seller` | ceo, cmo, engineer, researcher | general |
| `tutor` | ceo, cmo, engineer, researcher | general |
| `freelancer` | ceo, cmo, engineer, researcher | general |

## Blueprint discovery

```bash
af blueprints list --json                              # All blueprints
af blueprints list --kind workforce --json            # Filter by kind
af blueprints list --complexity 6 --json              # Multi-agent DAGs only
af blueprints get --id <slug> --json                 # Single blueprint detail
af blueprints show <slug> --json                     # Alias for get
```

Each blueprint response includes:
- `kind` — `workflow` | `agent` | `workforce` (canonical, v1.10.0+)
- `complexity` — `0-6` rung on the composition ladder
- `tier` — legacy field, returns `null` if not explicitly set — **ignore** (v1.10.4 fix)
- `deploy_command` — ready-to-run command string (e.g. `af workforce init --blueprint X --json`)
- `use_cases` — what this blueprint is good for

### All workforce blueprints

| Blueprint | Kind | Complexity | Type | Plugins pre-attached? |
|-----------|------|------------|------|----------------------|
| `dev-shop` | workforce | 6 | Vertical team | No — attach MCP after deploy |
| `marketing-agency` | workforce | 6 | Vertical team | No |
| `sales-team` | workforce | 6 | Vertical team | No |
| `content-studio` | workforce | 6 | Vertical team | No |
| `support-center` | workforce | 6 | Vertical team | No |
| `amazon-seller` | workforce | 6 | Vertical team | No |
| `tutor` | workforce | 6 | Vertical team | No |
| `freelancer` | workforce | 6 | Vertical team | No |
| `research-pair` | workforce | 6 | Plugin-based | **Yes** — v1.9.0+
| `content-duo` | workforce | 6 | Plugin-based | **Yes** |
| `api-pipeline` | workforce | 6 | Plugin-based | **Yes** |
| `fact-check-loop` | workforce | 6 | Plugin-based | **Yes** |
| `parallel-research` | workforce | 6 | Plugin-based | **Yes** — synthesizer topology |

**Plugin-based blueprints** (v1.9.0+) have tools pre-attached to every agent slot — no post-deploy `af agent update --patch` needed.
**Vertical team blueprints** need MCP clients attached after `init`.

---

## One-command deploy (v1.6+)

Always preview with `--dry-run` first:

```bash
af workforce init --blueprint <slug> --name "<name>" --dry-run --json
af workforce init --blueprint <slug> --name "<name>" --json
```

`init` creates the workforce + one real agent per required slot + the wired graph — in a single atomic call. On failure, every resource is rolled back automatically; inspect `details.rolled_back_agents` and `details.rolled_back_workforce` in the error.

Use `--include-optional-slots` to fill every slot, not just required ones. Use `--model <id>` to override the default model for all auto-created agents.

> **Default model change:** Since CLI v1.8.1, blueprint agents default to `agenticflow/gpt-4o-mini` (not `gemini-2.0-flash`). GPT-4o-mini follows system prompts and reliably calls tools; Gemini 2.0 Flash sometimes refuses `web_search` on "latest X" prompts citing cutoff.

## Workflow blueprints (deterministic pipelines)

Workforce is NOT the only multi-agent primitive. For simpler, deterministic pipelines (no agent hand-off), use workflow blueprints instead (rung 0-2):

```bash
# Rung 0: Single-node hello
af workflow init --blueprint llm-hello --json

# Rung 1: Chained LLM nodes
af workflow init --blueprint llm-chain --json

# Rung 2: Web retrieval + summarize
af workflow init --blueprint summarize-url --json
af workflow init --blueprint api-summary --json
af workflow init --blueprint email-to-structured --json        # v1.10.5
af workflow init --blueprint rss-digest-email --json           # v1.10.5
af workflow init --blueprint competitor-url-snapshot --json    # v1.10.5
af workflow init --blueprint job-app-package --json           # v1.10.5
af workflow init --blueprint n8n-converter --json             # v1.10.5
```

Workflows require an LLM-provider connection (straico, openai, anthropic). `af workflow init` auto-discovers it.

**Workflow runs support --wait** (v1.10.2):
```bash
af workflow run --workflow-id <id> --body '{"field":"value"}' --wait --timeout 180 --poll-interval 3 --json
# Polls until terminal. Exits code 2 if failed/cancelled/error.
# Also auto-unwraps {"input":{...}} to flat body when top-level has only that key.
```

---

## Custom workforce (no blueprint fits)

If the user's ask is a precise custom pipeline that no blueprint matches (e.g. a 2-step researcher → writer flow that doesn't fit the 3–5-agent blueprints), skip blueprints:

1. Inspect the expected graph shape:
   ```bash
   af schema workforce --field schema --json
   ```
2. Create metadata only:
   ```bash
   af workforce create --body '{"name":"Raul Content Pipeline","description":"..."}' --json
   ```
3. Create each agent separately via `af agent create` (see `agenticflow-agent` skill).
4. Build a graph JSON with `trigger → researcher (agent node, agent_id from step 3) → writer (agent node) → output`.
5. Deploy the graph atomically:
   ```bash
   af workforce deploy --workforce-id <id> --body @graph.json --json
   ```
6. Validate:
   ```bash
   af workforce validate --workforce-id <id> --json
   ```

Edge `connection_type` is one of `next_step`, `condition`, `ai_condition`. Agent nodes **require** a real `agent_id` in `input`.

## Run + publish

```bash
af workforce run --workforce-id <id> --trigger-data '{"message":"..."}'
# Streams SSE events — each line is one JSON event. The CLI auto-wraps your
# payload in {trigger_data: ...} — don't wrap it yourself.

af workforce publish --workforce-id <id> --json
# Mints a public_key + public_url.
# Returns `_links.workforce_canvas` (Web UI) and `_links.public_run_curl` (ready-to-paste curl).
# Backend used to return 404 paths; CLI now overrides with correct ones.

af workforce versions publish --workforce-id <id> --version-id <v> --json
# Snapshot + publish a specific version (draft/published/restore workflow).
```

### Workforce run fixes (v1.10.2)
- `af workforce publish` now returns correct `_links.public_run_curl` — copy-paste directly
- `af workforce runs get --workforce-id <id> --run-id <id>` flag added for parity
- `af workforce runs stop --workforce-id <id> --run-id <id>` flag added for parity

### When `workforce run` fails with API-key auth
The backend sometimes rejects API-key auth on `workforce run` with `Failed to retrieve user info`. This is a known server-side limitation. The CLI prints a 3-step workaround:
1. Publish the workforce (`af workforce publish`)
2. Run via the public SSE endpoint (uses `public_key`)
3. Check status with `af workforce runs list`

---

## Live marketplace (beyond built-in blueprints)

When built-in blueprints don't cover the use case, browse the live catalog:

```bash
af marketplace list --type mas_template --json              # MAS / workforce templates
af marketplace list --type agent_template --json             # Single-agent templates
af marketplace list --type workflow_template --json        # Workflow templates
```

Clone a marketplace item into your workspace:
```bash
af marketplace try --id <item_id> --dry-run --json
af marketplace try --id <item_id> --json
```

> **Cross-workspace caveat:** MAS template clones may reference source-workspace `agent_id`s. Check the `warnings` field in the response and duplicate source agents separately, or the workforce will 400 on runs.

### Workforce template duplication
```bash
af templates duplicate workforce --template-id <marketplace_mas_id> --dry-run --json
# Or duplicate from an existing workforce:
af templates duplicate workforce --workforce-id <id> --dry-run --json
```

---

## Workspace migration (company export/import)

### Export workspace agents
```bash
af company export --file agents.yaml --json
# Produces a portable YAML with agent definitions.
```

### Import into another workspace
```bash
af company import --file agents.yaml --dry-run --json   # Preview changes
af company import --file agents.yaml --json              # Execute
```
Match key: agent name. Existing agents → update (PUT all fields). Missing agents → create.

### Diff before importing
```bash
af company diff --file agents.yaml --json
# Read-only comparison. Returns per-agent status: new | modified | in_sync | remote_only.
```

### Merge with conflict strategy
```bash
af company merge --file agents.yaml --strategy local --dry-run --json
af company merge --file agents.yaml --strategy local --json
```
Strategies:
- `local` — overwrite remote with local (update modified, create new, skip no_change)
- `remote` — keep live state (skip all modified)
- `skip` — do nothing (report only)

> **Never deletes:** Remote-only agents are reported but NEVER deleted by any strategy.

---

## Attach MCP tools per agent (not per workforce)

MCP clients attach to individual agents, not to the workforce graph. After `init`, use:

```bash
af mcp-clients list --name-contains "google sheets" --fields id,name --json
af mcp-clients inspect --id <mcp_id> --json       # Check pattern before attach
af agent update --agent-id <agent_id> --patch --body '{"mcp_clients":[{"mcp_client_id":"<id>","run_behavior":"auto_run","tools":{}}]}' --json
```

See the `agenticflow-mcp` skill for the Pipedream vs Composio write-safety distinction.

## Cleanup

Workforces + agents are billed while they exist. Delete test deploys:

```bash
af workforce delete --workforce-id <id> --json
# For each auto-created agent id captured from init:
af agent delete --agent-id <id> --json
```

Both return `{"schema":"agenticflow.delete.v1","deleted":true,"id":"...","resource":"..."}` on success.

## On errors

All API errors return `{schema: "agenticflow.error.v1", code, message, hint, details}`. Read `hint` first — it points at the recovery command (e.g. `af <resource> list` on a 404). For 422s, inspect `details.payload.detail` for field-level errors.

`workforce run` occasionally returns a backend `Failed to retrieve user info for user_id: api_key:...` 400 — this is a known server-side issue with API-key auth, not a CLI bug.