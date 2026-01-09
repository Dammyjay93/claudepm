---
description: Mark current task as complete
allowed-tools: Read, Write, Edit
---

# ClaudeMem Done

Mark the current task as complete and suggest next steps.

**Multi-session safe**: Updates only your project's files.

## Steps

1. **Read Current State**
   - Read `~/Vault/_manifest.md` for Last Touched project
   - Read `~/Vault/Projects/{project}/_index.md` for current task
   - Identify active task from **Current State** section

2. **If No Active Task**
   ```
   No task currently in progress.

   Use /claudemem start {task} to begin one.
   ```

3. **Mark Complete in Epic File** (`~/Vault/Projects/{project}/Epics/{epic}.md`)
   - **NOTE**: Epics are ALWAYS in the `Epics/` subdirectory
   - Change `- [ ]` to `- [x]` for the task
   - Change `#in-progress` to `#done`
   - Add completion date if desired

4. **Check Epic Status**
   - Count completed vs total tasks
   - If all tasks done, mark epic as `completed`

5. **Find Next Task**
   - Look for next `#pending` task in same epic
   - If epic done, look at next epic
   - Consider priority order

6. **Update Project's _index.md**
   - Update **Current State** section:
     - Active Epic → same or next
     - Active Task → next task or "None"
   - Update Epics list if epic completed

7. **Announce**

```
COMPLETED: {Task description}

Epic: {epic name}
Progress: {n}/{m} tasks ({percentage}%)

{If epic complete:}
EPIC COMPLETE: {epic name}

NEXT UP:
{Next task description}
Priority: {priority}

Continue? (y) or /claudemem status for overview
```

## What Gets Updated

| File | Change |
|------|--------|
| `Projects/{id}/Epics/{epic}.md` | Task → `[x] ... #done` |
| `Projects/{id}/_index.md` | Current State → next task |
| `_manifest.md` | Nothing (no epic/task stored there) |

## If Last Task in Project

```
COMPLETED: {Task description}

PROJECT COMPLETE: {project name}

All epics and tasks finished.

Summary:
- {n} epics completed
- {m} total tasks
- Started: {date}
- Finished: {today}

Use /claudemem save to write final session notes.
```
