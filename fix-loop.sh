#!/usr/bin/env bash
set -e
BRANCH="claude/fix-$(date +%s)"
WTDIR="../wt-fix-$(date +%s)"  
 
echo "=== Creating isolated worktree on $BRANCH ==="
git worktree add -b "$BRANCH" "../wt-$BRANCH"

echo "=== Implementer drafts the fix ==="
( cd "../wt-$BRANCH" && opencode run --model opencode/nemotron-3.5-lightning-free "Follow the bug-fixer skill in .opencode/skills/bug-fixer/SKILL.md exactly." )

echo "=== Reviewer grades it ==="
VERDICT=$( cd "../wt-$BRANCH" && opencode run "Act as the reviewer agent (.opencode/agents/reviewer.md). Grade the current diff against main." )

echo "$VERDICT"

if echo "$VERDICT" | grep -q "^PASS"; then
  echo "=== PASS: pushing and opening PR ==="
  ( cd "../wt-$BRANCH" && git add -A && git commit -m "fix: bug-fixer pass" && git push -u origin "$BRANCH" )
  gh pr create --head "$BRANCH" --title "fix: auto-generated fix" --body "$VERDICT"
else
  echo "=== FAIL: no PR opened ==="
fi

git worktree remove "../wt-$BRANCH" --force

