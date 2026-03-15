---
description: Save session notes and update manifest
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, mcp__linear__save_issue, mcp__linear__get_issue, mcp__linear__list_issues, mcp__linear__get_project, mcp__linear__list_cycles
---

# ClaudePM Save

End the session. Save everything. Update all relevant files. Commit changes.

**Multi-session safe**: Updates your project's files. Other sessions' states are unaffected.

## Vault Resolution

Determine the vault path:
1. `$CLAUDEPM_VAULT` environment variable
2. Fall back to `~/.claudepm/`

Read `{vault}/manifest.md` to get the active project and tracker mode.

## CRITICAL: Exhaustive Saves Are Mandatory

Every `/claudepm save` MUST update ALL relevant files. No shortcuts. No partial saves.

## Required Files Checklist

Before announcing, verify EVERY applicable item:

- [ ] `{vault}/manifest.md` — Active context, last_active date, Recent Sessions table
- [ ] `{vault}/projects/{id}/_index.md` — Current State, Key Decisions, updated timestamp
- [ ] `{vault}/projects/{id}/specs/{spec}.md` — If active spec: status, decisions made during build
- [ ] `{vault}/projects/{id}/epics/{active}.md` — If active epic: task checkboxes, status
- [ ] `{vault}/projects/{id}/rules.md` — If new constraints established
- [ ] `{vault}/sessions/{YYYY-MM-DD}-{project}.md` — Detailed session notes
- [ ] Tracker — Mark completed tasks as done, in-progress tasks as in-progress
- [ ] Project repo — Git commit with descriptive message
- [ ] Vault — Git commit session changes (if vault is a git repo)

## Steps

### 1. Gather Session Data

Read ALL of these files first:
- `{vault}/manifest.md`
- `{vault}/projects/{id}/_index.md`
- `{vault}/projects/{id}/rules.md`
- Active spec file (if feature work) OR active epic file (if non-feature work)

Then review conversation for:
- What was built/changed/explored
- Decisions made (and their type — see Decision Routing in SKILL.md)
- Tasks completed
- Spec gaps discovered and resolved
- What's next

### 2. Update Spec (If Feature Work)

**Decisions made during build go into the spec:**
- Ambiguity resolved during implementation → add to relevant spec section
- User journey discovered incomplete → add missing scenario
- Data constraint changed → update Data Design

**Status transitions:**
- Spec was being written → all required sections done → `status: specced`
- Build started this session → `status: building`
- Feature shipped this session → `status: shipped`, `shipped: {today}`

**Drift check:**
- Compare key spec decisions against what was actually built
- If code diverges from spec (e.g., spec says modal but code uses push), flag it:
  - "Drift detected: spec says X, code does Y. Update spec or fix code?"
  - Resolve before saving

### 3. Update Tracker

Tracker-specific sync:

#### local
- Read the Tasks table in `{vault}/projects/{id}/_index.md`
- Verify statuses match actual work done this session
- Update any tasks that were completed or started but not yet marked
- Add new tasks discovered during the session

#### linear
- Verify incremental updates were applied (issues should already be In Progress or Done from "update as you go")
- Query Linear and fix any discrepancies
- Check sub-issue completion: if all sub-issues done → mark parent Done
- Note cycle progress: which issues done vs remaining this week

#### github
- Run `gh issue list` to verify statuses
- Close completed issues: `gh issue close N`
- Add comments to in-progress issues if significant context exists

#### external
- List all task status changes from this session
- Output as a reminder: "Update your tracker with these changes: ..."

### 4. Update Project Index

**File**: `{vault}/projects/{id}/_index.md`

- `updated:` → today
- **Current State**: Last Session, Active Spec/Epic, Active Task, Blockers, Next
- **Key Decisions** table → add if major decision (curated ~10)
- **Active Stances** → update if changed

### 5. Update Epic File (If Non-Spec Work)

- Check off completed tasks
- Update statuses
- Update epic frontmatter if changed

### 6. Update Rules (If Needed)

Only if new constraint established or existing rule changed. Update in place.

### 7. Create Session File

**File**: `{vault}/sessions/{YYYY-MM-DD}-{project}.md`

If multiple sessions in one day, append a letter: `{YYYY-MM-DD}b-{project}.md`

Session files must be DETAILED:

```yaml
---
type: session
date: {YYYY-MM-DD}
project: {project id}
feature: {spec id, if applicable}
tracker: {tracker mode}
---

# Session: {Project Name} - {Brief Topic}

## Summary
{2-3 sentence overview}

## Context
{Why this work was started}

## Work Done
{Detailed description with file paths, findings}

## Decisions
- **{Topic}**: {Decision and rationale}

## Spec Updates
{What was added/changed in the spec, if applicable}

## Status
- [x] {Completed item}
- [ ] {Pending item}

## Tracker Updates
{Tracker-specific:}

{For local:}
- Task {id}: {title} → done
- Task {id}: {title} → in-progress

{For linear:}
- {Issue ID}: {title} → Done
- {Issue ID}: {title} → In Progress
- Cycle: {n}/{m} issues complete this week

{For github:}
- #{number}: {title} → closed
- #{number}: {title} → in progress

{For external:}
Reminder: update your tracker with the changes above.

## Next Steps
1. {First priority}
2. {Second priority}
```

### 8. Clean Up Audit Gate Markers

If `.claudepm/.audit-gates` exists in the project repo, remove it:
```bash
rm -f .claudepm/.audit-gates
```

### 9. Update Manifest

- `## Active Context` → current project/epic/task
- Projects table → update `last_active`
- Recent Sessions → add row at TOP
- Prune Recent Sessions to last 15 entries

### 10. Git Commits

**Project repo** (if dirty):
```bash
cd {repository}
git add -A
git commit -m "{descriptive message based on session work}"
```

The commit message should describe what was built, not just "session save":
- Good: `feat: reviews table, RLS policies, rating trigger`
- Bad: `session save`

**Do NOT push automatically.** Committing is safe and local. Pushing affects shared state — let the user decide.

**Vault** (if it's a git repo):
```bash
git -C {vault} add -A && git -C {vault} commit -m "session: {YYYY-MM-DD} {project} — {brief summary}" 2>/dev/null
```

If vault commit fails (e.g., no git repo), silently skip — not all users track their vault with git.

### 11. Announce

```
SESSION SAVED

Project: {name}
Session: {brief topic}
{If spec updated: "Spec: {what changed}"}
{If task completed: "COMPLETED: {description}"}

Files Updated:
  {vault}/manifest.md
  {vault}/projects/{id}/_index.md
  {vault}/sessions/{date}-{project}.md (created)
  {If spec: {vault}/projects/{id}/specs/{spec}.md}

Git:
  {repo}: committed "{message}" ({n} files changed)
  {If vault is git: Vault: committed "session: {date} {project}"}

Tracker: {summary of tracker updates}
Rules: {Updated | No changes}

Next: {first next step}
```

## Decision Routing

| Decision type | Where it goes | Growth pattern |
|---------------|---------------|----------------|
| Enforced constraint | `rules.md` | Update in place |
| Major product decision | `_index.md` Key Decisions | Curated (max ~10) |
| Current stance | `_index.md` Active Stances | Update in place |
| Feature decision | Spec file (relevant section) | Lives with spec |
| Epic-specific approach | Epic Approach section | Lives with epic |
| Context/rationale | Session notes | Accumulates |

## Auto-Save Triggers

Save when:
- User says "done for today" / "stopping" / "save"
- Switching to a different project
- Significant milestone reached

## Common Mistakes to Avoid

1. **Skipping spec updates** — Decisions during build MUST go into the spec
2. **Not checking drift** — If code differs from spec, resolve before saving
3. **Skipping tracker updates** — Completed tasks must be marked done
4. **Minimal session files** — Be detailed, this is historical record
5. **Bad commit messages** — Describe the work, not "session save"
6. **Auto-pushing** — Commit is safe, push needs user confirmation
7. **Announcing before completing** — Verify ALL files updated first
8. **Calling Linear MCP when tracker is not linear** — Check tracker mode first
