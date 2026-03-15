# Changelog

All notable changes to ClaudePM will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.0.0] - 2026-03-15

### Added
- **Tracker-agnostic task tracking**: supports local markdown (default), Linear, GitHub Issues, and external trackers. Set once during setup, all commands adapt automatically.
- **Auto-detection**: SessionStart hook matches working directory to project repository paths. No manual switching needed for most projects.
- **First-run setup flow**: guided setup that creates the vault, asks about tracker preference, and sets up the first project interactively.
- **Emergency session save**: Stop hook detects unsaved work and writes a session stub with git diff when a session ends without `/claudepm save`.
- **Stale session warning**: SessionStart hook warns when the last session was more than 14 days ago.
- **Untracked directory detection**: hook notices when you're in a git repo not tracked by ClaudePM and offers to add it.
- **SKILL.md knowledge base**: auto-activating skill that teaches decision routing, audit gates, tracker modes, spec tiers, and drift detection.
- **`/claudepm help` command**: contextual help for all concepts (tracker, specs, decisions, audit, drift, vault, memory).
- **`/claudepm archive` action**: archives old sessions and projects, prunes manifest to last 15 entries.
- **Audit gate marker files**: `.claudepm/.audit-gates` persists audit gate completion across context compaction.
- **Configurable vault path**: set `$CLAUDEPM_VAULT` environment variable to use any directory. Default: `~/.claudepm/`.
- **Plugin hooks.json**: hooks are now self-contained in the plugin, no longer require global settings.json configuration.
- **MEMORY.md boundary documentation**: clear guidance on what goes in ClaudePM vs Claude's built-in memory.

### Changed
- **BREAKING**: Vault default location changed from `~/Vault/` to `~/.claudepm/`. Set `CLAUDEPM_VAULT=~/Vault` to keep using existing vault.
- **BREAKING**: Removed `/claudepm:setup`, `/claudepm:start`, `/claudepm:done`, `/claudepm:status`, `/claudepm:switch` commands. Functionality consolidated into `/claudepm` dispatcher and `/claudepm save`.
- All commands are now tracker-aware. Linear MCP tools are only called when tracker is set to `linear`.
- Save command creates tracker-specific session file sections.
- Plan command creates tasks in the configured tracker (local table, Linear issues, GitHub issues, or listed for external).
- Handoff command includes remaining tasks from the configured tracker.
- Session file naming changed to `{YYYY-MM-DD}-{project}.md` (includes project name).
- Manifest schema updated to version 4 with `tracker` field in frontmatter.
- README rewritten for plain, clear communication.

### Removed
- Capability matrix as primary planning tool (replaced by spec-first workflow in v3)
- `docs/` directory (PLANNING.md, SETUP.md, COMMANDS.md, FUTURE.md) — outdated v2/v3 documentation
- Hard dependency on Obsidian and Linear

## [3.2.0] - 2026-03-11

### Added
- Structured audit gate (Bug, Execution Path, User Symptom, Platform) with stop conditions
- Issue workflow: Audit -> Gate -> Code -> Test -> Run -> Mutate -> Commit
- Sub-issue hygiene rules (Todo not Backlog, cycle assignment, parent estimates)
- Linear sync discipline: update as you go, not just at save
- Scope creep detection: create tickets for out-of-scope findings
- Spec drift checking during save

### Changed
- Plan command now does codebase audit before interrogation
- Specs include Technical Context section grounded in existing code
- Save command verifies Linear issue statuses match actual work

## [3.0.0] - 2026-01-09

### Changed
- **BREAKING**: Renamed plugin from `claudemem` to `claudepm`
- All commands now use `/claudepm` prefix
- Spec-first workflow replaces capability matrix for features
- Tiered specs (1/2/3) based on blast radius

## [2.0.0] - 2026-01-09

### Added
- Bounded decision system with routing (rules.md, stances, key decisions, specs, sessions)
- Explicit file paths in all commands

### Changed
- Replaced unbounded Decisions.md with bounded system

## [1.0.0] - 2026-01-08

### Added
- Initial release
- Multi-session project memory
- Vault storage at `~/Vault/`
- Commands: plan, start, done, save, status, switch
