#!/bin/bash
# ClaudePM SessionStart Hook
# Loads workspace context at the beginning of each session

# Resolve vault path
VAULT="${CLAUDEPM_VAULT:-$HOME/.claudepm}"
MANIFEST="$VAULT/manifest.md"

# Check if manifest exists
if [ ! -f "$MANIFEST" ]; then
    echo "=== CLAUDEPM: NO VAULT FOUND ==="
    echo ""
    echo "Run /claudepm to set up your first project."
    echo ""
    echo "==================================="
    exit 0
fi

echo "=== CLAUDEPM: WORKSPACE STATE ==="
echo ""

# Extract active context
PROJECT=$(grep "^project:" "$MANIFEST" | head -1 | cut -d: -f2 | tr -d ' ')
EPIC=$(grep "^epic:" "$MANIFEST" | head -1 | cut -d: -f2 | tr -d ' ')
TASK=$(grep "^task:" "$MANIFEST" | head -1 | cut -d: -f2- | xargs 2>/dev/null)
TRACKER=$(grep "^tracker:" "$MANIFEST" | head -1 | cut -d: -f2 | tr -d ' ')
TRACKER="${TRACKER:-local}"

# Auto-detect project from working directory
CWD=$(pwd)
DETECTED_PROJECT=""

if [ -d "$VAULT/projects" ]; then
    for PROJECT_DIR in "$VAULT/projects"/*/; do
        [ -d "$PROJECT_DIR" ] || continue
        INDEX_FILE="${PROJECT_DIR}_index.md"
        [ -f "$INDEX_FILE" ] || continue

        REPO=$(grep "^repository:" "$INDEX_FILE" | head -1 | cut -d: -f2- | xargs 2>/dev/null)
        # Expand ~ in repo path
        REPO="${REPO/#\~/$HOME}"

        if [ -n "$REPO" ] && [ "$CWD" = "$REPO" ] || [[ "$CWD" == "$REPO"/* ]]; then
            DETECTED_PROJECT=$(basename "$PROJECT_DIR")
            break
        fi
    done
fi

# If detected project differs from active, note it
if [ -n "$DETECTED_PROJECT" ] && [ "$DETECTED_PROJECT" != "$PROJECT" ] && [ -n "$PROJECT" ]; then
    echo "DETECTED: Working directory matches project '$DETECTED_PROJECT' (active: '$PROJECT')"
    echo "  Consider: /claudepm $DETECTED_PROJECT"
    echo ""
    # Use detected project for display
    PROJECT="$DETECTED_PROJECT"
elif [ -n "$DETECTED_PROJECT" ] && [ -z "$PROJECT" ]; then
    PROJECT="$DETECTED_PROJECT"
fi

if [ -n "$PROJECT" ] && [ "$PROJECT" != "null" ]; then
    echo "ACTIVE PROJECT: $PROJECT"

    INDEX_FILE="$VAULT/projects/$PROJECT/_index.md"
    if [ -f "$INDEX_FILE" ]; then
        NAME=$(grep "^name:" "$INDEX_FILE" | head -1 | cut -d: -f2 | xargs 2>/dev/null)
        BRIEF=$(grep "^brief:" "$INDEX_FILE" | head -1 | cut -d: -f2- | xargs 2>/dev/null)
        echo "  Name: $NAME"
        [ -n "$BRIEF" ] && echo "  Brief: $BRIEF"
    fi

    if [ -n "$EPIC" ] && [ "$EPIC" != "null" ]; then
        echo "ACTIVE EPIC: $EPIC"
    fi

    if [ -n "$TASK" ] && [ "$TASK" != "null" ]; then
        echo "ACTIVE TASK: $TASK"
    fi

    echo "TRACKER: $TRACKER"

    # Stale session check
    LAST_ACTIVE=$(grep "| $PROJECT " "$MANIFEST" | head -1 | awk -F'|' '{print $6}' | tr -d ' ')
    if [ -n "$LAST_ACTIVE" ]; then
        TODAY=$(date +%s)
        LAST_EPOCH=$(date -j -f "%Y-%m-%d" "$LAST_ACTIVE" +%s 2>/dev/null || date -d "$LAST_ACTIVE" +%s 2>/dev/null)
        if [ -n "$LAST_EPOCH" ]; then
            DAYS_AGO=$(( (TODAY - LAST_EPOCH) / 86400 ))
            if [ "$DAYS_AGO" -gt 14 ]; then
                echo ""
                echo "STALE: Last session was $DAYS_AGO days ago. Context may be outdated."
            fi
        fi
    fi

    echo ""
    echo "Use /claudepm for full status."
else
    echo "NO ACTIVE PROJECT"
    echo ""

    PROJECT_COUNT=$(find "$VAULT/projects" -maxdepth 1 -type d 2>/dev/null | wc -l)
    PROJECT_COUNT=$((PROJECT_COUNT - 1))

    if [ "$PROJECT_COUNT" -gt 0 ]; then
        echo "Available projects: $PROJECT_COUNT"
        echo "Use /claudepm to see them."
    else
        echo "No projects yet. Use /claudepm to create one."
    fi
fi

# Check for untracked directory
if [ -z "$DETECTED_PROJECT" ] && [ -z "$PROJECT" ]; then
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    if [ -n "$REPO_ROOT" ]; then
        echo ""
        echo "This directory is a git repo not tracked by ClaudePM."
        echo "Use /claudepm to add it as a project."
    fi
fi

# Check for incoming handoff
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || echo "$PWD")
if [ -f "$REPO_ROOT/.handoff/handoff.md" ]; then
    echo ""
    echo "=== INCOMING HANDOFF ==="
    echo "Another tool left a handoff. Read .handoff/handoff.md before starting work."
    echo "========================"
fi

echo ""
echo "==================================="

exit 0
