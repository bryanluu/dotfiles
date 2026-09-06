---
description: Draft a commit message for the current changes in this repo
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*)
---

## Context

- Status: !`git status --short`
- Unstaged diff: !`git diff`
- Staged diff: !`git diff --cached`
- Recent commit style (for reference): !`git log --oneline -5`

## Your task

If there are no changes above, say so and stop.

Otherwise, draft ONE commit message for these changes, following this exact convention:

- First line: a gitmoji as its raw GitHub code (e.g. `:recycle:`), followed by a short imperative summary. The gitmoji text counts toward a 50-character limit for the whole line — stay at or under it.
- Blank line.
- A body explaining what changed and why. Prioritize readability over strict prose — code identifiers, filenames, or short snippets can use backticks where that's clearer than describing them in words.
- Blank line.
- A final trailer line in the form `Generated with Claude Code (<your model name>)`, where you fill in your own model name.

Output ONLY the raw commit message — no commentary, no code fences, no "Here's a draft" preamble.
