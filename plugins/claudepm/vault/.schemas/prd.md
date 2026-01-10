# PRD Schema

## File Location
`Projects/{project-id}/PRD.md`

## Purpose

Define the problem, solution, and boundaries. **High-level only.** No implementation details, no task lists. The capability matrix handles exhaustive decomposition.

## Required Frontmatter

```yaml
---
type: prd
project: {id}
version: {number}
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}  # Optional
---
```

## Template

```markdown
---
type: prd
project: {id}
version: 1
created: {YYYY-MM-DD}
---

# {Project Name} - PRD

## Problem

{What's broken? Why does this need to exist?}
{2-3 paragraphs max. Be specific about pain points.}

## Solution

{How does this product solve it? What's the core insight?}
{2-3 paragraphs max. Focus on the "why this approach" not "how it works."}

## Target User

{Who is this for? Be specific.}

- **Demographics/Role**: {who they are}
- **Behaviors**: {what they do}
- **Pain Points**: {what frustrates them}
- **Current Solutions**: {what they use today, why it fails}

## Requirements

### P0 (Must Have)

| Requirement | Notes |
|-------------|-------|
| {requirement} | {context} |

### P1 (Should Have)

| Requirement | Notes |
|-------------|-------|
| {requirement} | {context} |

### P2 (Nice to Have)

| Requirement | Notes |
|-------------|-------|
| {requirement} | {context} |

## Non-Goals

What this product will NOT do. Important for scope.

- {Non-goal 1}
- {Non-goal 2}
- {Non-goal 3}

## Success Metrics

| Metric | Target | How to Measure |
|--------|--------|----------------|
| {metric} | {target} | {method} |

## Technical Constraints

{Stack decisions, infrastructure limits, budget constraints, etc.}

| Constraint | Rationale |
|------------|-----------|
| {constraint} | {why} |

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| {risk} | H/M/L | H/M/L | {mitigation} |
```

## Rules

1. PRD stays **high-level** — no implementation details
2. Requirements are "what", not "how"
3. Non-goals are as important as goals (scope control)
4. Success metrics must be measurable
5. Version number increments on major changes

## PRD vs Capability Matrix

| PRD | Capability Matrix |
|-----|-------------------|
| What and why | How (exhaustively) |
| High-level requirements | Every capability, state, edge case |
| Target user | User journeys |
| Success metrics | Performance targets |

**PRD comes first, Capability Matrix expands it.**
