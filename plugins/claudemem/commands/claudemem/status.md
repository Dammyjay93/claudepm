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
3. If active epic exists, read `~/Vault/Projects/{project}/Epics/{epic}.md`
   - Get task details, progress, approach
   - **NOTE**: Epics are ALWAYS in the `Epics/` subdirectory
4. Display formatted status

## Output Format

**REQUIRED**:
1. First, read `~/.claude/plugins/marketplaces/claudemem-marketplace/plugins/claudemem/.claude-plugin/plugin.json` to get the current version
2. Always start output with `CLAUDEMEM v{version}` header

Note: `${CLAUDE_PLUGIN_ROOT}` doesn't work in markdown commands (known bug). Use the full marketplace path.

### If Project Has Active Context

```
CLAUDEMEM v{version}

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
CLAUDEMEM v{version}

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
CLAUDEMEM v{version}

WORKSPACE OVERVIEW

Projects:
- {project 1}: {active task from its _index.md}
- {project 2}: {active task from its _index.md}

Last touched: {project from manifest}
```
