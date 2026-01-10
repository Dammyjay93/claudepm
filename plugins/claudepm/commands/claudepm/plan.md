---
description: Create a project from the current conversation - generates PRD, epics, and tasks
allowed-tools: Read, Write, Bash, Glob
argument-hint: [project-name]
---

# ClaudePM Plan

Create a structured project from the conversation.

**Multi-session safe**: Creates new project files. Other sessions are unaffected.

## Steps

1. **Analyze Conversation**
   - Identify the product/feature being discussed
   - Extract requirements, decisions, and scope
   - Determine technical approach
   - Identify entities and their capabilities

2. **Generate Project ID**
   - Use argument if provided: `$ARGUMENTS`
   - Otherwise derive from project name (kebab-case)
   - Verify no duplicate exists in `~/Vault/Projects/`

3. **Detect Repository Location**
   - Check if current working directory contains `.git` → use cwd as repository
   - If no git repo detected, ask user: "Where is the code for this project? (path or 'none')"
   - If user says 'none' or project has no code yet → omit repository field
   - **NEVER guess paths like `/work/{id}`** — always detect or ask

4. **Create Project Structure**

```bash
mkdir -p ~/Vault/Projects/{id}/Epics
```

5. **Create Files**

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
repository: {path}  # ONLY include if detected from cwd or provided by user
stack: [{technologies}]
---

# {Project Name}

## Overview
{Brief description}

## Current State
- **Phase**: Planning
- **Active Epic**: None
- **Active Task**: None
- **Blockers**: None

## Active Stances

| Domain | Stance | Source |
|--------|--------|--------|
| {domain} | {current stance} | rules.md §{section} |

## Key Decisions

| Decision | Rationale | Revisit if |
|----------|-----------|------------|
| {decision} | {why} | {conditions for reconsideration} |

## Epics
{List of epics with progress counts}

## Quick Links
- [PRD](./PRD.md)
- [Capability Matrix](./capability-matrix.md)
- [Rules](./rules.md)
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

## Target User
{Who is this for}

## Requirements

### P0 (Must Have)
| Requirement | Notes |
|-------------|-------|
| {requirement} | {context} |

### P1 (Should Have)
| Requirement | Notes |
|-------------|-------|
| {requirement} | {context} |

## Non-Goals
{What we're explicitly not doing}

## Success Metrics
| Metric | Target | How to Measure |
|--------|--------|----------------|
| {metric} | {target} | {method} |

## Technical Constraints
{Stack, architecture decisions}
```

### capability-matrix.md
```yaml
---
type: capability-matrix
project: {id}
version: 1
created: {today}
---

# Capability Matrix

## Entities

1. {Entity 1} — {brief description}
2. {Entity 2} — {brief description}

---

## {Entity 1}

### {ID}: {Capability Name}

- **Trigger**: {what initiates this}
- **Inputs**: {required and optional inputs}
- **Validation**: {validation rules}
- **Loading**: {loading state behavior}
- **Success**: {success state behavior}
- **Errors**:
  - {Error 1} → {handling}
  - {Error 2} → {handling}
- **Edge Cases**:
  - {Edge case 1}

---

## User Journeys

### {Journey Name}
1. {Step 1} ({capability ID})
2. {Step 2} ({capability ID})

---

## Non-Functional Requirements

### Performance
- {metric}: {target}

### Security
- {requirement}
```

### rules.md
```yaml
---
type: rules
project: {id}
updated: {today}
---

# Rules

Enforced constraints. Update in place, never append.

## Product
- {product constraint}

## UI
- {ui pattern/rule}

## Engineering
- {engineering standard}
```

### Epics
Create epic files based on capability matrix groupings:
- `01-{name}.md` - Foundation/setup
- `02-{name}.md` - Core functionality
- etc.

Each epic is derived from related capabilities in the matrix:

```yaml
---
type: epic
id: {id}
project: {project-id}
status: pending
priority: {P0/P1/P2}
created: {today}
---

# {Epic Name}

## Description
{What this epic accomplishes — derived from capability matrix}

## Tasks
- [ ] {Task derived from capability} #pending #{priority}
  - Acceptance: {from capability states}

## Acceptance Criteria
- [ ] {Criterion from capability matrix}
```

6. **Update Manifest**
   - Add project to Projects table
   - Set `Last Touched` → new project
   - Update timestamp

7. **Announce Result**

```
PROJECT CREATED: {Name}

{Brief}

Documents:
- PRD.md (requirements)
- capability-matrix.md (exhaustive decomposition)
- rules.md (constraints)

Epics:
1. {Epic 1} ({n} tasks)
2. {Epic 2} ({n} tasks)
...

Total: {n} epics, {m} tasks

Next: Review capability-matrix.md for completeness, then start first task.
```

## What Gets Created/Updated

| File | Action |
|------|--------|
| `Projects/{id}/_index.md` | Created with Active Stances, Key Decisions |
| `Projects/{id}/PRD.md` | Created |
| `Projects/{id}/capability-matrix.md` | Created with entities and capabilities |
| `Projects/{id}/rules.md` | Created with Product/UI/Engineering sections |
| `Projects/{id}/Epics/*.md` | Created, derived from capability matrix |
| `_manifest.md` | Add to Projects table, set Last Touched |

## Rules

- Extract from conversation, don't invent
- Identify entities first, then enumerate capabilities
- Be exhaustive with capability states (trigger, loading, success, errors)
- Derive epics from capability groupings
- Include acceptance criteria from capability states
- Set realistic priorities (not everything is P0)
- If unclear, ask before creating
- Key Decisions should have revisit triggers

## Argument

$ARGUMENTS
