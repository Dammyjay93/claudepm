# ClaudePM — Session Memory & Spec Discipline

Use this skill when working in a project managed by ClaudePM. It teaches how to maintain context across sessions, follow the spec-first workflow, and adapt to the user's tracker.

## What ClaudePM Is (and Is Not)

**ClaudePM manages project state** — decisions, specs, sessions, tasks, and context that persists across conversations.

**Claude's built-in MEMORY.md manages user preferences** — how the user works, cross-project patterns, personal style.

| If the information is about... | It belongs in... |
|-------------------------------|-----------------|
| How the user likes to work | MEMORY.md |
| A project decision (API choice, schema design) | ClaudePM spec or _index.md |
| A user preference (no emojis, terse responses) | MEMORY.md |
| What was built this session | ClaudePM session file |
| A cross-project pattern (always use Supabase) | MEMORY.md |
| An active stance for a specific project | ClaudePM _index.md |

Never duplicate between them. If unsure, ask: "Is this about the person or the project?"

## How ClaudePM Differs from CLAUDE.md

CLAUDE.md is **static instructions** — you write it once and update it manually. It tells Claude how to behave.

ClaudePM is **dynamic state** — it updates every session automatically. It tells Claude what happened, what was decided, and what's next.

CLAUDE.md: "Use TypeScript strict mode."
ClaudePM: "Last session we migrated 3 tables to the new schema. Task 5 is Done. Next: Task 6."

Both work together. CLAUDE.md sets the rules. ClaudePM tracks the game.

## Vault Location

ClaudePM stores project files in a "vault" — a directory of markdown files.

**Resolution order:**
1. `$CLAUDEPM_VAULT` environment variable (if set)
2. `~/.claudepm/` (default)

The vault is just a directory. It doesn't require Obsidian, VS Code, or any specific editor. Any tool that reads markdown works.

## Tracker Modes

ClaudePM tracks tasks using whatever the user already uses. The tracker mode is stored in the manifest frontmatter.

### local (default)

Tasks are markdown tables in each project's `_index.md`:

```markdown
## Tasks

| id | title | status | priority |
|----|-------|--------|----------|
| 1 | Fix auth flow | in-progress | P0 |
| 2 | Add onboarding | todo | P1 |
```

When creating tasks: add rows. When updating: edit the status column. When listing: read the table.

Status values: `todo`, `in-progress`, `done`, `blocked`

### linear

Full integration via Linear MCP tools. Issues, cycles, sub-issues, sprint planning.

**Required:** Linear MCP server must be installed and connected.

When creating tasks: `mcp__linear__save_issue`
When updating: `mcp__linear__save_issue` with status change
When listing: `mcp__linear__list_issues`

Sub-issue hygiene:
- Sub-issues MUST be **Todo** (not Backlog — Backlog hides from cycle views)
- Sub-issues MUST be assigned to same **cycle** as parent
- Parent estimate: 0 if zero estimates enabled, else minimum (1)
- Work on sub-issues individually. Parents are containers.

### github

Track work via `gh` CLI. Good for open source or GitHub-native workflows.

**Required:** `gh` CLI must be installed and authenticated.

When creating tasks: `gh issue create --title "..." --label "priority:P0"`
When updating: `gh issue edit N --add-label "status:done"`
When listing: `gh issue list`

### external

ClaudePM doesn't manage the tracker. After completing work, remind the user:
"Update your tracker: [task description] is now [status]"

## Decision Routing

Every decision has exactly one home. This prevents "where did we decide that?"

| Decision type | Where it lives | Growth pattern |
|---------------|---------------|----------------|
| Enforced constraint | `rules.md` | Update in place |
| Major product decision | `_index.md` Key Decisions | Curated ~10 max |
| Current stance | `_index.md` Active Stances | Update in place |
| Feature decision | Spec file (relevant section) | Lives with spec |
| Epic-specific approach | Epic Approach section | Lives with epic |
| Context/history | Session notes | Accumulates |

## Audit Gate

Before editing source code to fix a bug, output these four fields:

1. **Bug** — Pattern claim. Specific code, file:line, what's wrong.
2. **Execution Path** — User action to bug site. Each step: file:line, verified by searching callers.
3. **User Symptom** — What the user actually experiences. Not hypothetical.
4. **Platform** — Target (mobile/web/API) + mechanism (CORS? TypeScript types? Runtime error?).

**Stop conditions** (require user decision before proceeding):
- Execution Path = no live callers (dead code)
- User Symptom = none (pattern without impact)
- Platform = does not apply (e.g., CORS on a mobile app using Dio)

**Pattern is not impact.** "This code is wrong" (pattern) is not the same as "this breaks X for users" (impact). Make impact claims only with a proven execution path.

**Why This Matters.** After filling the four fields, write a plain-language summary of why this issue matters. Not technical jargon — what the user experiences and why fixing it is worth the time. This goes in the tracker description (Linear issue, GitHub issue, or local task notes) so anyone reading it understands the impact without parsing the audit. Write this during the audit, after reading the code — not before, and not from assumptions.

After completing the audit gate, write a marker file so the gate survives context compaction:

```bash
mkdir -p .claudepm
echo "{task-id}: $(date -u +%Y-%m-%dT%H:%M:%SZ)" >> .claudepm/.audit-gates
```

The save command cleans up `.claudepm/.audit-gates` at session end.

## Issue Workflow

Every issue follows: **Audit -> Gate -> Code -> Test -> Run -> Mutate -> Commit**

1. **Audit** — Read every file the issue touches. Map dependencies, callers, blast radius.
2. **Gate** — Output the 4-field structured audit gate. Check stop conditions. Write the "Why This Matters" summary and update the tracker description.
3. **Code** — Write the implementation. Stay focused on issue scope.
4. **Test** — Launch a subagent with only the issue spec + test helpers. Subagent writes tests without reading implementation.
5. **Run** — All tests must pass. Fix code, not tests.
6. **Mutate** — Launch a subagent to introduce 3-5 targeted mutations, verify tests catch them.
7. **Commit** — Only after tests + mutations pass. Include task ID in message.

**When you notice something out of scope:**
- Never silently skip it. Create a task immediately (in whatever tracker the user uses).
- Never fix it inline. Scope creep introduces risk.

## Spec Tiers

Specs are sized to the blast radius. Auto-classify based on the feature, then explain why:

"This touches your database schema, so it's a Tier 2 spec. That means we need to spec out the data design, but we can skip policy matrices and failure mode analysis."

| Tier | When | Required Sections |
|------|------|------------------|
| 1 | Multiple repos OR auth/payments | Why, Success, Scope, User Journeys, Data Design, Policy Design, Contracts, Failure Modes, Build Order, Release |
| 2 | Single repo + DB changes | Why, Success, Scope, User Journeys, Data Design, Build Order, Release |
| 3 | No DB changes, contained UI | Why, Success, Scope, User Journeys, Build Order, Release |

## Drift Detection

During save, compare spec decisions against actual code:
- Read key decisions from the spec
- Check if the code matches
- Flag divergences: "Drift detected: spec says modal, code uses bottom sheet. Update spec or fix code?"

Resolve before saving. Unresolved drift accumulates into confusion.

## Archiving

### Sessions
Sessions older than 30 days can be moved to `sessions/archive/`. The save command keeps the last 20 sessions in the main directory.

### Projects
Set `status: archived` in the project's `_index.md`. Archived projects are excluded from session boot context loading.

### Manifest
Keep the last 15 session entries in the manifest's Recent Sessions table. Older entries live only in session files.

## File Structure

```
{vault}/
├── manifest.md                    # Project registry + active context
├── .schemas/                      # File format schemas
├── projects/
│   └── {project}/
│       ├── _index.md              # Dashboard: state, stances, decisions, tasks
│       ├── PRD.md                 # Problem, solution, requirements
│       ├── rules.md               # Enforced constraints
│       ├── specs/
│       │   └── F01-feature.md     # Feature specification
│       └── epics/
│           └── 01-foundation.md   # Non-feature work
└── sessions/
    └── 2026-03-15-project.md      # Session history
```
