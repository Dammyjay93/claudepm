---
description: Switch to a different project
allowed-tools: Read, Write, Edit, Glob
argument-hint: <project-name>
---

# ClaudeMem Switch

Switch active context to a different project.

**Multi-session safe**: This only updates your session's context. Other sessions on other projects are unaffected.

## Steps

1. **Check Current State**
   - Read `~/Vault/_manifest.md` for Last Touched
   - Read current project's `_index.md` if it exists

2. **Offer to Save** (optional)
   If there's been significant work in this session:
   ```
   You have work in progress on {current project}.

   Save session notes before switching? (y/n)
   ```

3. **Find Target Project**
   - Parse argument: `$ARGUMENTS`
   - Search `~/Vault/Projects/` for matching project
   - Match by id or name (fuzzy)

4. **If Project Not Found**
   ```
   Project not found: {argument}

   Available projects:
   - {project 1} ({status})
   - {project 2} ({status})

   Or use /claudemem plan to create a new one.
   ```

5. **Load New Project**
   - Read `Projects/{id}/_index.md`
   - Get active epic/task from **Current State** section
   - Update manifest's `Last Touched` only (not Active Context)

6. **Announce**

```
SWITCHED TO: {Project Name}

Status: {status}
Current Epic: {epic name from _index.md}
Current Task: {task from _index.md or "None - pick one to start"}

Progress: {n}/{m} tasks complete

Use /claudemem start {task} to begin.
```

## If Switching to Paused Project

```
RESUMING: {Project Name}

Last worked: {date from Recent Sessions}
Left off at: {task from project's _index.md}

Continue with {task}? (y) or /claudemem status for full overview
```

## What Gets Updated

| File | Change |
|------|--------|
| `_manifest.md` | `Last Touched` → new project |
| Old project `_index.md` | Nothing (state preserved) |
| New project `_index.md` | Nothing (just reading) |

## Argument

$ARGUMENTS
