# ClaudePM

ClaudePM is a Claude Code plugin that saves your project context between sessions. When you start a new session, it loads what you were working on, what decisions you made, what tasks are open, and where you left off.

Without it, every new Claude Code session starts blank. You have to re-explain your project, your decisions, and your progress before you can get back to work. This gets worse the longer a project runs. ClaudePM solves that by saving structured session notes, project state, and decisions to markdown files that get loaded automatically when you start working.

## Install

```
/plugin marketplace add Dammyjay93/claudepm
/plugin install claudepm@Dammyjay93-claudepm
```

Run `/claudepm` to set up. It asks three things: where to store files, how you track tasks, and what project you're working on. Takes about a minute.

## How it works

At the end of a session, you run `/claudepm save`. It writes a detailed session file covering what was built, what was decided, what tasks changed, and what comes next. It also updates your project's state file, syncs your task tracker, and commits to git.

At the start of the next session, a hook reads your project files and loads the context into Claude automatically. Claude knows the project, the current task, recent decisions, and open work without you having to explain anything.

Everything is stored as markdown files in a directory called the vault (default: `~/.claudepm/`). There's no database or external service involved.

## What it stores

```
~/.claudepm/
├── manifest.md           # Project list and active project
├── projects/
│   └── my-app/
│       ├── _index.md     # Project state, decisions, tasks
│       ├── PRD.md        # Problem, solution, requirements
│       ├── rules.md      # Project constraints
│       └── specs/        # Feature specifications
└── sessions/
    └── 2026-03-15-my-app.md
```

Each project has its own folder with a state file (`_index.md`), a requirements doc, a rules file, and folders for specs and epics. Sessions are stored separately with dates and project names.

All files are plain markdown. If you stop using ClaudePM, the files are still there and still readable.

## Features

**Session memory.** Every session gets saved with what happened, what was decided, and what's next. The next session loads this context automatically.

**Decision tracking.** Decisions are saved to specific files based on their type. Project constraints go in `rules.md`, major product decisions go in `_index.md`, feature decisions go in the relevant spec file. This makes decisions easy to find later.

**Feature planning.** The `/claudepm plan` command walks you through writing a feature spec by asking structured questions about scope, user journeys, edge cases, data design, and build order. It asks specific questions and doesn't accept vague answers.

**Bug audit gate.** Before fixing a bug, ClaudePM prompts you to verify that the code is actually reachable, that users are affected, and that the fix applies to the right platform. This prevents wasted work on dead code or irrelevant issues.

**Task tracking.** Works with whatever you use. Local markdown tables (default, no setup), Linear (via MCP), GitHub Issues (via `gh` CLI), or any external tool (it reminds you to update manually).

**Cross-tool handoff.** The `/claudepm handoff` command writes a file with full project context so you can continue work in Cursor, Codex, or another tool without losing what was done.

## Commands

| Command | Description |
|---------|-------------|
| `/claudepm` | Show project status and load context |
| `/claudepm save` | Save session notes, update tracker, commit |
| `/claudepm plan` | Create a new project or feature spec |
| `/claudepm review` | Check a spec for gaps before building |
| `/claudepm handoff` | Create a handoff file for another AI tool |
| `/claudepm archive` | Archive old sessions or projects |
| `/claudepm help` | Explain commands and concepts |

## How it fits with CLAUDE.md and MEMORY.md

Claude Code already has `CLAUDE.md` for project-level instructions and `MEMORY.md` for user-level preferences. ClaudePM does not replace either of them.

`CLAUDE.md` stores static rules you write yourself, like coding conventions or file structure guidelines. `MEMORY.md` stores things Claude learns about you across projects, like your experience level or communication preferences. ClaudePM stores project-specific state that changes every session: what was built, what was decided, what tasks are open.

All three are complementary.

## Using an existing vault

If you already have a vault directory from a previous version or from Obsidian, set this environment variable:

```bash
export CLAUDEPM_VAULT=~/Vault
```

ClaudePM will use that directory. No migration is needed.

## Privacy

The vault contains project decisions, architecture notes, and session summaries. It does not contain code or credentials. Still, the content is project-specific and should be treated as private. Don't push it to a public repository.

## License

MIT
