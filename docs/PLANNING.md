# Planning Methodology

ClaudePM uses a systematic approach to project planning that prevents the common problem of discovering missing features during implementation.

---

## The Problem with Typical Planning

Most planning follows this pattern:
1. Write a PRD with requirements
2. Break into epics and tasks
3. Start building
4. Discover gaps mid-implementation
5. Patch and extend scope

This fails because PRDs describe the happy path. Edge cases, error states, and secondary features get discovered during implementation.

---

## The Capability Matrix Approach

ClaudePM inverts this. Instead of describing what the product does (PRD), we exhaustively enumerate what each entity in the system can do (Capability Matrix).

**The decomposition:**

```
Entity → Capabilities → States → Edge Cases
```

For every entity:
- List every capability (not just CRUD — every action)
- For each capability, enumerate every state: trigger, validation, loading, success, errors
- Identify edge cases before they become bugs

This produces exhaustive coverage. Epics and tasks are *derived* from the matrix, not invented separately.

---

## Document Structure

ClaudePM uses three planning documents:

| Document | Purpose | Growth Pattern |
|----------|---------|----------------|
| `PRD.md` | What and why (high-level) | Static after planning |
| `capability-matrix.md` | Every capability, state, edge case | Complete before building |
| `rules.md` | Enforced constraints | Update in place |

**PRD** stays high-level. It describes the problem, solution, target user, and success metrics. No implementation details.

**Capability Matrix** is exhaustive. It captures every entity, capability, and state. This is where the real planning happens.

**Rules** captures constraints that must be enforced. These are updated during implementation as decisions are made.

**Epics** are derived from the capability matrix, not invented. Each epic groups related capabilities. Tasks include acceptance criteria from the matrix.

---

## Building a Capability Matrix

### Step 1: Identify Entities

List every entity in your system. Think nouns, not features:

- User
- Post
- Comment
- Notification
- Subscription

### Step 2: List Capabilities per Entity

For each entity, list every capability. Go beyond CRUD:

**Post:**
- Create (draft, publish)
- Read (single, list, search)
- Update (content, metadata)
- Delete (soft, hard)
- Archive
- Restore
- Export
- Share

### Step 3: Enumerate States per Capability

For each capability, enumerate every state:

```markdown
### P1: Create Post

- **Trigger**: New post button, keyboard shortcut
- **Inputs**: Title (required), content (required), tags (optional)
- **Validation**: Title length, content not empty
- **Loading**: Disable submit, show spinner
- **Success**: Add to list, show confirmation, redirect to post
- **Errors**:
  - Validation failed → Show field errors
  - Network failure → Save as draft locally
  - Session expired → Prompt re-auth
- **Edge Cases**:
  - Very long content (>100k chars)
  - Special characters in title
  - Creating while offline
```

### Step 4: Add User Journeys

Include 3-5 critical user journeys to validate the capabilities connect properly:

```markdown
## User Journeys

### New User Onboarding
1. User signs up (U1)
2. Completes profile (U2)
3. Creates first post (P1)
4. Views dashboard (P2)

### Content Management
1. User opens dashboard (P2)
2. Creates new post (P1)
3. Adds tags (P3)
4. Publishes (P4)
```

### Step 5: Capture Non-Functional Requirements

Add a section for cross-cutting concerns:

```markdown
## Non-Functional Requirements

### Performance
- Page load: <2s
- Search results: <200ms
- Save operation: <500ms

### Security
- All API calls authenticated
- No PII in logs
- HTTPS only
```

---

## Deriving Epics

Once the capability matrix is complete, epics become obvious groupings:

| Capability Group | Epic |
|------------------|------|
| U1-U5 (User) | 01-foundation |
| P1-P8 (Post) | 02-posts |
| C1-C6 (Comment) | 03-comments |
| N1-N4 (Notification) | 04-notifications |

Each task in an epic traces to a capability in the matrix. Acceptance criteria come directly from the states enumerated.

---

## Example Capability Matrix

```markdown
---
type: capability-matrix
project: my-app
version: 1
created: 2026-01-10
---

# Capability Matrix

## Entities

1. User — Authentication, profile, preferences
2. Post — Core content unit
3. Comment — User interactions
4. Notification — System alerts

---

## User

### U1: Sign Up
- **Trigger**: Landing page CTA
- **Inputs**: Email, password
- **Validation**: Email format, password strength
- **Loading**: Disable button, show spinner
- **Success**: Create account, redirect to onboarding
- **Errors**: Email taken, weak password, network failure

### U2: Sign In
- **Trigger**: Login page, session expired redirect
- **Inputs**: Email, password
- **Validation**: Required fields
- **Loading**: Disable button
- **Success**: Create session, redirect to dashboard
- **Errors**: Invalid credentials, account locked, network failure

---

## Post

### P1: Create Post
...

### P2: List Posts
...

---

## User Journeys

### J1: First-Time User
1. User lands on marketing page
2. Signs up (U1)
3. Completes onboarding
4. Creates first post (P1)
5. Views dashboard (P2)

---

## Non-Functional Requirements

### Performance
- Dashboard load: <2s on 3G
- Search: <200ms

### Accessibility
- WCAG 2.1 AA compliance
- Keyboard navigation
```

---

## Checklist

Before starting implementation, verify:

- [ ] All entities identified
- [ ] Every capability has trigger, inputs, validation, loading, success, errors
- [ ] Edge cases enumerated
- [ ] User journeys validate capability connections
- [ ] Non-functional requirements captured
- [ ] Epics derived (not invented)
- [ ] Tasks trace to capabilities

---

## Tips

1. **Be exhaustive, not creative** — The matrix should describe reality, not invent features
2. **States over stories** — "Loading: show spinner" is more useful than "As a user, I want to see loading state"
3. **Edge cases are requirements** — If you think of it, write it down
4. **Derive, don't invent** — Epics and tasks come from the matrix, not imagination
5. **Update as you learn** — If implementation reveals a gap, add it to the matrix first
