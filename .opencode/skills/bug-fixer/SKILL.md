---
name: bug-fixer
description: Fix one specific failing test, make the smallest possible change, never touch the test file.
---

1. Run `python -m pytest tests/ -v` and read the failing test's name and assertion.
2. Open the source file responsible, and make the smallest change that satisfies the assertion.
3. Do NOT edit any file in tests/.
4. Do NOT change any other function's behavior.
5. Run the tests again and confirm all pass before stopping.
6. Print a one-line summary of exactly what you changed.
