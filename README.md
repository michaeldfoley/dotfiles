# dotfiles

Universal config that works on any machine. Machine-specific overlays stay local, never committed here.

## Structure

```
.agents/AGENTS.md            # Shared agent instructions (cross-tool source of truth)
.agents/skills/              # Agent skills (symlinked to ~/.agents/, ~/.claude/, ~/.cursor/)
.claude/CLAUDE.md            # Claude Code config (@imports AGENTS.md + Claude-specific)
templates/DESIGN.md          # Design doc template (used by /design command)
install.sh                   # Sets up symlinks + installs fzf
AGENTS.md                    # Repo-level agent instructions (this repo)
```

## Setup

```bash
git clone git@github.com:michaeldfoley/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## How it works

- `~/.agents/AGENTS.md` — shared agent instructions, symlinked to this repo
- `~/.agents/skills/` — agent skills, symlinked to this repo (both Claude Code and Cursor discover here)
- `~/.claude/CLAUDE.md` — Claude Code config, symlinked to this repo (@imports shared AGENTS.md)
- **Cursor global prefs** — paste AGENTS.md content into Cursor Settings > Rules > User Rules (no file-based auto-load for global prefs; per-project prefs use `AGENTS.md` at project root, auto-discovered natively)

## Preference distribution

```
Personal global prefs (synced via dotfiles):
  ~/.agents/AGENTS.md        ← source of truth
  ├── Claude Code            @import via CLAUDE.md (native)
  ├── Cursor                 paste into User Rules (Settings UI, manual)
  └── Other tools            AGENTS.md at project root (native auto-discover)

Project-specific patterns (committed to each repo):
  <repo>/AGENTS.md           ← team-shared, per-project
  └── All tools auto-discover natively
```

## Agent memory

Self-learning feedback loop across Claude Code and Cursor sessions.

```
session → friction/insights
    → /retro captures to INBOX.md (short-term, local)
    → /triage promotes to AGENTS.md (long-term, synced)
    → both tools read AGENTS.md at startup
    → better instructions → repeat
```

| Layer       | File                           | Scope                   | Who writes        |
| ----------- | ------------------------------ | ----------------------- | ----------------- |
| Long-term   | `.agents/AGENTS.md`            | Cross-tool, synced      | /triage only      |
| Short-term  | `~/.agents/INBOX.md`           | Local, never synced     | /retro, log, idea |
| Per-project | `<repo>/AGENTS.md`             | Team-shared, committed  | Manual or /triage |
| Per-project | `~/.claude/projects/*/memory/` | Claude Code auto-memory | Claude Code       |

Capture triggers (both tools): `log`, `idea: <thought>`, `win: <description>`.
Triage (`/triage`) promotes INBOX items to AGENTS.md rules, zshrc aliases, scripts, or discards them.
