---
description: Validate spec completeness and catch gaps before building
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, AskUserQuestion
---

# ClaudePM Review

Validate the active spec's completeness before building begins. This is the quality gate between planning and implementation.

## When to Use

- After writing a spec (`/claudepm plan`)
- Before starting to build a feature
- When you suspect the spec has gaps
- At any point during build to verify alignment

## Steps

### 1. Load the Active Spec

Determine vault path: `$CLAUDEPM_VAULT` or `~/.claudepm/`

Read `{vault}/manifest.md` → get active project
Read `{vault}/projects/{project}/_index.md` → get active spec
Read the spec file

If no active spec exists:
```
No active spec to review.
Use /claudepm plan {feature-name} to create one.
```

If vault doesn't exist:
```
No ClaudePM vault found. Run /claudepm to set up.
```

### 2. Determine Required Sections

Read the spec's `tier` from frontmatter:

| Tier | Required |
|------|----------|
| 1 | Why, Success, Scope, User Journeys, Data Design, Policy Design, Contracts, Failure Modes, Build Order, Release |
| 2 | Why, Success, Scope, User Journeys, Data Design, Build Order, Release |
| 3 | Why, Success, Scope, User Journeys, Build Order, Release |

### 3. Run Checks

#### A. Structure Check

For each required section:
- Does the section header exist? (`## Section Name`)
- Is the section non-empty? (more than just a placeholder comment)
- Does it contain actionable content? (not "TBD", "figure out later", "handle appropriately")

#### B. Journey Completeness Check

For each screen/flow/endpoint mentioned in User Journeys:
- Are entry points covered? (how does the user get here?)
- Are all states described? (empty, loading, populated, error)
- Are all actions described? (what can the user do?)
- Are outcomes described for each action? (success + failure)
- Are exit points covered? (where do they go after?)

For non-UI journeys (DB, API, edge function):
- Are all scenarios walked through?
- Are edge cases addressed?
- Are failure scenarios covered?

#### C. Technical Context Check

- Does the spec have a `## Technical Context` section?
- Does it reference the actual repository and stack?
- Do User Journeys reference existing components/patterns listed in Technical Context?
- Does Data Design extend (not contradict) existing tables listed in Technical Context?
- Does Build Order account for constraints from existing code?
- Are reusable components/hooks/utils from Technical Context used instead of reinvented?

#### D. Cross-Reference Check

- Every screen/component in User Journeys has a corresponding entry in Build Order
- Every table in Data Design has RLS policies in Policy Design (Tier 1)
- Every write operation has a side-effect description (Tier 1 Contracts)
- Build Order is sequenced with no hidden dependencies
- Technical Context constraints are respected throughout the spec

#### D. Contracts Check (Tier 1 only)

- State-to-UI table exists
- Every state combination has an answer (no blank cells)
- "Impossible" states are justified
- Mutation-to-side-effect chain covers all write operations

#### E. Content Quality Check

Scan for red flags:
- Vague language: "handle appropriately", "as needed", "etc.", "and more"
- Placeholder text: "TBD", "figure out later"
- Unresolved questions: "?", "not sure", "maybe"
- Missing specifics: "some kind of", "probably", "might"

### 4. Output Results

```
SPEC REVIEW: {spec id} — {spec name}

Tier: {tier}
Status: {current status}

STRUCTURE: {n}/{m} required sections present
{For each missing or empty section:}
  Missing: {section name}

JOURNEYS: {assessment}
{For each gap found:}
  Gap: {screen/flow} — {what's missing}

TECHNICAL CONTEXT: {assessment}
{For each issue:}
  Issue: {description}

CROSS-REFERENCES: {assessment}
{For each inconsistency:}
  Mismatch: {description}

CONTRACTS: {assessment or "N/A (Tier 2/3)"}
{For each blank cell or missing table:}
  Gap: {description}

QUALITY: {assessment}
{For each red flag:}
  Flag: {line/section} — {issue}

---

RESULT: {READY | {n} gaps found}

{If READY:}
Spec is complete for Tier {tier}. Ready to build.
Create Linear project and issues, then start building.

{If gaps found:}
{n} gaps must be resolved before building.
{List the most critical gaps first}
Want to resolve these now?
```

### 5. Offer Next Steps

If gaps found:
- "Want to resolve these gaps now? I'll walk you through each one."

If ready:
- "Spec is ready. Want me to create the Linear project and issues?"

## What This Does NOT Check

- **Content correctness** — Checks structure and completeness, not whether the technical approach is sound
- **Feasibility** — Doesn't verify implementation is possible or practical
- **Effort estimation** — Doesn't estimate how long things will take

## Rules

1. Never approve a spec with blank cells in contract tables
2. Never approve a spec with placeholder language in required sections
3. Be specific about gaps — "User Journeys missing error state for WriteReviewScreen" not "journeys incomplete"
4. Cross-reference checks catch real bugs — a screen with no build order entry will be forgotten
5. This is a soft gate — flag issues, let the user decide whether to fix now or proceed
