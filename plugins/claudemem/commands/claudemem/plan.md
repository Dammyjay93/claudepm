---
description: Create a project from the current conversation - generates PRD, epics, and tasks
allowed-tools: Read, Write, Bash, Glob
argument-hint: [project-name]
---

# ClaudeMem Plan

Create a structured project from the conversation.

**Multi-session safe**: Creates new project files. Other sessions are unaffected.

## Steps

1. **Analyze Conversation**
   - Identify the product/feature being discussed
   - Extract requirements, decisions, and scope
   - Determine technical approach

2. **Generate Project ID**
   - Use argument if provided: `$ARGUMENTS`
   - Otherwise derive from project name (kebab-case)
   - Verify no duplicate exists in `~/Vault/Projects/`

3. **Create Project Structure**

```bash
mkdir -p ~/Vault/Projects/{id}/Epics
```

4. **Create Files**

### _index.md
```yaml
---
type: project
id: {id}
name: {Name}
status: active
priority: P1
created: {today}
brief: {1-2 sentence summary}
---

# {Project Name}

## Overview
{Brief description}

## Current State
- **Active Epic**: {first epic or "None"}
- **Active Task**: {first task or "None"}
- **Blockers**: None

## Epics
{List of epics}

## Quick Links
- [PRD](./PRD.md)
- [Decisions](./Decisions.md)
```

### PRD.md
```yaml
---
type: prd
project: {id}
version: 1
created: {today}
---

# {Project Name}

## Problem
{What problem does this solve}

## Solution
{High-level solution}

## Requirements
{Extracted from conversation}

## Non-Goals
{What we're explicitly not doing}

## Technical Approach
{Stack, architecture decisions}
```

### Decisions.md
```yaml
---
type: decisions
project: {id}
---

# Architecture Decisions

## {today}: Initial Decisions
{Decisions made during planning}
```

### Epics
Create epic files based on logical groupings:
- `01-{name}.md` - Foundation/setup
- `02-{name}.md` - Core functionality
- etc.

Each epic contains tasks as checkboxes.

5. **Update Manifest**
   - Add project to Projects table
   - Set `Last Touched` → new project (not "Active Context")
   - Update timestamp

6. **Announce Result**

```
PROJECT CREATED: {Name}

{Brief}

Epics:
1. {Epic 1} ({n} tasks)
2. {Epic 2} ({n} tasks)
...

Total: {n} epics, {m} tasks

Ready to start? First task: {first task}
```

## What Gets Created/Updated

| File | Action |
|------|--------|
| `Projects/{id}/_index.md` | Created with Current State |
| `Projects/{id}/PRD.md` | Created |
| `Projects/{id}/Decisions.md` | Created |
| `Projects/{id}/Epics/*.md` | Created |
| `_manifest.md` | Add to Projects table, set Last Touched |

## Rules

- Extract from conversation, don't invent
- Be specific in task descriptions
- Include acceptance criteria for epics
- Set realistic priorities (not everything is P0)
- If unclear, ask before creating

## Argument

$ARGUMENTS
