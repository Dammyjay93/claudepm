---
description: Show current project, epic, and task status
allowed-tools: Read, Glob
---

# ClaudeMem Status

Show the current workspace state.

**Multi-session note**: State comes from project files, not manifest. Your session's context is independent of other sessions.

## Steps

1. Read `~/Vault/_manifest.md`
   - Get `Last Touched` project hint
   - Get list of all projects
2. If last touched project exists, read `~/Vault/Projects/{project}/_index.md`
   - Get **Current State** section (active epic/task)
3. If active epic exists, read the epic file for task details
4. Display formatted status

## Output Format

### If Project Has Active Context

```
PROJECT: {Project Name}
Status: {status} | Priority: {priority}

EPIC: {Epic Name}
Progress: {completed}/{total} tasks ({percentage}%)

CURRENT TASK:
{Task description}
Priority: {priority}
Status: {status}

NEXT UP:
1. {Next task}
2. {Following task}

BLOCKERS:
{List blockers or "None"}
```

### If No Active Context

```
NO ACTIVE PROJECT

Recent Activity:
{List recent sessions from manifest}

Available Projects:
{List projects with status}

Use /claudemem switch {project} to select one.
```

### Multi-Session Info

If you want to show all projects' states:
```
WORKSPACE OVERVIEW

Projects:
- {project 1}: {active task from its _index.md}
- {project 2}: {active task from its _index.md}

Last touched: {project from manifest}
```
