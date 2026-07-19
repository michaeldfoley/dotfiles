## Style

- Extremely concise. Sacrifice grammar for concision.
- No em dashes (—). Use en dashes (–), semicolons, or restructure.
- Avoid being overly enthusiastic/complimentary in responses.
- Commit messages – single-line subject, no body. Let the diff speak.
- Plans, all interactions – concise. End plans with unresolved questions, if any.

## Code

- Clean, minimal code. Readability > cleverness.
- No over-engineering: no unnecessary abstractions, error handling, or features beyond what's asked. During planning, challenge each addition: does the caller already have this info?
- Small-lift additions within the active task's domain (completions, aliases, etc.) – just include them. Don't leave obvious follow-ups for the user to ask about.
- No adding comments/docstrings to untouched code.
- `eslint-disable` / `eslint-disable-next-line` / `eslint-disable-line` – always include a comment explaining why. Bare disables are tech debt.
- A syntactically-valid but semantically-wrong line (no-op statement, placeholder reference, comment-as-fix) = signal to pause and rethink the abstraction. Don't paper over – the clean answer is usually a small addition to the surrounding API.
- If a README exists and changes affect it, update it automatically. Re-verify any enumerated lists (Structure blocks, file inventories, command tables) – they drift faster than they look.
- Permission allowlists (settings.json): scope to verb patterns (`Bash(git *)`, `Bash(gh *)`) rather than bare `Bash`. High-frequency safe ops short-circuit; destructive ops (`rm`, `curl`, arbitrary scripts) still prompt. Under `dontAsk` mode, also allow read-only inventory ops (`find`, `ls`, `grep`, `rg`) so audits/surveys don't bounce silently.
- Recovery/retry logic that issues multiple sequential RPCs against the same external object must handle the "object disappeared between RPCs" race on every call, not only the first. When reviewing, explicitly probe: "what if the object is deleted between call N and call N+1?"
- When adding a tool that enables a workflow, document the workflow (when/why), not just the command.
- After renames/refactors, grep for old name to catch stale references. Before broad find-replace, verify all match sites – short tokens hit unintended locations.
- When adding a field to a shared type, grep for all synthesis/construction functions that build instances of that type and verify the new field is explicitly copied. Silent omission is the common failure mode.
- Before adding a backward-compat re-export, grep for callers first. Zero callers → skip the shim; the cleanup is free.
- If a formatter rewrites lines you didn't touch and there's no CI enforcement for that style, prefer the minimal diff. Don't bundle a wholesale reformat with a semantic change.
- Before proposing new tools/aliases, grep existing config to avoid duplicating what's already there.
- Verify platform capabilities before designing around them – don't assume features exist at system boundaries.
- Flag performance when it matters – hot paths, large datasets, repeated calls. Don't optimize prematurely.
- TypeScript: when a callback only needs a subset of a type's fields, type the parameter as `Pick<T, 'field1' | 'field2'>`. Avoids requiring callers to construct fields they don't have.
- React: `useEffectEvent` is for callbacks called from effects only. For callbacks used inside `useCallback` deps or passed to children, use a stable-ref wrapper (e.g. `useStableCallback` or equivalent) instead.
- React: before adding a ref to stabilize a recursive closure, check if the callback's deps are already stable. Stable deps → stable callback → no ref needed.
- Go: default to unexported (lowercase). Only export when cross-package usage is confirmed.
- Shell scripts: MUST consult `conventions/shell-scripts.md` before writing. Key: BSD vs GNU portability; `set -euo pipefail`; zshrc never hits the network at startup.
- CLI tools: MUST consult `conventions/cli-guidelines.md` before writing. Key: stderr for messages, stdout for data; flags over positional args; errors say what + how to fix.

## Agent

- Prefer speed/autonomy when working from agreed plan
- Log actions for visibility
- CLI tools (`gt`, `bzl`, etc.): always pass `--no-interactive` or equivalent. Never let a CLI block on stdin.
- Hang detection: run potentially-slow commands in background. Poll output – if no new output for 15s (with verbose/debug flags) or 30s (without), assume hung. Kill, retry with timeout, or fall back.
- Exit loops if no progress toward verifiable goal. Never loop 3+ times on same failure – stop, note pattern, ask.
- Ask before guessing paths/values – don't assume from directory listings.
- Flag over/under-prompting: if user is over-specifying something obvious, say so. If under-specifying is causing rework, flag that too.
- When working across repos, confirm target repo early.
- When user references "a change I made" and `git status` doesn't show it, ask immediately: committed/staged/unstaged/stashed? Don't chase via git log/blame.
- After disruptions (tool rejection, context restore, mode switch), verify actual state (git status, git diff, ls) before retrying.
- When referencing a PR as template, extract the specific fix – not the entire diff. PRs often bundle unrelated changes.
- Scripts/tools go directly in final home (e.g., `~/.local/bin/`). INBOX.md is for ideas/friction – not finished artifacts.
- When surveying external patterns (other dotfiles, repos, tools), evaluate by future value, not current need. Default-to-include; push back later if unused.
- When goal = match sibling service/config X exactly, default to removing constraints not preserving. Justify each constraint kept against the sibling's behavior, not against fear of change.

## Modes

- `teach me [topic]` / `learn [topic]` → invoke `/learn` skill (Socratic, persistent notes in `~/.notes/<slug>.md`).
- `walk me through [code/topic]` → invoke `/walkthrough` skill (opinionated code tour with file:line anchors).
- `eli5 [topic]` → Simplest first, I'll ask deeper. (Not a skill – inline mode.)
- Plan mode is for code exploration + writing a plan. For iterative design discussion, stay in implement mode – enter plan mode once design is settled.
- Plan mode exit: run `/retro` (abbreviated) before exiting to capture decisions and friction.

## Workflow

Branch naming: `<type>/<slug>` (e.g. `feat/add-grep-tool`). All changes to main require a PR.
Checkpoint is the only release path – route through /checkpoint skill. After completing a task or set of changes, offer to checkpoint automatically. Never offer bare commit+push.

### Splitting changes
Prefer splitting logically independent changes (refactor, bug fix, feature) into stacked PRs.

**Proactive (preferred):** When I recognize a separable change while working, branch + commit it immediately before continuing.

**Retroactive (at checkpoint):** If changes are already mixed, attempt to untangle. If too intertwined, ship as one PR and flag it.

**Don't proactively split small mixed changes.** Check stacking signals first: Graphite-tracked branch, existing remote PR, or user-called-out multiple concerns. Without those, default to one PR.

Stacked PRs use Graphite (`gt`) – commands and stack ordering in `conventions/git-recipes.md`.

### Retro
Auto-trigger – don't wait to be asked:
- `/retro` is context-aware: full at checkpoint/session end, abbreviated before context loss.
- Run automatically at checkpoint, session end, and before any context-loss event.

Context-loss triggers (always run `/retro` before these):
- Exiting plan mode / clearing context
- Switching repos/tasks
- Long break (user says "pause", "stop", "done for now")

## Stack

Primary: Go, TypeScript. Bazel build. Kubernetes, OpenAPI, gRPC.
Use as reference frame – draw analogies to these when explaining new tech or making design decisions.

## Testing

- TDD for core logic – write tests first, use as guardrails for autonomous work
- Table-driven tests (Go). Bazel: scope to affected targets
- No heavy mocks. If it needs mocks, rethink the boundary
- Integration tests: opt-in. Suggest at checkpoint when touching service boundaries
- Tests derive from spec/requirements, not from planned implementation
- Failing test: fix code, not test. Only fix test if requirement was wrong
- "be thorough" = add integration tests, edge cases, error paths
- After adding input validation, grep test call sites – verify existing test inputs still pass.
- When adding a new CI lint/test, run it locally against existing repo content before committing. Surfaces pre-existing issues before they block the introducing PR.
- For high-stakes or architecture-heavy PRs, run `/dual-agents-review` before shipping. Codex and Claude surface different bug classes – neither alone catches everything.

## Safety

In all modes:
- Never `rm -rf` outside of build/temp dirs. Always scoped, never `~/` or `/`.
- Never `git push --force` to main/master.
- Never `git reset --hard` or `checkout .` with uncommitted work; stash first.
- Never delete branches without confirming they're merged.
- Flag sensitive values (API keys, tokens) in files before committing/pushing – even if user is driving.
- Before creating repos in an org, verify permissions and constraints (branch protection, deletion, visibility).

## Git

- Conventional commits: feat:, fix:, chore:, refactor:, docs:, test:.
- Always run relevant tests before committing.
- GitHub CLI for all GitHub interactions.
- Always rebase, never merge – clean linear history. Branch from `origin/main`, not local main.
- Squash-merge PRs – one commit per PR on main.
- New repos → always `.gitignore` with `.DS_Store` immediately.
- In implement mode: never commit without user confirmation – show diff, summarize, wait for go-ahead.
- Before committing, verify current branch matches intent – check for open PRs and whether changes belong there.
- Push operations (`gpush`, `gpushup`) only through /checkpoint. Hygiene aliases (`gm`, `gsync`, `gclean`) are safe anytime.

Stacking, history rewrite, hygiene alias details, `gh` quirks: see `conventions/git-recipes.md`.

- **Graphite `gt submit --stack` blocked by merged parent:** Aborts with "merged commits not contained in latest trunk" when a parent branch has merged but local trunk hasn't fast-forwarded. Fix: `git fetch origin <trunk>` then `gt move --base <trunk>` on the child, or run `gt sync` first.

## Pull Requests

- Title: conventional commit format, under 70 chars
- Title: describe the capability/behavior change, not the file diff
- Body: lead with why and what it enables. Explain the design/system – not line-by-line diff tables
- Body structure:
  ```
  ## Motivation
  <why this change, link to issue if applicable>

  ## Summary
  - <what changed and why>

  ## Test plan
  - [ ] <how to verify>
  ```
- Reference issue numbers when applicable
- After pushing follow-up commits, update the PR body to reflect new changes (see `conventions/git-recipes.md` for safe `gh pr edit` flow).
- Descriptions = current intent, not changelog. No "what changed from v1" sections. Commit history handles evolution.
- Per-repo CLAUDE.md can override this template

## Memory

Model: session → INBOX.md (short-term) → triage → AGENTS.md (long-term)

- AGENTS.md = long-term memory. Cross-tool, synced via dotfiles. Only triage writes here.
- INBOX.md (`~/.agents/INBOX.md`) = short-term capture. Local, never synced.
- retro = capture process → INBOX.md. triage = promotion → AGENTS.md or discard.
- Triage when INBOX.md exceeds ~10 items. Proactively check and suggest `/triage` when it's growing – don't wait to be asked.
- Triage promotion rules (inline vs convention, gate pattern): see `conventions/agents-md-guidelines.md`.
- Skills (shared workflows) live in `~/.agents/skills/` – both Claude Code and Cursor read from here. Designing/refining skills: see `conventions/skill-guidelines.md`.
- Work artifacts (problem/design/plan/output/review/reference) live in `~/.agents/artifacts/<slug>/` – standalone local git repo. Schemas: `conventions/artifact-templates.md`. Created/maintained via /propose, /execute, /document.

Capture triggers:
- `log` / `idea: <thought>` → append to INBOX.md (date, context, idea)
- `win: <description>` → `~/.agents/wins.md` (promo-packet worthy)

When capturing friction:
- Self-resolve once. If reusable insight, suggest INBOX.md entry.
- At capture time, note if INBOX.md is growing and nudge toward triage.

@~/.agents/local-AGENTS.md
