# Epic Schema

## File Location
`Projects/{project-id}/Epics/{nn}-{slug}.md`

Example: `Projects/my-app/Epics/01-foundation.md`

## Purpose

Epics are **derived from the capability matrix**, not invented separately. Each epic groups related capabilities into an implementation unit.

## Required Frontmatter

```yaml
---
type: epic
id: {nn}-{slug}       # e.g., "01-foundation"
project: {project-id}
status: pending | in-progress | complete
priority: P0 | P1 | P2
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}  # Optional
---
```

## Template

```markdown
---
type: epic
id: {nn}-{slug}
project: {project}
status: pending
priority: P0
created: {YYYY-MM-DD}
---

# {Epic Name}

## Description

{What this epic accomplishes. 2-3 sentences.}

## Tasks

### {Section Name}
- [x] {Completed task} #done
- [ ] {Pending task} #pending #P0
- [ ] {Pending task} #pending #P1
  - Acceptance: {criteria from capability matrix}
  - Edge case: {edge case handling}

### {Section Name}
- [ ] {Task} #pending #P0
- [ ] {Task} #pending #P1

## Acceptance Criteria

- [ ] {High-level criterion}
- [ ] {High-level criterion}
```

## Task Format

```markdown
- [ ] Task description #status #priority
- [x] Completed task #done
```

### Task Tags

**Status**:
- `#pending` - Not started
- `#in-progress` - Currently working
- `#done` - Completed (use [x] too)
- `#blocked` - Waiting on dependency

**Priority**:
- `#P0` - Ship blocker
- `#P1` - Important
- `#P2` - Nice to have

## Deriving from Capability Matrix

1. **Group capabilities by domain**:
   - Auth capabilities → Foundation epic
   - Content CRUD → Content epic
   - Social capabilities → Social epic

2. **Each capability becomes task(s)**:
   - Capability X1: Create item → Task "Create item server action"
   - Include sub-tasks for loading, error, edge cases

3. **States become acceptance criteria**:
   - "Loading: button disabled, spinner"
   - "Error: show user-friendly message"
   - "Edge case: duplicate blocked"

## Epic Naming

| Number | Domain | Example |
|--------|--------|---------|
| 01-09 | Core/Foundation | 01-foundation, 02-content |
| 10-19 | Features | 10-social, 11-search |
| 20-29 | Platform | 20-extension, 21-mobile |
| 30-39 | Growth | 30-landing, 31-marketing |
| 40-49 | Quality | 40-testing, 41-accessibility |
| 50-59 | Operations | 50-devops, 51-monitoring |

## Rules

1. Epic filenames start with 2-digit number
2. Epics derived from capability matrix, not invented
3. Tasks include acceptance criteria from matrix
4. Mark [x] when complete + add #done
5. Update epic status when all P0 tasks complete
