---
description: Start working on a task or project
allowed-tools: Read, Write, Edit, Glob
argument-hint: <task-or-project>
---

# ClaudeMem Start

Begin working on a task or switch to a project.

**Multi-session safe**: Updates only your project's files. Other sessions on other projects are unaffected.

## Steps

1. **Parse Argument**: `$ARGUMENTS`
   - If it matches a project name → switch to that project first
   - If it matches a task description → find and start that task
   - If no argument → start next pending task in current epic

2. **Find Current Context**
   - Read `~/Vault/_manifest.md` for Last Touched project
   - Read `~/Vault/Projects/{project}/_index.md` for current epic/task
   - Search epic files for matching task

3. **Update Task Status**
   - In the epic file, change task from `#pending` to `#in-progress`
   - Only one task should be `#in-progress` at a time
   - If another task is in-progress, ask if user wants to switch

4. **Update Project's _index.md**
   - Set **Current State** section → active epic, active task
   - This is your session's source of truth

5. **Update Manifest** (minimal)
   - Set `Last Touched` → current project
   - Do NOT store epic/task in manifest

6. **Load Context**
   - Read project `_index.md`
   - Read current epic file
   - Read relevant sections of PRD if needed
   - Read recent decisions

7. **Announce**

```
STARTING: {Task description}

Project: {project}
Epic: {epic}

Context loaded. Ready to work.

Acceptance criteria:
- {criterion 1}
- {criterion 2}
```

## What Gets Updated

| File | Change |
|------|--------|
| Epic file | Task status → `#in-progress` |
| Project `_index.md` | Current State → this task |
| `_manifest.md` | `Last Touched` → this project |

## If No Tasks Found

```
No matching task found for: {argument}

Did you mean:
- {suggestion 1}
- {suggestion 2}

Or use /claudemem plan to create a new project.
```

## Argument

$ARGUMENTS
