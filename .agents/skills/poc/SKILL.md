---
name: poc
description: Prove an idea works – fast, minimal, with gaps documented. Compound skill chaining /propose (light), /execute (phase 1 only, hacks allowed), /checkpoint. Use when user says 'poc', 'prototype', 'prove this works'.
---

# /poc

Prove an idea works with minimal effort. Compounds three skills into one flow.

Pairs with `/yolo` for autonomous execution. Override confirmation gates; safety rules still apply.

## Flow

1. **Propose (light)** – create `~/.agents/artifacts/<slug>/problem.md`, lightweight (Impact + Requirements only, 3-5 lines). Skip `design.md` – the poc IS the design test. 2-3 minutes max.

2. **Execute (phase 1 only)** – scaffold `plan.md` with a single phase: the shortest path to "it works." Autonomous. Explicitly allowed:
   - Hardcoded values, magic strings
   - No tests, no error handling
   - `TODO` comments for production concerns
   - Console output instead of proper UI

3. **Checkpoint** – commit, push, open draft PR with this body:

```markdown
## Idea
<what this proves – link to problem.md>

## Demo
<how to run / see it working>

## Gaps
- [ ] <hardcoded values>
- [ ] <missing for production>
- [ ] <needs tests>

## Next steps
<what production-izing looks like>
```

## Guardrails

- **Never merge.** Draft only.
- Single branch `poc/<slug>`, single PR – no stacking.
- **Scope guard:** if implementation balloons past poc, stop and ship what works. Don't grow into a full feature mid-flight.
- Hard safety rules still apply (AGENTS.md Safety section).

## Next

On completion, print: `POC done. /propose for full design, or /checkpoint to ship as-is.`
