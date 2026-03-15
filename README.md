<h1 align="center">ClaudePM</h1>

<p align="center">
  Session memory and spec discipline for Claude Code.
</p>

<p align="center">
  <a href="https://github.com/Dammyjay93/claudepm/releases"><img src="https://img.shields.io/github/v/release/Dammyjay93/claudepm?style=flat-square" alt="Release"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue?style=flat-square" alt="License"></a>
  <a href="https://github.com/Dammyjay93/claudepm/stargazers"><img src="https://img.shields.io/github/stars/Dammyjay93/claudepm?style=flat-square" alt="Stars"></a>
</p>

<p align="center">
  <a href="#installation">Installation</a> &middot;
  <a href="#what-it-looks-like">What It Looks Like</a> &middot;
  <a href="#features">Features</a> &middot;
  <a href="#commands">Commands</a> &middot;
  <a href="#how-it-fits-with-claude-code">How It Fits</a>
</p>

---

## What is ClaudePM?

ClaudePM is a plugin for Claude Code that keeps your project context between sessions. Each time you end a session, it saves what you worked on, what you decided, and what you need to do next. When you start a new session, that context loads automatically so Claude already knows where things stand.

Without it, every new Claude Code session starts blank. You have to re-explain your project, remind Claude of past decisions, and point it back to where you left off. ClaudePM removes that step entirely.

All context is saved as plain markdown files in a folder on your machine. There is no database or external service. If you stop using ClaudePM, the files are still there and readable.

---

## What It Looks Like

When you open Claude Code, the plugin loads your project context automatically:

```
=== CLAUDEPM: WORKSPACE STATE ===

ACTIVE PROJECT: my-saas
  Name: MySaaS
  Brief: B2B invoicing platform with Stripe integration
ACTIVE EPIC: billing-v2
ACTIVE TASK: Migrate webhook handlers to new Stripe API

===================================
```

Running `/claudepm` shows the full status of your project and tasks:

```
CLAUDEPM v4.0.0

PROJECT: MySaaS
Status: active | Priority: P0

EPIC: Billing V2
Progress: 4/9 tasks (44%)

TASKS:
- Migrate webhook handlers to new Stripe API (in-progress) [P0]
- Add idempotency keys to payment endpoints (todo) [P0]
- Update invoice PDF template (todo) [P1]
- Fix currency rounding on multi-line invoices (todo) [P1]

NEXT UP:
1. Finish webhook migration
2. Idempotency keys

BLOCKERS: None
```

Running `/claudepm save` at the end of a session saves everything and shows what was recorded:

```
SESSION SAVED

Project: MySaaS
Session: Stripe webhook migration + invoice bug fixes

Files Updated:
  manifest.md
  projects/my-saas/_index.md
  sessions/2026-03-15-my-saas.md (created)

Git:
  my-saas: committed "fix: migrate webhook handlers to Stripe API v2024-12"

Tracker: 3 tasks updated

Next: Add idempotency keys to payment endpoints
```

---

## Installation

> [!NOTE]
> ClaudePM requires [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview). If you haven't installed Claude Code yet, do that first.

### Step 1 — Add the marketplace

Open Claude Code and run this command. It tells Claude Code where to find the ClaudePM plugin.

```
/plugin marketplace add Dammyjay93/claudepm
```

### Step 2 — Install the plugin

This downloads ClaudePM and registers its commands.

```
/plugin install claudepm@Dammyjay93-claudepm
```

### Step 3 — Restart Claude Code

Close Claude Code and open it again (or type `/exit` and then `claude`). The plugin needs a fresh session to activate its hooks.

### Step 4 — Run the setup

```
/claudepm
```

The first time you run this, ClaudePM asks you three things:

1. **Where to store files.** The default is `~/.claudepm/`. You can also point it at an existing folder like a Dropbox directory or anywhere else on your machine.

2. **How you track tasks.** You have four options:
   - **Local markdown** — tasks are stored as a table in your project files. No setup needed. This is the default.
   - **Linear** — full integration with Linear via MCP. Issues, cycles, sub-issues, sprint tracking. Requires the Linear MCP server to be installed.
   - **GitHub Issues** — tracks issues using the `gh` CLI. Requires `gh` to be installed and authenticated.
   - **External** — you use your own system. ClaudePM will remind you to update it when tasks change.

3. **What you're working on.** Give it a project name, a short description, and the path to your code. ClaudePM creates a project folder with the initial files.

After this, your project context will load automatically at the start of every session.

> [!TIP]
> If you already have a folder with ClaudePM files from a previous version, add this line to your shell profile (`~/.zshrc` or `~/.bashrc`) instead of going through setup:
> ```bash
> export CLAUDEPM_VAULT=~/path/to/your/vault
> ```

---

## Features

### Session memory

When you run `/claudepm save`, ClaudePM writes a session file that records what was built, what was decided, what tasks changed, and what comes next. It also updates the project state file, syncs your task tracker, and commits to git.

When you start a new session, a hook reads these files and gives Claude the full context. Claude knows the project, the current task, the recent decisions, and the open work.

The session hook also:

- **Detects your project automatically** by matching your working directory to project repo paths. If you open Claude Code in a different project folder, it switches context for you.
- **Warns about stale context** if your last session was more than two weeks ago.
- **Detects handoffs** if another AI tool left a `.handoff/handoff.md` file.

If a session ends without saving (crash, timeout, or you forgot), the stop hook writes an emergency stub with your git diff so the next session knows what happened.

### Decision tracking

Each type of decision has a specific place where it gets stored:

| Type | File | Example |
|------|------|---------|
| Project constraint | `rules.md` | "All API responses must include request IDs" |
| Major product decision | `_index.md` | "Chose Postgres over DynamoDB for billing data" |
| Feature-level decision | The spec file | "Invoices are immutable after sending" |
| Session context | Session notes | "Migrated 3 endpoints, 2 remaining" |

This means when you need to find a specific decision later, there is one place to look based on what kind of decision it is.

### Feature planning

The `/claudepm plan` command helps you write a spec for a new feature. It reads your codebase first to understand what already exists, then asks you structured questions about scope, user flows, edge cases, data design, and build order. Questions come in batches of 3-6 so you can answer them together.

It does not accept vague answers. If you say "handle errors appropriately", it will ask you to be specific about what the user sees, what happens to their input, and how they recover.

Specs are sized based on how much the feature touches:

| Tier | When | What gets covered |
|------|------|-------------------|
| **1** | Crosses repos, or touches auth/payments | Data design, access policies, state contracts, failure modes, build order |
| **2** | Single repo, changes the database | Data design, user journeys, build order |
| **3** | UI only, no database changes | User journeys, build order |

ClaudePM figures out the tier from context and tells you why it chose that tier. After the spec is done, it creates tasks in whatever tracker you configured during setup.

### Bug audit gate

Before you fix a bug, ClaudePM asks you to fill out four fields:

| Field | What it checks |
|-------|----------------|
| **Bug** | What code is wrong, which file, which line |
| **Execution Path** | How a user actually reaches that code, step by step |
| **User Symptom** | What the user sees or experiences as a result |
| **Platform** | Whether the fix applies to the actual deployment target |

If the code has no callers, it is dead code. If there is no user symptom, the code is wrong but nobody is affected. If the platform does not match (like a CORS fix for a mobile app that does not use a browser), the fix does not apply.

Each of these is a stop condition. If any one fails, you and Claude decide together whether to proceed or skip it.

After the gate, you write a short "Why This Matters" summary in plain language that goes into the task description. This is so anyone reading the task later can understand the impact without reading the full audit.

### Task tracking

ClaudePM works with whatever task tracker you already use:

<details>
<summary><strong>Local markdown</strong> — default, no setup</summary>

Tasks are stored as a markdown table in your project's `_index.md` file:

```markdown
## Tasks

| id | title                | status      | priority |
|----|----------------------|-------------|----------|
| 1  | Fix auth flow        | in-progress | P0       |
| 2  | Add onboarding       | todo        | P1       |
| 3  | Write migration      | done        | P0       |
```

ClaudePM reads and updates this table directly.
</details>

<details>
<summary><strong>Linear</strong> — full integration via MCP</summary>

Uses the Linear MCP server to create and manage issues, projects, milestones, cycles, and sub-issues. Status syncs automatically as you work.

Requires the Linear MCP server to be installed and connected.
</details>

<details>
<summary><strong>GitHub Issues</strong> — via gh CLI</summary>

Creates and manages issues using the `gh` command line tool. Uses labels for priority and status, and milestones for build phases.

Requires `gh` to be installed and authenticated (`gh auth login`).
</details>

<details>
<summary><strong>External</strong> — bring your own</summary>

ClaudePM does not touch your tracker. When tasks change during a session, it lists the changes and reminds you to update your tracker manually.
</details>

### Cross-tool handoff

If you need to continue working in Cursor, Codex, or another AI tool, run `/claudepm handoff`. It writes a `.handoff/handoff.md` file in your repo with:

- What was done and what is left
- What was tried and what failed (if you are stuck)
- Which files are involved and what they do
- A ready-to-paste prompt for the receiving tool

It also creates config files for the receiving tool (`AGENTS.md` for Codex, `.cursor/rules/handoff.mdc` for Cursor) so the tool picks up the handoff automatically.

---

## Commands

| Command | What it does |
|---------|-------------|
| `/claudepm` | Load project context and show status |
| `/claudepm save` | Save session: notes, tracker updates, spec changes, git commit |
| `/claudepm plan` | Create a new project or write a feature spec |
| `/claudepm review` | Check a spec for missing sections or vague language |
| `/claudepm handoff` | Write a handoff file for another AI tool |
| `/claudepm archive` | Move old sessions to archive, mark projects as archived |
| `/claudepm help [topic]` | Get help on a specific concept: `tracker`, `specs`, `decisions`, `audit`, `drift`, `vault`, `memory` |

---

## How It Fits with Claude Code

Claude Code has two built-in context systems. ClaudePM adds a third. They do different things:

| | What it stores | How it updates | Scope |
|-|---------------|----------------|-------|
| **CLAUDE.md** | Rules you write yourself, like coding conventions and project setup | You edit it manually | One project |
| **MEMORY.md** | Things Claude learns about you, like your preferences and experience | Claude updates it automatically | All projects |
| **ClaudePM** | What is happening in the project: decisions, sessions, specs, tasks, progress | Updates every session via `/claudepm save` | One project, persists across sessions |

All three work together. None of them replace the others.

---

## File Structure

All files are plain markdown in a single directory:

```
~/.claudepm/
├── manifest.md                    # Project list, active project, config
├── projects/
│   └── my-app/
│       ├── _index.md              # Project state, decisions, tasks
│       ├── PRD.md                 # What the project is and why
│       ├── rules.md               # Project constraints
│       ├── specs/
│       │   └── F01-auth-flow.md   # Feature specification
│       └── epics/
│           └── 01-foundation.md   # Non-feature work
└── sessions/
    ├── 2026-03-14-my-app.md
    └── 2026-03-15-my-app.md
```

> [!NOTE]
> The default location is `~/.claudepm/`. To use a different folder, set `CLAUDEPM_VAULT` in your shell profile:
> ```bash
> export CLAUDEPM_VAULT=~/your/preferred/path
> ```

---

## Privacy

The vault contains project decisions, architecture notes, and session history. It does not contain source code, secrets, or credentials. The content is specific to your projects and should be kept private. Do not push it to a public repository.

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for setup and guidelines.

## License

MIT
