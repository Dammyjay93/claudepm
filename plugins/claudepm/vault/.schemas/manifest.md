# Manifest Schema

## File Location
`_manifest.md` (root of Vault)

## Purpose

Central registry for projects. Does NOT track session state — that lives in each project's `_index.md`.

## Required Frontmatter

```yaml
---
type: manifest
version: 3
updated: string  # ISO timestamp
---
```

## Template

```markdown
# Workspace

## Last Touched

project: {project-id}   # Advisory hint for session start

## Projects

| id | name | status | priority | last_active | path |
|----|------|--------|----------|-------------|------|
| {id} | {name} | active | P0 | {date} | Projects/{id} |

## Blockers

| id | description | blocking | created | resolved |
|----|-------------|----------|---------|----------|
<!-- Cross-project blockers only -->

## Quick Stats

- Total projects: {n}
- Active projects: {n}
```

## Project Entry

Each project row links to:
```
Projects/{id}/
├── _index.md              # Dashboard
├── PRD.md                 # What/why
├── capability-matrix.md   # Exhaustive decomposition
├── rules.md               # Constraints
└── Epics/                 # Implementation plan
```

## Rules

1. **No active session state** — Epic/task lives in project's `_index.md`
2. **Last Touched is advisory** — Hint for session start, may be stale
3. **Update Last Touched** on session start or `/claudepm switch`
4. **Update last_active** when saving session
5. **Session history** lives in `Sessions/`, not manifest

## Multi-Session Behavior

Multiple Claude sessions can run simultaneously because:
- Each project's `_index.md` owns its state
- Sessions only write to their own project
- Manifest touched only on explicit actions
