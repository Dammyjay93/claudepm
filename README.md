# ClaudeMem

Every Claude Code session starts with a blank slate. You explain your project, make decisions, write code—then close the session. Tomorrow, Claude has no idea what happened.

ClaudeMem fixes this. It gives Claude persistent memory across sessions.

```
[New session starts]

Claude: "Resuming your project. Currently on epic 2: 'Core Features'.
         Task: Set up database auth. Continue where you left off?"
```

Claude knows what you're building, what you decided, and what's next. No re-explaining.

---

## Why not just use a PRD file?

You can drop a PRD.md in your project and Claude will read it. That works for static context. But it doesn't solve:

- **What task am I on?** A PRD doesn't track progress
- **What did I decide yesterday?** Decisions get lost in conversation history
- **What happened last session?** No automatic session logging
- **Which project am I working on?** If you juggle multiple projects, Claude doesn't know which one is active

ClaudeMem tracks all of this in structured files that Claude reads automatically when you start a session.

---

## Why not just tell Claude what I'm working on?

You can. Every single session. Forever.

Or you can run `/claudemem:status` and Claude already knows.

The difference is automation. ClaudeMem hooks into session start/stop, so Claude loads context without you asking. It tracks task completion so you don't manually update files. It logs sessions so you have a history.

---

## Why not Linear/Notion with MCP?

You can use those MCPs. They work. ClaudeMem is different in a few ways:

- **No setup**: No API keys, no external accounts. Just markdown files.
- **Conversation → tasks**: Claude generates PRD and tasks from your discussion. You don't create them manually.
- **Session-first**: Built specifically for "where was I?" not general project management.
- **Portable**: It's just files in `~/Vault/`. Works offline, easy to backup, readable without any tool.

If you already use Linear and want Claude to interact with it, use the Linear MCP. If you want lightweight session memory without external dependencies, use ClaudeMem.

---

## Installation

```
/plugin marketplace add Dammyjay93/claudemem
/plugin install claudemem
/claudemem:setup
```

The first command adds the marketplace. The second installs the plugin. The third creates your vault structure and tells you how to configure hooks and CLAUDE.md.

---

## How It Works

ClaudeMem stores everything in `~/Vault/`:

```
~/Vault/
├── _manifest.md                # Active project, current task, recent sessions
├── Projects/
│   └── my-project/
│       ├── _index.md           # Project overview and status
│       ├── PRD.md              # Requirements (generated from conversation)
│       ├── Decisions.md        # Architecture decisions with timestamps
│       └── Epics/
│           ├── 01-foundation.md
│           └── 02-features.md  # Tasks as checkboxes with status
└── Sessions/
    └── 2026-01-08.md           # What happened today
```

When Claude starts a session, it reads `_manifest.md` first. That file points to the active project and task. Claude knows exactly where you are.

---

## Commands

| Command | What It Does |
|---------|--------------|
| `/claudemem:setup` | Initialize vault structure |
| `/claudemem:plan` | Turn current conversation into PRD, epics, and tasks |
| `/claudemem:start` | Start the next task (or a specific one) |
| `/claudemem:done` | Mark current task complete, get next suggestion |
| `/claudemem:save` | Write session notes before you close |
| `/claudemem:status` | Show active project, current task, blockers |
| `/claudemem:switch` | Change to a different project |

---

## Workflow

### Planning a project

You have a conversation about what you want to build. Then:

```
You: /claudemem:plan

Claude: Creates PRD, epics, tasks from conversation
        "Created 'my-project': 4 epics, 23 tasks. Ready to start?"
```

You don't write the PRD. Claude extracts it from what you discussed.

### Working on tasks

```
You: /claudemem:start

Claude: "Starting task: Set up database schema"
        [Loads relevant context from PRD and previous decisions]

[You work on it]

You: /claudemem:done

Claude: "Marked complete. Next up: Implement user auth. Continue?"
```

### Next session

```
[Open Claude Code tomorrow]

Claude: "Resuming my-project. You completed 'Set up database schema' yesterday.
         Current task: Implement user auth. Ready?"
```

You pick up exactly where you left off.

---

## Docs

- [Commands Reference](docs/COMMANDS.md) - Detailed command documentation
- [Setup Guide](docs/SETUP.md) - Manual installation if you prefer
- [Future: Obsidian](docs/FUTURE.md) - Visual kanban boards (planned)

---

## License

MIT
