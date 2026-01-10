# Project Schema

## File Location
`Projects/{id}/_index.md`

## Required Frontmatter

```yaml
---
type: project
id: string           # kebab-case, unique (e.g., "my-app")
name: string         # Human-readable name
status: string       # active | paused | complete
priority: string     # P0 | P1 | P2
created: string      # ISO date (YYYY-MM-DD)
updated: string      # ISO date (YYYY-MM-DD)
brief: string        # One-line description
repository: string   # Path to code repository
stack: array         # Technologies used
---
```

## Template

```markdown
---
type: project
id: {slug}
name: {Display Name}
status: active
priority: P0
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}
brief: {One-line description}
repository: {path}
stack: [{tech}, {tech}]
---

# {Project Name}

## Overview

{2-3 sentences describing what this is}

## Current State

- **Phase**: {e.g., "Core built, needs polish"}
- **Active Epic**: {epic name or "None"}
- **Active Task**: {task or "None"}
- **Blockers**: {description or "None"}

## Active Stances

| Domain | Stance | Source |
|--------|--------|--------|
| {area} | {decision} | rules.md |

## Key Decisions

| Decision | Rationale | Revisit If |
|----------|-----------|------------|
| {decision} | {why} | {trigger} |

## Epics

| Epic | Status | Progress | Priority |
|------|--------|----------|----------|
| [01-name](./Epics/01-name.md) | in-progress | ~X% | P0 |
| [02-name](./Epics/02-name.md) | pending | 0% | P1 |

## P0 Blockers

Ship-blocking tasks:
- [ ] {Task} (Epic: {name})

## Quick Links

- [PRD](./PRD.md)
- [Capability Matrix](./capability-matrix.md)
- [Rules](./rules.md)
```

## Rules

1. One project = one folder in `Projects/`
2. Folder name must match `id` field
3. `_index.md` is the entry point, always exists
4. **Current State is source of truth** — update here, not manifest
5. P0 Blockers aggregates ship-blocking tasks from all epics

## Project Structure

```
Projects/{id}/
├── _index.md              # This file (dashboard)
├── PRD.md                 # What, why, constraints
├── capability-matrix.md   # Exhaustive decomposition
├── rules.md               # Enforced constraints
└── Epics/
    ├── 01-{name}.md
    ├── 02-{name}.md
    └── ...
```

## Status Meanings

| Status | Meaning |
|--------|---------|
| `active` | Currently being worked on |
| `paused` | On hold, will resume |
| `complete` | Shipped, in maintenance |

## Update Triggers

Update `_index.md` when:
- Starting/completing a task
- Epic status changes
- Blockers added/resolved
- Phase changes
