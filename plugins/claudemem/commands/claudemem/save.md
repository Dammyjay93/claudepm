---
description: Save session notes and update manifest
allowed-tools: Read, Write, Edit, Bash
---

# ClaudeMem Save

Write session notes capturing what was accomplished.

**Multi-session safe**: Updates your project's `_index.md` and adds to manifest's Recent Sessions. Other sessions' states are unaffected.

## Steps

1. **Gather Session Data**
   - Read `~/Vault/_manifest.md` for Last Touched project
   - Read project's `_index.md` for current state
   - Review conversation for:
     - What was discussed
     - What was built/changed
     - Decisions made
     - Problems encountered
     - What's next

2. **Update Project State**

   Edit `~/Vault/Projects/{id}/_index.md`:
   - Update **Current State** section with latest epic/task
   - This preserves your work for next session

3. **Create Session File**

File: `~/Vault/Sessions/{YYYY-MM-DD}.md`

If file exists for today, create `{YYYY-MM-DD}-2.md` etc.

```yaml
---
type: session
date: {YYYY-MM-DD}
project: {active project or "general"}
started: {session start time if known}
ended: {now}
---

# Session: {YYYY-MM-DD}

## Summary
{2-3 sentence summary of the session}

## Completed
- [x] {Task or action completed}
- [x] {Another completed item}

## In Progress
- [ ] {Unfinished work}

## Decisions Made
- **{Topic}**: {Decision and rationale}

## Blockers Encountered
- {Blocker} → {Resolution or "Unresolved"}

## Next Session
- [ ] {First priority for next time}
- [ ] {Second priority}

## Notes
{Any additional observations, learnings, context}
```

4. **Update Manifest**
   - Add entry to Recent Sessions table
   - Keep only last 10 sessions in table
   - Update `Last Touched` to current project
   - Update timestamp

5. **Announce**

```
SESSION SAVED: {date}

Summary: {brief summary}

Completed: {n} items
Next time: {first next item}

Project state: ~/Vault/Projects/{id}/_index.md
Session notes: ~/Vault/Sessions/{date}.md
```

## Auto-Save Triggers

Consider saving when:
- User says "done for today" / "stopping" / "that's it"
- Switching to a different project
- Before `/claudemem switch`
- Long pause in conversation
