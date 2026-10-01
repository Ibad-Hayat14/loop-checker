# fix-loop-checker

A small maker-checker loop built while working through **Project 4** ("A fix loop with a real checker") from the [Loop Engineering crash course](https://agentfactory.panaversity.org/docs/loop-engineering-crash-course), part of [The Agent Factory](https://agentfactory.panaversity.org).

It proves one idea: an agent that **drafts** a fix should never be the same agent that **grades** it. Here I use different model of the same family (Nemotron) for complexity of task(easy - I was just experimenting) but best practice is to use models of different families for better result in complex projects  
## What's here

- `src/calc.py` — a tiny calculator with one real bug: `divide()` crashes on `b=0` instead of returning `None`.
- `tests/test_calc.py` — tests, including the one that exposes the bug. Never edited by the implementer.
- `.opencode/skills/bug-fixer/SKILL.md` — the **implementer's** instructions: fix the one failing test, smallest change possible, never touch `tests/`.
- `.opencode/agents/reviewer.md` — the **reviewer**, a separate read-only subagent that re-runs the tests itself, reads the diff, and replies `PASS` or `FAIL` with reasons. It never edits files.
- `fix-loop.sh` — the runner. Creates an isolated git worktree, runs the implementer, runs the reviewer, and opens a PR **only on PASS**.

## How it works

\`\`\`
run fix-loop.sh
  → create an isolated worktree on a new claude/fix-* branch
  → implementer (maker) reads the skill, fixes the bug, re-runs tests
  → reviewer (checker) independently re-runs tests, reads the diff, verdicts PASS or FAIL
  → PASS  → push the branch, open a PR for a human to merge
  → FAIL  → no PR opens; the bad attempt stays on its branch
\`\`\`

Nothing merges automatically. The loop drafts; a human reviews and merges. That's the point.

## Proof the checker isn't soft

The bar this project sets: a good fix gets \`PASS\`, and a **deliberately bad fix** (e.g. one hard-coded to pass the exact test input instead of fixing the real logic) gets \`FAIL\`, with reasons. A reviewer that passes everything isn't a reviewer.

## Run it yourself

\`\`\`bash
./fix-loop.sh
\`\`\`

Requires [OpenCode](https://opencode.ai) and the [GitHub CLI](https://cli.github.com) (\`gh auth login\` first).
