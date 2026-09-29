# Git Recipes

Advanced git operations. Load on demand during complex git work.

## Graphite (gt) for stacked PRs

Use Graphite, not raw git, for stacks:

- `gt create <branch> --parent <base>` – the currently installed Graphite CLI rejects `--parent` on `gt create`. From the intended parent branch, run `gt create <branch> --no-interactive` (it becomes the parent implicitly); otherwise use `git switch -c <branch>` followed by `gt track --parent <base>`. `gt track` auto-detection alone picks long ancestor chains through stale branches, so always set `--parent` on the `gt track` call.
- `gt submit` (`gtsub`) – creates/updates PRs for the entire stack. Not `git push` + `gh pr create`.
- `gt restack` (`gtr`) – rebases stack after changes. Not `git rebase`.
- `gt sync` – pulls latest main into Graphite tracking. Not `git fetch`.
- `gt log short --stack` (`gts`) – view current stack.
- `gt create <branch>` – always include the `/` separator explicitly in the branch name (e.g. `gt create michael.foley/SDA-1234/foo`), even when `branchPrefix` is configured. Graphite concatenates the configured prefix with the given name without inserting a separator — `gt create SDA-1234/foo` under prefix `michael.foley` produces the malformed `michael.foleySDA-1234/foo`. If it happens anyway, fix with `git branch -m <correct-name>` + `gt track --parent <parent>`.
- `gt submit --draft`/`--stack` on an already-submitted PR does not reliably preserve or restore draft status — a PR that was ready-for-review can come back ready-for-review even when `--draft` is passed on a later resubmit. After any submit where draft status matters, verify with `gh pr view <number> --json isDraft` and fix with `gh pr ready <number> --undo` if needed.
- Before relying on `gt submit`, verify the repo is actually synced with Graphite (some repos, e.g. dd-go, are tracked/initialized locally but never synced, so `gt submit --draft` fails). If unsynced and the change isn't a stack, fall back to `git push` + `gh pr create`; still verify draft state afterward (`gh pr view <number> --json isDraft`).
- Before trusting `gt restack`/stack-verification output, fast-forward the local trunk pointer to its remote-tracking ref first (`git fetch origin <trunk>` then move local trunk). A stale local trunk makes Graphite report a false "needs restack" and makes `git diff <trunk>...HEAD` misleadingly include thousands of unrelated upstream files. After restacking, verify the branch is exactly one commit ahead and zero behind trunk.
- Never `gt restack` from a secondary worktree without checking descendants first. It rebases the whole stack, including branches checked out in *other* worktrees (e.g. the primary one) — even if the worktree you're running from is clean. Before restacking, run `git worktree list` and `git status` in every checked-out descendant; if any is dirty, stop for cleanup/permission rather than trusting worktree isolation.

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
- `gh pr view --comments` and the issue-comment API miss inline review findings; checking only `reviewThreads` misses submitted review bodies. Use one GraphQL query pulling `reviews`, `comments`, and `reviewThreads` together for full PR-comment triage (bot and human) – it also exposes thread resolved/outdated state.
- `gh pr diff` accepts at most one positional pathspec argument; passing several (e.g. `gh pr diff --patch -- '*.ts' '*.tsx' ...`) fails. Fetch the full patch and filter client-side, or use the local base diff for changed-file selection.

## Signing

- Signed commits from a managed Codex shell can hang indefinitely without a PTY; retrying with terminal allocation completes immediately. Always allocate a PTY for `git commit -S` in managed Codex sessions.
- In a managed Codex shell, `SSH_AUTH_SOCK` can point at the macOS launchd listener even when Git signing and GitHub SSH keys live in the 1Password agent. If a signed commit hangs, check the configured `IdentityAgent` and, if needed, invoke with `SSH_AUTH_SOCK="/Users/michael.foley/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"` before assuming the agent itself failed.

## Misc

- After `git mv`, `git add` both old and new paths to ensure rename detection.
- Don't stash across branches when files differ. Make changes directly on target branch, or cherry-pick.
