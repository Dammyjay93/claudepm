#!/bin/bash
# ClaudePM Stop Hook
# Detects unsaved work and writes emergency session stub if needed

VAULT="${CLAUDEPM_VAULT:-$HOME/.claudepm}"
MANIFEST="$VAULT/manifest.md"

# Only run if manifest exists
if [ ! -f "$MANIFEST" ]; then
    exit 0
fi

PROJECT=$(grep "^project:" "$MANIFEST" | head -1 | cut -d: -f2 | tr -d ' ')

if [ -z "$PROJECT" ] || [ "$PROJECT" = "null" ]; then
    exit 0
fi

TODAY=$(date +%Y-%m-%d)

# Check if session was saved today (any file matching today's date for this project)
SAVED=false
for f in "$VAULT/sessions/${TODAY}"*"-${PROJECT}.md" "$VAULT/sessions/${TODAY}.md"; do
    if [ -f "$f" ]; then
        SAVED=true
        break
    fi
done

if [ "$SAVED" = false ]; then
    # Check if there's actual work to save (git changes in cwd)
    REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null)
    HAS_CHANGES=false

    if [ -n "$REPO_ROOT" ]; then
        DIFF_COUNT=$(git -C "$REPO_ROOT" diff --stat HEAD 2>/dev/null | tail -1 | grep -o '[0-9]* file' | head -1 | cut -d' ' -f1)
        UNTRACKED=$(git -C "$REPO_ROOT" ls-files --others --exclude-standard 2>/dev/null | head -5 | wc -l | tr -d ' ')

        if [ "${DIFF_COUNT:-0}" -gt 0 ] || [ "${UNTRACKED:-0}" -gt 0 ]; then
            HAS_CHANGES=true
        fi
    fi

    if [ "$HAS_CHANGES" = true ]; then
        # Write emergency session stub
        EMERGENCY_FILE="$VAULT/sessions/${TODAY}-${PROJECT}-emergency.md"
        mkdir -p "$VAULT/sessions"

        cat > "$EMERGENCY_FILE" << EOF
---
type: session
date: $TODAY
project: $PROJECT
emergency: true
---

# Emergency Session Stub: $PROJECT

Session ended without explicit save. This stub was auto-generated.

## Git Changes Detected

Repository: $REPO_ROOT
$(git -C "$REPO_ROOT" diff --stat HEAD 2>/dev/null | head -20)

## Untracked Files

$(git -C "$REPO_ROOT" ls-files --others --exclude-standard 2>/dev/null | head -10)

## Note

Run \`/claudepm save\` in the next session to create a proper session file.
This emergency stub can then be deleted.
EOF

        echo ""
        echo "[ClaudePM] Session ended without save. Emergency stub written to:"
        echo "  $EMERGENCY_FILE"
        echo "  Run /claudepm save next session to save properly."
    else
        echo ""
        echo "[ClaudePM] Active project: $PROJECT. No unsaved git changes detected."
    fi
fi

exit 0
