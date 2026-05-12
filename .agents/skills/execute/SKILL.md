---
name: execute
description: Execute phased implementation plans from ~/.agents/artifacts/<slug>/plan.md. Works through phases with testable checkpoints. Use when the user wants to implement, build, or says 'execute', 'build this', 'implement'.
---

# /execute

Execute a phased plan. Each phase is independently valuable and testable.

## Bootstrap

1. Read `~/.agents/AGENTS.md` for conventions (commit style, PR template, safety).
2. Determine slug from $ARGUMENTS, or infer from conversation.
3. Check `~/.agents/artifacts/<slug>/`:
   - **`plan.md` exists**: read it, find next unchecked phase, inspect `output.md` / `review.md` if present, resume there.
   - **No `plan.md` but `design.md` exists**: derive `plan.md` from design. Append unresolved `## Open` items from problem/design as phase 0 decisions.
   - **Nothing exists**: draft `plan.md` from task description.
4. Confirm the plan with user before executing (skip in autonomous mode).

## Plan format

See `~/.agents/conventions/artifact-templates.md`. Each phase has tasks + a `**Verify**` checkbox with test criteria.

## Execution

For each phase:
1. Read the phase tasks.
2. Work through them sequentially.
3. Check off tasks in `plan.md` as completed.
4. Keep `output.md` current for the active deliverable; add branch / PR / review refs as known.
5. Add references inline (PR links, file paths, test output).
6. At phase end: run the `**Verify**` criteria.
7. **Stop and report.** Let the user validate before continuing.

Completion note shape:
```markdown
- [x] Task 1 – [PR #123](url)
- [x] Task 2
- [x] **Verify**: passed – `tests/foo.test.ts` green
```

## Modes

Default is interactive. User can request:
- **interactive** (default): confirm at logical boundaries, stop at phase end.
- **autonomous**: execute all remaining phases. Draft PRs only, never merge. Stop on failure or ambiguity. Overrides confirmation gates except safety rules. (Pairs with /yolo.)

## On completion

- Update `plan.md` frontmatter `status: shipped` (or `abandoned` if work stopped).
- Update `output.md` `status` + final PR link.
- Offer /checkpoint if not already routed through it.
