@../.agents/AGENTS.md

## Modes

- **Plan** → Claude Code's built-in plan mode. Read-only, deliberate.
- **Implement** (default after plan approval) → Execute agreed plan. Handle errors autonomously (retry once, then flag). Pause at checkpoint: show diff, summarize, confirm before commit/push/PR.
- **Yolo** → Invoke with `/yolo <plan ref>`. Fully autonomous:
  - Commit + push to feature branches freely. Create draft PRs.
  - Spin up new branches/PRs as needed. Build stacked PRs – each PR targets the branch below it.
  - Never merge. Never destructive ops. If blocked after 2 attempts, flag and move on.
  - Stop when plan tasks complete or scope exhausted. Leave summary: done, pending, PR links.

## Commands

- `checkpoint` → build + test → update README if affected → split or ship → clean history → show diff + confirm → push + open PRs → win check → retro
- `checkpoint amend` → amend last commit + force push + update PR body + retro
- `retro` → review session for patterns, friction, insights → INBOX.md
- `log` / `idea: <thought>` → append to INBOX.md (date, context, idea)
- `save` → conversation → `~/.claude/sessions/MM-DD-YY-<slug>.md`
- `win: <description>` → `~/.claude/wins.md`
- `triage` → fully autonomous INBOX.md review (see AGENTS.md Memory section)
- `pick` → work on backlog item from INBOX.md

## Setup

- `~/.claude/CLAUDE.md` → symlinked from `~/dotfiles/.claude/CLAUDE.md` – only edit the dotfiles copy
- `~/.claude/local-CLAUDE.md` – local Claude Code overrides, never synced. Imported by CLAUDE.md
- `~/.claude/INBOX.md` – local capture scratchpad, never synced
- `~/.claude/sessions/` – saved conversation logs, never synced
- Plan files: `~/.claude/plans/YYYY-MM-DD-<slug>.md`. Slug should be relevant to the plan changes. Track changes in git. Delete plans when PR is merged.

@~/.claude/local-CLAUDE.md
