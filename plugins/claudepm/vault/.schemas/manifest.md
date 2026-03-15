# Manifest Schema

## File Location
`manifest.md` (root of vault)

## Purpose

Central registry for projects and configuration. Does NOT track session state — that lives in each project's `_index.md`.

## Required Frontmatter

```yaml
---
type: manifest
version: 4
tracker: local | linear | github | external
updated: string  # ISO date
---
```

## Template

```markdown
---
type: manifest
version: 4
tracker: local
updated: {YYYY-MM-DD}
---

# Workspace

## Active Context

project: {project-id}
epic: {epic-id or null}
task: {task description or null}

## Projects

| id | name | status | priority | last_active | path |
|----|------|--------|----------|-------------|------|
| {id} | {name} | active | P0 | {date} | projects/{id} |

## Recent Sessions

| date | project | summary |
|------|---------|---------|
| {date} | {project} | {brief} |

## Blockers

| id | description | blocking | created | resolved |
|----|-------------|----------|---------|----------|

## Quick Stats

- Total projects: {n}
- Active projects: {n}
```

## Rules

1. **No active session state** — Epic/task lives in project's `_index.md`
2. **Active Context is advisory** — Hint for session start, verified against `_index.md`
3. **Update last_active** when saving session
4. **Recent Sessions** capped at 15 entries — older entries live in session files only
5. **Tracker mode** applies to all projects — set once during setup

## Version Migration

When loading a manifest, check the `version` field:

- **version: 3 → 4**: Add `tracker: local` to frontmatter if missing. Rename `Last Touched` section to `Active Context`. Add `Recent Sessions` section if missing.
- **Missing version**: Treat as version 3, migrate to 4.

## Multi-Session Behavior

Multiple Claude sessions can run simultaneously because:
- Each project's `_index.md` owns its state
- Sessions only write to their own project
- Manifest touched only on explicit actions
