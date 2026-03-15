---
description: Learn ClaudePM concepts and commands
allowed-tools: Read
argument-hint: [topic]
---

# ClaudePM Help

Show contextual help for ClaudePM. If a topic is provided, explain that concept. Otherwise, show the overview.

## Argument: $ARGUMENTS

### No argument → Overview

```
CLAUDEPM HELP

ClaudePM keeps your project context across sessions — what you decided,
what you built, and what's next.

COMMANDS
  /claudepm              Status + load project context
  /claudepm save         Save session (notes, tracker, specs, git)
  /claudepm plan         Plan a new project or feature spec
  /claudepm review       Validate a spec before building
  /claudepm handoff      Hand off context to Cursor, Codex, etc.
  /claudepm archive      Archive old sessions or projects
  /claudepm help [topic] This help

TOPICS (run /claudepm help <topic>)
  tracker     How task tracking works (local, linear, github, external)
  specs       The spec-first workflow and tiers
  decisions   Where different types of decisions are stored
  audit       The structured audit gate for bug fixes
  drift       How drift detection works
  vault       Where files are stored and how to back up
  memory      How ClaudePM relates to Claude's built-in MEMORY.md
```

### Topic: "tracker"

Explain the four tracker modes (local, linear, github, external), how to check which is active, and how to switch. Read the SKILL.md tracker section for reference.

### Topic: "specs"

Explain the spec-first workflow: why specs exist, the three tiers (with examples of when each applies), the interrogation protocol, and how specs connect to tasks.

### Topic: "decisions"

Show the decision routing table. Explain why different decisions live in different places with examples.

### Topic: "audit"

Explain the 4-field audit gate (Bug, Execution Path, User Symptom, Platform), stop conditions, and why "pattern is not impact."

### Topic: "drift"

Explain drift detection: what it is, when it runs (during save), how to resolve it.

### Topic: "vault"

Show the vault file structure. Explain how to find the vault path, how to back it up, and that it's just markdown files.

### Topic: "memory"

Explain the boundary between ClaudePM (project state) and Claude's built-in MEMORY.md (user preferences). Show the decision table from the SKILL.md.

### Unknown topic

"I don't have help for '{topic}'. Available topics: tracker, specs, decisions, audit, drift, vault, memory"
