---
name: checkpoint
description: Build, test, split/ship PRs, commit, push, win check, retro. The only release path.

---

Self-contained workflow – execute steps fully, don't inject extra confirmation gates beyond what's built in.

1. **Pre-flight (tidy)** – read-only branch health check. Abort on P0, warn on P1, info on P2:
   - **P0 Branch guard** – not on main/master.
   - **P0 Staged file audit** – `git diff --cached --stat`. Flag files outside this branch's concern. If `~/.agents/artifacts/<slug>/` has `plan.md`/`output.md`, compare staged files against stated scope.
   - **P0 Unstaged leak detection** – `git diff --stat`. Changes that look like they belong on a different branch. Suggest which.
   - **P0 Stack position** – if `gt log short --stack` works, verify parent branch's changes are present (parent not stale).
   - **P1 Behind main** – `git rev-list --count HEAD..origin/main`. If >0, estimate conflict risk (`git merge-tree`). Offer rebase before continuing.
   - **P1 Scope check** – diff file list against `plan.md`/`output.md` if present.
   - **P1 CI status** – `gh pr checks` if a PR exists.
   - **P2 Diff summary** – `git diff --stat` grouped by area; highlight biggest files.
2. Build + test (scope to affected targets)
3. Update README if changes affect it
4. Split into stacked PRs if possible (see Workflow > Splitting changes in AGENTS.md), or ship as one
5. Clean up commit history (squash/reword as needed)
6. Show diff, summarize what changed and why, confirm before committing
7. Push branches, open PRs (use PR template from `~/.agents/AGENTS.md` > Pull Requests)
8. If `~/.agents/artifacts/<slug>/` exists for this work: update `output.md` (PR link, branch, `status`) and `plan.md` frontmatter (`status: shipped` if all phases done)
9. Win check – evaluate session against promo-packet bar (see below). If it qualifies, draft entry and confirm before logging to `~/.agents/wins.md`
10. Retro – run /retro

**`checkpoint amend`** = amend last commit + force push + update PR body + retro. Compound – execute all steps.

**Win bar** (step 7): promo-packet worthy – impact beyond the code change. Categories: cross-team unblock, initiative enablement, DX improvement, arch decision, measurable perf win, reliability/incident response. When Jira/initiative context is shared, use it to frame impact. Auto-detect suggests entry, user confirms.
