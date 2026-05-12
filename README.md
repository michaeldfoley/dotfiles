# dotfiles

Universal config that works on any machine. Machine-specific overlays stay local, never committed here.

## Structure

```
.agents/AGENTS.md            # Shared agent instructions (always-loaded, behavioral)
.agents/conventions/         # On-demand reference docs (loaded via AGENTS.md gate lines)
.agents/skills/              # Agent skills (symlinked to ~/.agents/, ~/.claude/, ~/.cursor/)
.claude/CLAUDE.md            # Claude Code config (@imports AGENTS.md + Claude-specific)
templates/DESIGN.md          # Design doc template (used by /design command)
install.sh                   # Sets up symlinks + installs fzf
AGENTS.md                    # Repo-level agent instructions (this repo)
```

`AGENTS.md` is capped at ~200 lines – behavioral rules only. Detail (commands, lookup tables, language-specific how-to) lives in `.agents/conventions/*.md` and is loaded on demand via gate lines like `MUST consult conventions/X.md before <trigger>`. See `conventions/agents-md-guidelines.md`.

## Work artifacts

Per-topic working files (problem / design / plan / output / review / reference) live in `~/.agents/artifacts/<slug>/` – a standalone local git repo, not synced via dotfiles. Schemas in `.agents/conventions/artifact-templates.md`. Skills `/propose`, `/execute`, `/document` create and maintain them; `/checkpoint` updates `output.md` on ship.

First-time setup: `mkdir -p ~/.agents/artifacts && cd ~/.agents/artifacts && git init`.

Machine-local overlays (never committed):

```
~/.agents/local-AGENTS.md    # Local agent overrides (@imported at end of AGENTS.md)
~/.claude/local-CLAUDE.md    # Local Claude Code overrides (@imported at end of CLAUDE.md)
```

## Setup

```bash
git clone git@github.com:michaeldfoley/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

## Testing

```bash
bash tests/test-shellcheck.sh    # static analysis on bash scripts (auto-discovered)
bash tests/test-entrypoints.sh   # syntax check on every shebang'd script
bash tests/test-skills.sh        # SKILL.md frontmatter contracts
bash tests/test-repo-contracts.sh # JSON + workflow validation
bash tests/test-regressions.sh   # stable contracts (retired skills stay gone)
```

CI runs all five on every PR (`.github/workflows/ci.yml`). Install deps locally: `brew install shellcheck actionlint`.

## How it works

- `~/.agents/AGENTS.md` — shared agent instructions, symlinked to this repo
- `~/.agents/skills/` — agent skills, symlinked to this repo (both Claude Code and Cursor discover here)
- `~/.claude/CLAUDE.md` — Claude Code config, symlinked to this repo (@imports shared AGENTS.md)
- `~/.agents/local-AGENTS.md`, `~/.claude/local-CLAUDE.md` — machine-local overlays, never synced. Imported at end of their globals so local rules override
- **Cursor global prefs** — paste AGENTS.md content into Cursor Settings > Rules > User Rules (no file-based auto-load for global prefs; per-project prefs use `AGENTS.md` at project root, auto-discovered natively)

### Load order / precedence

Imports are concatenated inline; later content wins on conflict. Effective order when Claude Code starts:

```
1. .agents/AGENTS.md     (global, synced)
2. local-AGENTS.md       (machine-local overlay)     ← overrides #1
3. .claude/CLAUDE.md     (global, synced)
4. local-CLAUDE.md       (machine-local overlay)     ← overrides #1–3
```

Use `local-*` for company-specific rules (branch naming, commit prefixes, internal tools) or per-machine tweaks that shouldn't ship in dotfiles.

## Preference distribution

```
Personal global prefs (synced via dotfiles):
  ~/.agents/AGENTS.md        ← source of truth
  ├── Claude Code            @import via CLAUDE.md (native)
  ├── Cursor                 paste into User Rules (Settings UI, manual)
  └── Other tools            AGENTS.md at project root (native auto-discover)

Machine-local overlays (never synced, override globals):
  ~/.agents/local-AGENTS.md  ← @imported at end of AGENTS.md
  ~/.claude/local-CLAUDE.md  ← @imported at end of CLAUDE.md

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
