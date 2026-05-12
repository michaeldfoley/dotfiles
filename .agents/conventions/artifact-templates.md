# Artifact Templates

Schemas for artifacts under `~/.agents/artifacts/<slug>/`. Consult when creating artifacts via /propose, /execute, /document.

## Location

- `~/.agents/artifacts/` is a standalone local git repo. Not synced via dotfiles.
- One directory per topic: `~/.agents/artifacts/<slug>/`. Slug is kebab-case, specific to the work.
- Chronology lives in `created:` frontmatter, not the directory name.

## Frontmatter schema

```yaml
---
topic: <slug>           # matches directory name
repo: <repo-name>       # which code repo this relates to (optional)
component: <area>       # subsystem/area (optional)
status: draft | active | shipped | abandoned
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
```

`status` semantics:
- `draft` – problem/design in progress, not committed to building
- `active` – plan exists, work in progress
- `shipped` – output delivered (PR merged or otherwise complete)
- `abandoned` – work stopped, won't revisit

## Pipeline overview

```
problem.md  → design.md  → plan.md  → output.md  → review.md
   why          how          what       delivery     loop
```

Scale to task size – not every artifact is required (see /propose Scaling).

## problem.md – why

```markdown
---
topic: <slug>
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Problem: <title>

## Impact
<what's broken and why it matters>

## Requirements
<what a solution must satisfy>

## Context
<how this surfaced, relevant history>

## Open
- [ ] <unresolved questions>
```

Quick tasks: 3-5 lines total, skip Context. Big initiatives: full template.

## design.md – how

```markdown
---
topic: <slug>
status: draft
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Design: <title>

## Approach
<how it works, key decisions>

## Tradeoffs
<alternatives considered, what was chosen and why – steelman each>

## Requirements check
- [x] <requirement from problem.md> – how it's satisfied

## Open
- [ ] <unresolved questions>
```

## plan.md – what / when

```markdown
---
topic: <slug>
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Plan: <title>

## Outputs
- [ ] <output slug> – planned | active | shipped. Branch / PR / review refs when known.

## Phase N: <Name>
- [ ] Task 1
- [ ] Task 2
- [ ] **Verify**: <test criteria>

## Open
- [ ] <unresolved questions>
```

/execute ticks tasks, appends PR links + file paths, advances `status`.

## output.md – the delivery unit

Default for one-plan-one-output topics. If a topic has multiple independently reviewable deliverables, use `outputs/<slug>.md` instead.

```markdown
---
topic: <slug>
status: draft | active | shipped
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Output: <title>

## Summary
<what this output is and why it exists>

## Links
- Plan: <path>
- Branch: <branch name>
- PR: <url or pending>
- Review: <path or pending>

## State
- Current phase: <phase name>
- Next step: <what happens next>
```

## review.md – review loop

Default for one-plan-one-output topics. Multiple outputs: `reviews/<slug>.md` linked from the matching output.

```markdown
---
topic: <slug>
status: active | clean | waived
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Review: <title>

## Action items
- [ ] P0 <blocking>
- [ ] P1 <should-fix>
- [ ] P2 <optional>

## Future features
- <new PR or later follow-up>

## Future learnings
- <candidate process/workflow lesson>

## Resolution log
- YYYY-MM-DD HH:MM – <what changed or what was waived>
```

## reference.md – learnings

Non-actionable knowledge. No pipeline, no `## Open`.

```markdown
---
topic: <slug>
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# <title>

<content – explanations, patterns, how things work, code citations>
```
