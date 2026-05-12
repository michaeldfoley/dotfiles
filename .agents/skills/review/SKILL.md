---
name: review
description: Review a PR or diff for correctness, style, and domain-specific issues. Loads relevant conventions. Persists findings to ~/.agents/artifacts/<slug>/review.md. Use when user says 'review', 'review this PR', or pastes a diff/PR URL.
---

# /review

Structured code review. Domain-aware via `~/.agents/conventions/`. Persists to the topic's artifact dir.

## Bootstrap

1. Read `~/.agents/AGENTS.md` for behavioral rules.
2. Load relevant conventions from `~/.agents/conventions/` based on diff content (e.g., `cli-guidelines.md` for CLI code, `shell-scripts.md` for shell, `git-recipes.md` for git tooling).
3. Determine target: PR URL, branch diff, or staged changes.
4. Resolve slug: derive from branch name (`feat/foo` → `foo`), explicit `--topic <slug>`, or repo name. Create `~/.agents/artifacts/<slug>/` if missing.

## Input

- PR URL: `gh pr diff <url>` or `gh pr view <url> --json files,body`
- Branch: `git diff origin/main...HEAD`
- Staged: `git diff --staged`

## Review structure

For each file changed:
1. **Correctness** – bugs, edge cases, error handling gaps
2. **Style** – matches repo conventions (AGENTS.md rules, existing patterns)
3. **Domain** – applies loaded convention guidelines
4. **Completeness** – missing tests, README updates, migration steps

## Output

Present findings in chat (blockers first, nits last), then persist to `~/.agents/artifacts/<slug>/review.md`:

```markdown
---
topic: <slug>
repo: <repo-name>
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Review: <title>

## Action items
- [ ] P0 <blocking> – `path/to/file.go:42` – <explanation>. Suggestion: <fix>.
- [ ] P1 <should-fix> – `path/to/file.go:88` – ...
- [ ] P2 <nit/optional> – ...

## Future features
- <new PR or later follow-up>

## Future learnings
- <process/workflow lesson – candidate for /triage>

## Resolution log
- YYYY-MM-DD HH:MM – <what changed or what was waived>
```

Severities: P0 (blocker), P1 (should fix), P2 (nit / optional). Process/workflow lessons go in `## Future learnings`, not action items.

On write failure: warn, continue – review is still delivered in chat.

## Principles

- Concrete suggestions, not vague feedback.
- Don't flag style covered by linters/formatters.
- Acknowledge good patterns – not everything needs a comment.
- For large diffs: focus on the riskiest changes.
- If the topic has `problem.md`/`design.md`: verify the diff satisfies the stated requirements.

## Next

On completion, print: `Review at ~/.agents/artifacts/<slug>/review.md. P0s? Fix and re-checkpoint.`
