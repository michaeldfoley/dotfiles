# dotfiles

Shared agent instructions, skills, and tool configs that load across Claude Code, Cursor, Codex, and Gemini. Built around a small always-loaded surface (`AGENTS.md` + `CLAUDE.md`), topic-scoped on-demand conventions, and a `/propose` → `/execute` → `/checkpoint` workflow that produces structured artifacts.

## Quick start

```bash
git clone git@github.com:michaeldfoley/dotfiles.git ~/dotfiles
bash ~/dotfiles/install.sh
```

`install.sh` is idempotent. Symlinks shared rules into `~/.agents`, `~/.claude`, `~/.cursor`, `~/.gemini`; sets `git pull.rebase true`; installs `fzf` if missing.

First-time work-artifacts setup (standalone local git repo, not synced):

```bash
mkdir -p ~/.agents/artifacts && git -C ~/.agents/artifacts init
```

## What's in here

**Agent surface** – shared across all tools, symlinked into place by `install.sh`:

- `.agents/AGENTS.md` – behavioral rules, always loaded. Capped ~200 lines (see `conventions/agents-md-guidelines.md`).
- `.agents/conventions/` – topic-scoped reference docs, loaded on demand via gate lines in AGENTS.md.
- `.agents/skills/` – multi-step workflows. Symlinked to `~/.agents/skills/`, `~/.claude/skills/`, `~/.cursor/skills/`.

**Tool configs:**

- `.claude/CLAUDE.md` + `.claude/settings.json` + `.claude/agents/` – Claude Code config, scoped Bash allowlist, sub-agents.
- `.gemini/GEMINI.md` – Gemini CLI: imports `~/.agents/AGENTS.md`.
- `.codex/config.toml.example` + `review-instructions.md` – Codex CLI starter (manual merge) + independent-reviewer profile that produces our `review.md` shape.
- `.cursor/rules/` – Cursor per-project rules (global prefs pasted manually into Settings).

**Repo infra:**

- `install.sh` – idempotent setup.
- `tests/` + `.github/workflows/ci.yml` – static checks (skills frontmatter, JSON/TOML/workflow validation, shellcheck, retired-skill contracts).

## Skills

Invoke via slash command. Definitions in `.agents/skills/<name>/SKILL.md`.

| Skill | What it does |
|---|---|
| `/checkpoint` | The release path. Tidy pre-flight → build/test → split or ship → push + PRs → update `output.md` → win check → `/retro`. |
| `/propose` | Create or continue `problem.md → design.md → plan.md` at `~/.agents/artifacts/<slug>/`. Scales from quick tasks to full RFCs. |
| `/execute` | Work a phased plan – tick tasks, append PR/file refs, maintain `output.md`. Interactive or autonomous mode. |
| `/review` | Review PR/diff against loaded conventions. Persists P0/P1/P2 + resolution log to `review.md`. |
| `/walkthrough` | Opinionated senior-pairing code tour with `file:line` anchors, gotchas, suggested improvements. |
| `/learn` | Socratic teaching engine. Persistent learning notes at `~/.notes/<slug>.md` across sessions. |
| `/grill-me` | Enumerate options (including non-obvious + "do nothing"), probe with hard questions, commit to one recommendation. |
| `/poc` | Compound: light `/propose` → single-phase `/execute` (hacks allowed) → `/checkpoint` with explicit `Gaps` section. |
| `/document` | Produce `reference.md` for a codebase or system, with `file:line` citations. |
| `/triage` | Sort `INBOX.md` items: execute trivial ones inline, promote stable patterns to AGENTS.md or conventions, discard the rest. |
| `/retro` | Capture friction and learnings from a session to `INBOX.md`. Context-aware – abbreviated before context loss, full at checkpoint/session end. |
| `/yolo` | Autonomous execution mode. Work through a plan, create draft PRs, never merge. |

## Conventions

Loaded on demand via gate lines like `MUST consult conventions/X.md before <trigger>`. See `conventions/agents-md-guidelines.md` for the inline-vs-convention test.

| Convention | When to consult |
|---|---|
| `agents-md-guidelines.md` | Maintaining AGENTS.md, deciding what's inline vs convention, promoting items during `/triage`. |
| `artifact-templates.md` | Creating any artifact in `~/.agents/artifacts/<slug>/` (problem / design / plan / output / review / reference). |
| `cli-guidelines.md` | Writing or improving a CLI tool – clig.dev distilled (flags, output streams, errors, subcommands). |
| `git-recipes.md` | Stacked PRs via Graphite, history rewriting, hygiene aliases, `gh` quirks. |
| `shell-scripts.md` | Writing or modifying bash scripts – strict mode, BSD vs GNU portability, quoting, traps. |
| `skill-guidelines.md` | Designing or refining a skill: blast radius, composability, when to extract vs inline. |

## Sub-agents

`.claude/agents/` – Claude Code sub-agent definitions, invoked via the `Task` tool.

- **`researcher`** – Haiku, background. Scans codebase, writes findings to `~/.agents/artifacts/<slug>/research.md`. Feeds `/propose` or `/document`.
- **`executor`** – Sonnet, worktree-isolated. Runs `/execute` autonomously. Constrained: never modifies outside the worktree, never merges PRs, never pushes to main.

## Work artifacts

Per-topic working files live in `~/.agents/artifacts/<slug>/` – a standalone local git repo, not synced via dotfiles.

```
problem.md   → why (impact, requirements)
design.md    → how (approach, tradeoffs)
plan.md      → what / when (phased tasks, outputs list)
output.md    → delivery unit (links to plan/branch/PR/review)
review.md    → review loop (P0/P1/P2 + resolution log)
reference.md → non-actionable learnings (no pipeline)
```

Schemas in `.agents/conventions/artifact-templates.md`. Created and maintained by `/propose`, `/execute`, `/review`, `/document`. `/checkpoint` updates `output.md` on ship.

## Local overlays

Machine-local files, never synced:

| File | Purpose |
|---|---|
| `~/.agents/local-AGENTS.md` | Local agent rule overrides (`@imported` at end of AGENTS.md) |
| `~/.claude/local-CLAUDE.md` | Local Claude Code overrides (`@imported` at end of CLAUDE.md) |
| `~/.claude/settings.local.json` | Local Claude Code permission overrides |
| `~/.agents/INBOX.md` | Short-term capture before `/triage` promotes |
| `~/.agents/wins.md` | Promo-packet log written by `/checkpoint` step 9 |

## Agent memory

```
session → friction / insights
    → /retro captures to INBOX.md (short-term, local)
    → /triage promotes to AGENTS.md or conventions/ (long-term, synced)
    → all tools read AGENTS.md at startup
    → better instructions → repeat
```

Capture triggers: `log`, `idea: <thought>`, `win: <description>`.

| Layer | File | Scope | Who writes |
|---|---|---|---|
| Long-term, synced | `.agents/AGENTS.md` + `conventions/` | Cross-tool | `/triage` |
| Short-term, local | `~/.agents/INBOX.md` | Capture only | `/retro`, `log`, `idea` |
| Per-project, committed | `<repo>/AGENTS.md` | Team-shared | Manual or `/triage` |
| Per-project, automatic | `~/.claude/projects/*/memory/` | Claude Code only | Claude Code |

## Testing

```bash
bash tests/test-shellcheck.sh     # ShellCheck on every bash script (auto-discovered)
bash tests/test-entrypoints.sh    # bash -n / zsh -n / py_compile on every shebang'd script
bash tests/test-skills.sh         # SKILL.md frontmatter contracts
bash tests/test-repo-contracts.sh # JSON, TOML, workflow validation
bash tests/test-regressions.sh    # Stable contracts (retired skills stay gone)
```

CI runs all five on every PR (`.github/workflows/ci.yml`). Install deps locally:

```bash
brew install shellcheck actionlint
```

## How discovery works

Each tool finds shared rules via a different mechanism:

| Tool | Discovery |
|---|---|
| Claude Code | `@import` chain in `~/.claude/CLAUDE.md` → `~/.agents/AGENTS.md` |
| Gemini CLI | `@import` in `~/.gemini/GEMINI.md` → `~/.agents/AGENTS.md` |
| Codex CLI | Reads `AGENTS.md` natively at project root; global rules wired via `.codex/config.toml` profiles |
| Cursor | Per-project `<repo>/AGENTS.md` auto-discovered; global prefs pasted manually into Settings → Rules → User Rules |

Load order (Claude Code), later overrides earlier:

```
1. .agents/AGENTS.md          (synced)
2. ~/.agents/local-AGENTS.md  (local override)
3. .claude/CLAUDE.md          (synced)
4. ~/.claude/local-CLAUDE.md  (local override)
```
