---
description: Create a project or feature spec from the current conversation
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, EnterPlanMode, ExitPlanMode, AskUserQuestion, mcp__linear__save_issue, mcp__linear__get_issue, mcp__linear__list_issues, mcp__linear__save_project, mcp__linear__get_project, mcp__linear__list_projects, mcp__linear__list_teams, mcp__linear__create_issue_label, mcp__linear__save_milestone, mcp__linear__list_milestones
argument-hint: [project-name | feature-name]
---

# ClaudePM Plan

Create a structured project or feature spec from the conversation.

**Multi-session safe**: Creates new files. Other sessions are unaffected.

## Vault Resolution

Determine the vault path:
1. `$CLAUDEPM_VAULT` environment variable
2. Fall back to `~/.claudepm/`

Read `{vault}/manifest.md` to get the active project and tracker mode.

## Determine Mode

**Auto-detect based on context:**

1. If no active project exists in the manifest → **Mode 1: New Project**
2. If an active project exists AND argument looks like a feature name → **Mode 2: New Feature (Spec)**
3. If ambiguous, ask: "Are you planning a new project, or a new feature for {active project}?"

---

## Mode 1: New Project

### Steps

1. **Analyze Conversation** — Identify product, requirements, decisions, scope, tech approach.

2. **Generate Project ID** — Use argument `$ARGUMENTS` or derive from name (kebab-case). Verify no duplicate in `{vault}/projects/`.

3. **Detect Repository Location** — Check cwd for `.git`. If none, ask user. **NEVER guess paths.**

4. **Create Project Structure**
```bash
mkdir -p {vault}/projects/{id}/{epics,specs}
```

5. **Create Files**
   - `_index.md` — Dashboard (Current State, Active Stances, Key Decisions, Tasks table if local tracker, Epics table)
   - `PRD.md` — Problem, Solution, Target User, Requirements (P0/P1), Non-Goals, Success Metrics
   - `rules.md` — Enforced constraints (Product/UI/Engineering sections)
   - Initial epic files if appropriate

6. **Set Up Tracker** (based on manifest's tracker mode)

   **local**: Tasks table is already in `_index.md`. Ready.

   **linear**:
   - Create a Linear Team for the project (or confirm which existing team to use)
   - Create Initiatives if the project has strategic layers
   - Enable 1-week Cycles (guide user to Linear UI if MCP can't)
   - Create Labels: platform tags relevant to the project

   **github**:
   - Verify `gh` CLI is authenticated
   - Create labels: `priority:P0`, `priority:P1`, `priority:P2`, `status:todo`, `status:in-progress`, `status:blocked`
   - Create milestones if the project has phases

   **external**: Nothing to set up.

7. **Update Manifest** — Add project to Projects table, set Active Context.

8. **Announce**
```
PROJECT CREATED: {Name}

{Brief}

Documents:
- PRD.md (requirements)
- rules.md (constraints)
- specs/ (ready for feature specs)

Tracker: {tracker mode}
{For linear: Team: {name}, Cycles: enabled}
{For github: Labels created, gh CLI verified}
{For local: Tasks table in _index.md}

Next: Start building, or write a feature spec with /claudepm plan {feature-name}
```

---

## Mode 2: New Feature (Spec)

This is the primary mode. It creates an exhaustive spec using the interrogation protocol.

### Steps

1. **Determine Tier**

   Infer from context, then explain to the user:

   - Multiple repos OR touches auth/payments → **Tier 1**
     "This crosses repo boundaries (or touches auth/payments), so it's a Tier 1 spec — the most thorough. We'll cover data design, access policies, state contracts, and failure modes."

   - Single repo + DB changes → **Tier 2**
     "This involves database changes in a single repo, so it's a Tier 2 spec. We'll cover data design and user journeys, but skip policy matrices and formal contracts."

   - No DB changes, contained UI → **Tier 3**
     "This is contained UI work with no database changes — a Tier 3 spec. We'll focus on user journeys and build order. Quick and focused."

   If unsure, ask: "Does this feature touch the database? Does it cross repos or involve auth/payments?"

2. **Codebase Audit** (BEFORE interrogation)

   Read the existing codebase to ground the spec in reality.

   **What to audit** (use Read, Glob, Grep):

   a. **Project structure** — Read the project's `_index.md`, `rules.md`, and any existing specs.

   b. **DB schema** — Find and read migration files, schema definitions, or type files.

   c. **Existing components/screens** — Glob for files related to the feature area.

   d. **Patterns & conventions** — Read 2-3 representative files to understand data fetching, error states, navigation, forms.

   e. **Shared infrastructure** — Identify reusable utilities, hooks, components, types.

   **Output**: Write a `## Technical Context` section at the top of the spec:
   ```markdown
   ## Technical Context

   Repository: {path}
   Stack: {framework, DB, key libs}

   ### Existing Relevant Code
   - {file/pattern}: {what it does, why it matters}

   ### Patterns to Follow
   - {pattern}: {how similar features handle X}

   ### Reusable Infrastructure
   - {component/hook/util}: {what it provides}

   ### Constraints from Existing Code
   - {constraint}: {why}
   ```

3. **Create Spec Stub**

   Create `{vault}/projects/{project}/specs/{id}-{slug}.md` with frontmatter, Technical Context (from audit), and empty sections based on tier. Set `status: drafting`.

4. **Enter Plan Mode**

   Call `EnterPlanMode` before starting the interrogation.

5. **Interrogation Protocol**

   **IMPORTANT: Use the `AskUserQuestion` tool for ALL questions.** Batch related questions into a single AskUserQuestion call (3-6 questions per batch).

   Walk the user through each required section. For each section, ask probing questions until there are no unanswered questions.

   **Order matters. Each section informs the next:**

   a. **Why + Success** — "Why does this matter now? How will we know it worked?"

   b. **Scope** — "What's included? What's explicitly NOT included?" Force both lists.

   c. **User Journeys** — This is where you spend the most time.
      - Walk through each screen/flow/endpoint step by step
      - At each step: "What does the user see? What can they do? What happens if it fails?"
      - For non-UI work: "What are all the scenarios? Edge cases? Failure modes?"
      - Keep asking until the user says "that's everything"
      - Write each answer into the spec immediately

   d. **Data Design** (Tier 1 + 2) — "What tables? What columns? What constraints?"

   e. **Policy Design** (Tier 1) — "Who can do what? Build the role x action matrix."

   f. **Contracts** (Tier 1) — "Map every state to every UI surface. Map every mutation to its side effects."

   g. **Failure Modes** (Tier 1) — "What can break? What's the impact? What's the mitigation?"

   h. **Build Order** — Sequence the implementation. "What depends on what?"

   i. **Release Checklist** — "What must be true before we ship?"

6. **Exit Plan Mode**

   Call `ExitPlanMode` after the spec is finalized.

7. **Mark Spec Ready**

   Update frontmatter: `status: specced`
   Update project `_index.md` Specs table

8. **Create Tasks from Build Order** (tracker-specific)

   **local**:
   - Add tasks to the Tasks table in `_index.md`
   - Each task from the Build Order gets a row with `todo` status and priority

   **linear**:
   - Create Project named after the spec
   - Create Milestones from Build Order phases
   - Create Issues from Build Order tasks
   - Break large issues into sub-issues
   - Apply sub-issue hygiene: Todo status, cycle assigned, parent estimate 0
   - Pull first milestone's issues into current Cycle
   - Link back: update spec frontmatter with `linear_project` URL

   **github**:
   - Create issues from Build Order tasks: `gh issue create`
   - Apply priority labels
   - Create milestones for Build Order phases
   - Assign issues to milestones

   **external**:
   - Output the task list: "Here are the tasks from the build order. Add them to your tracker."

9. **Announce**
```
SPEC CREATED: {id} — {name}

Tier: {tier}
Status: specced
Sections: {n} complete

Tracker:
{For local: {n} tasks added to _index.md}
{For linear: Project: {URL}, {n} issues, {m} in current cycle}
{For github: {n} issues created, {m} milestones}
{For external: {n} tasks listed — add to your tracker}

Spec: {vault}/projects/{project}/specs/{id}-{slug}.md

Next: /claudepm review to validate, then start building.
```

### Interrogation Tips

- **Propose defaults, let the user override.** Don't ask blank open-ended questions. For each question, propose a recommended approach with brief rationale. Offer 2-3 labeled options where relevant.
- **Don't accept vague answers.** "Handle appropriately" is not an answer. "Show error toast with message, re-enable form, no data lost" is an answer.
- **Challenge assumptions.** "You said 'one review per vendor.' What if the user deletes their account and creates a new one?"
- **Name every state.** Unnamed states become bugs.
- **Think about empty states.** Zero data? One item? 1000 items?
- **Think about timing.** Loading state? Optimistic update? Skeleton?
- **Think about failure.** Network down. Server error. Invalid data. Concurrent modification.
- **Think about boundaries.** Max length? Max count? Max file size? What happens at the limit?

## What Gets Created/Updated

| File | Action |
|------|--------|
| `projects/{id}/_index.md` | Created (new project) or Updated (new spec row, new tasks) |
| `projects/{id}/PRD.md` | Created (new project only) |
| `projects/{id}/rules.md` | Created (new project only) |
| `projects/{id}/specs/{id}-{slug}.md` | Created (new feature) |
| `projects/{id}/epics/*.md` | Created (new project, if applicable) |
| `manifest.md` | Add to Projects table or update Active Context |
| **Tracker** | Tasks/issues/items created per tracker mode |

## Rules

- Extract from conversation, don't invent
- Be exhaustive in interrogation — this is the entire point
- Every spec decision must reference the Technical Context
- After spec is written, always offer `/claudepm review` to validate
- **Never call Linear MCP tools unless tracker is `linear`**
- **Never assume `gh` CLI exists unless tracker is `github`**

## Argument

$ARGUMENTS
