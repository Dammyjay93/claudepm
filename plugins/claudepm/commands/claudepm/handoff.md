---
description: Hand off context to another AI coding tool
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

# ClaudePM Handoff

You are handing off to another AI coding tool (Codex, Cursor, etc.). Write a single file that gives the next tool everything it needs to continue. Then scaffold tool configs so every tool auto-checks for handoffs AND works to the same quality bar.

**Read the conversation context to determine the situation.** Don't ask the user — infer it:

- If you were stuck on a problem → the handoff is about what failed and what to try next
- If you planned or built something → the handoff is about what was done and what's next
- If you diagnosed a bug → the handoff is about the root cause and the fix needed

**Output goes to the repo, not the Vault.** The receiving tool reads files in the repo, not ~/Vault.

## Steps

### 1. Determine Repo Root

Run `git rev-parse --show-toplevel` to find the repo root.

If not in a git repo, use the current working directory.

### 2. Read Project Context

- Determine vault path: `$CLAUDEPM_VAULT` or `~/.claudepm/`
- `{vault}/manifest.md` for active project/epic/task and tracker mode
- `{vault}/projects/{id}/_index.md` for project state
- If tracker is `local`: read Tasks table from `_index.md` for remaining tasks
- If tracker is `linear`: query Linear MCP for open issues
- If tracker is `github`: run `gh issue list` for open issues
- The project's `CLAUDE.md` or root-level config for coding standards

### 3. Write the Handoff File

Create the directory if needed: `mkdir -p {repo-root}/.handoff`

**File**: `{repo-root}/.handoff/handoff.md`

The file MUST be self-contained. The receiving tool has no prior context. The HTML comment at the top tells any AI tool how to use this file AND how to write code — no external configuration needed.

Adapt the sections to the situation. Include what's relevant, skip what's not. Every handoff needs: Status, Context, and Files. The rest depends on the situation.

````markdown
<!--
FOR AI TOOLS: This file was left by another coding tool.

BEFORE YOU START:
- Read everything below before writing any code
- If approaches are listed under "Attempted" — do NOT repeat them

HOW TO WORK:
- Be exhaustive. Implement fully — no stubs, no placeholders, no "TODO" comments
- Write elegant, production-quality code. Every line as if a senior engineer reviews it
- Use strict TypeScript. No `any`, no `@ts-ignore`, no `as any` casts
- No `console.log` statements. Use proper error handling
- Follow existing project patterns. Read the codebase before writing
- Don't hallucinate imports. Verify packages exist before using them
- Don't over-engineer. Solve what's asked, nothing more

WHEN DONE:
- Delete this file
-->

# Handoff

from: claude-code
project: {project name}
epic: {epic}
task: {task}
date: {YYYY-MM-DD}

## Status

{One of: stuck | planned | built | diagnosed}

## Context

{What's going on. One paragraph. Be specific — not "there's a bug" but "the location watcher in gps.ts fires after component unmount, causing a setState-on-unmounted crash."}

## Attempted

{Only if stuck. Every approach tried, numbered, with WHY each failed.}

1. {Approach} — {Specific failure mode}
2. {Approach} — {Specific failure mode}

## What Was Done

{Only if planned/built/diagnosed. Specific deliverables — file paths, function names, type definitions.}

## What Needs Doing

{Specific next steps. Not "implement the backend" but "implement fetchNearbyNeighborhoods in src/services/neighborhood.ts using the Neighborhood type from src/types/neighborhood.ts, sorted by distance, max 50 results."}

1. {Specific task}
2. {Specific task}

## Constraints

{Things the next tool must NOT do, patterns to follow, performance requirements. Only include if there are real constraints.}

- {Constraint and why it exists}

## Files

- `{path}:{line}` — {role in this handoff}
- `{path}:{line}` — {role in this handoff}

## Root Cause Guess

{Only if stuck. Your honest assessment — what you think is wrong, where you'd look with a fresh perspective.}
````

### 4. Stash if Dirty

If the working tree has uncommitted changes (especially failed attempts):

```bash
git stash push -m "handoff: {brief description}"
```

If the tree is clean, skip this.

### 5. Scaffold Tool Configs

Create per-tool instruction files that set BOTH the handoff protocol AND the project's coding standards. Only create files that don't already exist. If they exist, check if they already mention `.handoff/` — if so, skip.

Read the project's CLAUDE.md (if it exists) to pull project-specific standards. Fall back to the user's global standards from `~/.claude/CLAUDE.md`.

**AGENTS.md** (Codex, and increasingly other tools):

````markdown
# Project Standards

## Handoff Protocol

Before starting work, check if `.handoff/handoff.md` exists. If it does, read it first. It contains context from another tool — what was done, what failed, what needs doing. Follow the instructions in the file. Delete it when done.

## Code Quality

- Be exhaustive. Implement fully — no stubs, no placeholders, no "TODO" comments
- Write production-quality code. Elegant, readable, maintainable
- Use strict TypeScript. No `any`, no `@ts-ignore`, no `as any` casts
- No `console.log` statements
- No hardcoded secrets or credentials
- Follow existing project patterns — read the codebase before writing
- Don't hallucinate imports. Verify packages exist before using them
- Don't over-engineer. Solve what's asked, nothing more
- Don't add unnecessary comments, docstrings, or type annotations to code you didn't change

## {Add project-specific conventions here}

{Read the project's CLAUDE.md and extract relevant conventions: naming patterns, file structure, framework-specific rules, testing approach, etc. Only include what applies to all tools, not CC-specific instructions.}
````

**.cursor/rules/handoff.mdc** (Cursor):

````markdown
---
description: Cross-tool handoff protocol and code quality standards
globs:
alwaysApply: true
---

## Handoff Protocol

Before starting work, check if `.handoff/handoff.md` exists. If it does, read it first. It contains context from another tool. Follow the instructions in the file. Delete it when done.

## Code Quality

- Be exhaustive. Implement fully — no stubs, no placeholders, no "TODO" comments
- Write production-quality code. Elegant, readable, maintainable
- Use strict TypeScript. No `any`, no `@ts-ignore`, no `as any` casts
- No `console.log` statements
- Follow existing project patterns — read the codebase before writing
- Don't hallucinate imports. Verify packages exist
- Don't over-engineer. Solve what's asked, nothing more

## {Add project-specific conventions here}

{Same as AGENTS.md — extract from project's CLAUDE.md.}
````

If other tool config files exist in the repo (`.windsurfrules`, `.clinerules`, `.github/copilot-instructions.md`), append the same protocol and standards to them.

### 6. Ensure .handoff is Gitignored

Check if `.handoff/` is in `.gitignore`. If not, add it.

### 7. Generate Handover Prompt

Generate a ready-to-paste prompt the user can give to the receiving tool. This is separate from the handoff file — the file has full detail, the prompt is what the user types into Codex/Cursor/etc. to kick things off.

**Rules for the prompt:**

1. **Open with project identity** — Name, one-line description of what it is, stack, and repo path. The receiving tool knows NOTHING. Example: "Project: Wander — a TikTok-style vertical swipe feed of Wikipedia articles. Zero backend, local-first, React Native + Expo SDK 54, TypeScript. Repo at ~/wander."
2. **Point to the handoff file and AGENTS.md immediately** — "Read .handoff/handoff.md and AGENTS.md first."
3. **Lead with the observable symptom** — what the user actually sees (crash, frozen UI, wrong output), not internal details
4. **State your diagnosis as assessment, not fact** — "My assessment: X causes Y" not "X causes Y". You might be wrong. Be honest.
5. **Tell the tool to do its own investigation** — "Don't trust this blindly — run the app, trace the error, find every instance yourself"
6. **Define what done looks like** — specific verification steps (run tsc, run tests, confirm behavior on device)
7. **Include stash pop if stashed** — the tool needs the code

Adapt tone to the situation:
- **stuck**: Emphasize "here's what I tried, here's what I think, verify independently"
- **diagnosed**: Emphasize "here's the symptom, here's my theory, but investigate yourself"
- **built**: Emphasize "here's what was built, here's what's left, verify it works"
- **planned**: Emphasize "here's the plan, here are the decisions, execute it"

**Output the prompt in a fenced code block** so the user can copy it directly.

### 8. Announce

```
HANDOFF WRITTEN

Status: {stuck | planned | built | diagnosed}
Summary: {one-line}
File: {repo-root}/.handoff/handoff.md
Working tree: {clean | stashed as "handoff: ..."}
Tool configs: {created AGENTS.md, .cursor/rules/handoff.mdc | already existed | updated}

PROMPT FOR RECEIVING TOOL:
(copy the block above)
```

## Important

- Be specific. Vague handoffs waste the next tool's time.
- Include EVERY approach you tried if stuck, not just the last one.
- Reference actual file paths. The receiving tool can read them.
- Constraints prevent the next tool from undoing your decisions.
- The self-contained HTML comment is critical — it sets both context and quality expectations even if the tool doesn't read AGENTS.md.
- The scaffolded tool configs carry your engineering standards to every tool. Without them, only CC has quality enforcement.
- Do NOT continue working after writing the handoff. Stop.
