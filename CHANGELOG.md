# Changelog

All notable changes to AgenticFlow AI Skills will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [1.0.0] — 2026-04-30

### Features

- **skills.sh ecosystem integration:** Primary install is now `npx skills add antongulin/agenticflow-ai-skills --all`. Supports 50+ AI coding tools.
- **Deprecation banner on `skills.sh`:** Legacy installer redirects to `npx skills add` with flag examples. Escape hatch: `FORCE_LEGACY=1`.
- **Modern agent paths:** README now references `.agents/skills/` for Cursor, Codex, Gemini CLI, and OpenCode.

### Fixes

- **Stale install instructions:** README no longer presents `curl | bash` as the primary method.
- **INSTALL.md bloat:** Reduced from 110+ lines of per-tool curl commands to 34-line npx-first fallback.
- **AGENTS.md drift:** Updated phase tracking and skill references to match new install flow.

### Learnings

- **Deprecation over deletion:** Deleting `skills.sh` would have broken external links (blog posts, bookmarks). A deprecation banner with redirect instructions preserves those links while guiding users to the new flow.
- **Escape hatches matter:** `FORCE_LEGACY=1` isn't a crutch — it's a safety valve for air-gapped or npm-down scenarios.
- **One command to rule them all:** Using `--all` instead of interactive selection removes a friction point in CI and onboarding.
- **Agent path conventions change:** `.agents/skills/` is becoming the default for newer tools (Cursor, etc.), while Claude Code keeps `.claude/skills/`. Tracking multiple conventions is required for accurate manual install docs.
- **End-to-end verification beats unit tests:** `npx skills add --all --yes` installed all 5 skills and verified frontmatter + file count. This caught issues a YAML linter would miss.
