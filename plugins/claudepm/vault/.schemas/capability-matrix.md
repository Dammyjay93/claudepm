# Capability Matrix Schema

## File Location
`Projects/{project-id}/capability-matrix.md`

## Purpose

Exhaustive decomposition of every entity, capability, and state. This is the source of truth for what the product does. Epics and tasks are derived from this document.

## Required Frontmatter

```yaml
---
type: capability-matrix
project: {id}
version: {number}
created: {YYYY-MM-DD}
updated: {YYYY-MM-DD}  # Optional
---
```

## Template

```markdown
---
type: capability-matrix
project: {id}
version: 1
created: {YYYY-MM-DD}
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
  - {Edge case 2}

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

### Accessibility
- {requirement}

---

## Edge Cases Master List

| ID | Description | Affected Capabilities | Handling |
|----|-------------|----------------------|----------|
| E1 | {description} | {caps} | {how handled} |
```

## Capability ID Convention

Use entity prefix + number:
- U1, U2, U3 — User capabilities
- P1, P2, P3 — Post capabilities
- C1, C2, C3 — Comment capabilities

## State Enumeration

Every capability must have:
- **Trigger** — What initiates it
- **Inputs** — Data required (mark required vs optional)
- **Validation** — Rules that must pass
- **Loading** — UI state during operation
- **Success** — What happens on success
- **Errors** — Every possible error and its handling

Optional:
- **Edge Cases** — Unusual scenarios
- **Permissions** — Who can do this
- **Rate Limits** — Throttling rules

## Rules

1. **Complete before building** — The matrix should be done before implementation starts
2. **Exhaustive, not creative** — Describe what the system does, don't invent features
3. **States over stories** — "Show spinner" is more useful than "As a user..."
4. **Derive, don't invent** — Epics come from grouping capabilities
5. **Update as you learn** — If implementation reveals gaps, add to matrix first

## Relationship to Other Documents

| Document | Relationship |
|----------|--------------|
| PRD | Matrix expands PRD requirements into capabilities |
| Epics | Epics are derived by grouping capabilities |
| Tasks | Tasks trace to specific capabilities |
| Rules | Constraints that apply across capabilities |

## Completeness Checklist

Before implementation, verify:
- [ ] All entities identified
- [ ] Every entity has capabilities listed
- [ ] Every capability has all states enumerated
- [ ] Edge cases captured
- [ ] User journeys validate connections
- [ ] Non-functional requirements included
