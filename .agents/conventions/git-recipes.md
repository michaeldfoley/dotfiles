# Git Recipes

Advanced git operations. Load on demand during complex git work.

## Graphite (gt) for stacked PRs

Use Graphite, not raw git, for stacks:

- `gt create <branch> --parent <base>` – always specify `--parent` explicitly. `gt track` auto-detection picks long ancestor chains through stale branches.
- `gt submit` (`gtsub`) – creates/updates PRs for the entire stack. Not `git push` + `gh pr create`.
- `gt restack` (`gtr`) – rebases stack after changes. Not `git rebase`.
- `gt sync` – pulls latest main into Graphite tracking. Not `git fetch`.
- `gt log short --stack` (`gts`) – view current stack.

Branch from `origin/main`. Stack order: foundational changes first; dependent features stack on top. Each PR targets the branch below it (or main for the first).

## Hygiene aliases (`shell/zshrc`)

- `gm` – switch to main, pull, full cleanup of merged branches
- `gsync` – rebase current branch onto main (use `gtr` for Graphite stacks)
- `gclean` – cleanup merged branches only

Self-healing fetch auto-recovers stale refs. Safe to run anytime.
Push operations (`gpush`, `gpushup`) only through /checkpoint.

## History rewriting

- Feature branches: prefer rewriting history (reset + force push) over revert commits. Reverts only on main/shared.
- Never `git reset --soft main` – local main drifts. Use `HEAD~N` (relative) for squashing branch commits.
- Don't auto-squash branch commits at /checkpoint – distinct logical commits (move, fix, feature) tell a story. Ask first.
- `--force-with-lease` stales after rebase; on personal branches `--force` is fine.

## gh quirks

- `gh` commands must run from the target repo's cwd; `--repo` flag alone isn't enough (`git -C` works for git but not gh).
- Before `gh pr edit --body`: always `gh pr view --json body` first, merge with existing content. GitHub has no edit history; overwriting destroys user content permanently.

## Misc

- After `git mv`, `git add` both old and new paths to ensure rename detection.
- Don't stash across branches when files differ. Make changes directly on target branch, or cherry-pick.
