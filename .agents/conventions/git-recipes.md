# Git Recipes

Advanced git operations. Load on demand during complex git work.

## Graphite (gt) for stacked PRs

Use Graphite, not raw git, for stacks:

- `gt create <branch> --parent <base>` – always specify `--parent` explicitly. `gt track` auto-detection picks long ancestor chains through stale branches.
- `gt submit` (`gtsub`) – creates/updates PRs for the entire stack. Not `git push` + `gh pr create`.
- `gt restack` (`gtr`) – rebases stack after changes. Not `git rebase`.
- `gt sync` – pulls latest main into Graphite tracking. Not `git fetch`.
- `gt log short --stack` (`gts`) – view current stack.
- `gt create <branch>` – always include the `/` separator explicitly in the branch name (e.g. `gt create michael.foley/SDA-1234/foo`), even when `branchPrefix` is configured. Graphite concatenates the configured prefix with the given name without inserting a separator — `gt create SDA-1234/foo` under prefix `michael.foley` produces the malformed `michael.foleySDA-1234/foo`. If it happens anyway, fix with `git branch -m <correct-name>` + `gt track --parent <parent>`.
- `gt submit --draft`/`--stack` on an already-submitted PR does not reliably preserve or restore draft status — a PR that was ready-for-review can come back ready-for-review even when `--draft` is passed on a later resubmit. After any submit where draft status matters, verify with `gh pr view <number> --json isDraft` and fix with `gh pr ready <number> --undo` if needed.

Branch from `origin/main`. Stack order: foundational changes first; dependent features stack on top. Each PR targets the branch below it (or main for the first).

## Hygiene aliases (personal shell config, not synced via this repo)

- `gm` – switch to main, pull, full cleanup of merged branches
- `gsync` – rebase current branch onto main (use `gtr` for Graphite stacks)
- `gclean` – cleanup merged branches only

Self-healing fetch auto-recovers stale refs. Safe to run anytime.
Push operations (`gpush`, `gpushup`) only through /checkpoint.

## History rewriting

- Feature branches: prefer rewriting history (reset + force push) over revert commits. Reverts only on main/shared.
- Never `git reset --soft main` or `git reset --soft origin/main` – local main drifts after rebases; `origin/main` drifts mid-session (other PRs land between fetches). Use `git reset --soft HEAD~N` (relative to your own commits) for squashing.
- Don't auto-squash branch commits at /checkpoint – distinct logical commits (move, fix, feature) tell a story. Ask first.
- `--force-with-lease` stales after rebase; on personal branches `--force` is fine.

## gh quirks

- `gh` commands must run from the target repo's cwd; `--repo` flag alone isn't enough (`git -C` works for git but not gh).
- Before `gh pr edit --body`: always `gh pr view --json body` first, merge with existing content. GitHub has no edit history; overwriting destroys user content permanently.

## Misc

- After `git mv`, `git add` both old and new paths to ensure rename detection.
- Don't stash across branches when files differ. Make changes directly on target branch, or cherry-pick.
