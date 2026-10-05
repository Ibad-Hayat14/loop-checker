#!/usr/bin/env bash
# fan-out.sh — runs N candidates in parallel, each isolated, each graded independently

TIMESTAMP=$(date +%s)

# candidate list: "description|branch-suffix"
CANDIDATES=(
  "fix average() to divide by len(nums), not just sum|avg"
  "fix is_palindrome() to actually compare s to its reverse|palindrome"
)

PIDS=()
WTDIRS=()

for CAND in "${CANDIDATES[@]}"; do
  DESC="${CAND%%|*}"
  SUFFIX="${CAND##*|}"
  BRANCH="claude/fix-${SUFFIX}-${TIMESTAMP}"
  WTDIR="../wt-${SUFFIX}-${TIMESTAMP}"

  ./run-candidate.sh "$DESC" "$WTDIR" "$BRANCH" &
  PIDS+=($!)
  WTDIRS+=("$WTDIR")
done

echo "=== Fired ${#PIDS[@]} candidates in parallel, waiting... ==="

FAIL_COUNT=0
for i in "${!PIDS[@]}"; do
  if wait "${PIDS[$i]}"; then
    echo "candidate $i (${WTDIRS[$i]}): PASS"
  else
    echo "candidate $i (${WTDIRS[$i]}): FAIL"
    FAIL_COUNT=$((FAIL_COUNT + 1))
  fi
done

echo "=== Done: ${#PIDS[@]} total, $FAIL_COUNT failed ==="

# cleanup worktrees
for WTDIR in "${WTDIRS[@]}"; do
  git worktree remove "$WTDIR" --force 2>/dev/null
done
