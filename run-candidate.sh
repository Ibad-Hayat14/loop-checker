#!/usr/bin/env bash
# run-candidate.sh <bug-description> <worktree-dir> <branch-name>
set -e
DESC="$1"
WTDIR="$2"
BRANCH="$3"

git worktree add -b "$BRANCH" "$WTDIR" >/dev/null 2>&1

echo "[$BRANCH] implementer starting: $DESC"
( cd "$WTDIR" && opencode run "Follow the bug-fixer skill in .opencode/skills/bug-fixer/SKILL.md exactly. Focus only on: $DESC" ) > "$WTDIR/implementer.log" 2>&1

echo "[$BRANCH] reviewer grading..."
VERDICT=$( cd "$WTDIR" && opencode run "Act as the reviewer agent (.opencode/agents/reviewer.md). Grade the current diff against main." )
echo "$VERDICT" > "$WTDIR/verdict.log"

if echo "$VERDICT" | grep -q "^PASS"; then
  echo "[$BRANCH] PASS -> pushing and opening PR"
  ( cd "$WTDIR" && git add -A && git commit -m "fix: $DESC" && git push -u origin "$BRANCH" )
  ( cd "$WTDIR" && gh pr create --head "$BRANCH" --title "fix: $DESC" --body "$VERDICT" )
  exit 0
else
  echo "[$BRANCH] FAIL -> no PR"
  exit 1
fi
