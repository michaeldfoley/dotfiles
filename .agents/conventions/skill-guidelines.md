# Skill Design Guidelines

Consult before creating or refining skills in `.agents/skills/`.

## Skill vs AGENTS.md rule

- **Inline rule:** single command + context. Fits one paragraph. e.g., "always use --draft for PRs."
- **Skill:** multi-step workflow, branching logic, cross-repo, or produces artifacts. e.g., /checkpoint, /triage.

If you'd struggle to write it as a single imperative line, it's a skill.

## Structure

- `SKILL.md` with YAML frontmatter: `name`, `description`.
- The `description` is the trigger – be specific about when to invoke. Claude Code's skill picker reads this.
- Front-load the bootstrap: agents read top-down, may stop early. Lead with what gets created/modified/run.
- Reference AGENTS.md for shared conventions; don't duplicate.
- Exception: Claude Code subagents run isolated. Inline essential conventions (commit style, safety rules).

## Blast radius

Every skill declares what it modifies:
- Read-only (review, retro): no side effects beyond output files.
- Write (checkpoint, triage): enumerate writes.
- Destructive ops: require explicit confirmation; support `--dry-run` where it makes sense.

## Composability

- Skills can call other skills (e.g., /checkpoint runs /retro at end).
- Don't duplicate workflows across skills – factor shared logic into a third skill or AGENTS.md.
- One verb per skill. `/checkpoint` ships; `/retro` captures; don't merge them.

## Lifecycle decisions

**Adding overlaps existing:** decide retirement first. List overlaps explicitly; ask "what gets retired?" Otherwise: competing entry points and "which do I use when?" confusion.

**Before retiring:** enumerate the skill's features – not just the primary one. Orthogonal capabilities get lost silently if the replacement doesn't cover them (e.g., new-project bootstrap inside a design-doc skill). Surface gaps before retiring.

**Fold vs separate:** if a new skill's primary use case is a gate inside an existing skill, fold it as a step (e.g., /tidy → /checkpoint step 1). If it's also useful independently, keep separate (e.g., /document next to /walkthrough).

## Naming

- Verb-first, kebab-case: `checkpoint`, `triage`, `proposal-template`.
- Match the slash-command the user types.
