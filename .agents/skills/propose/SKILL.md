---
name: propose
description: Create or continue the problem → design → plan pipeline at ~/.agents/artifacts/<slug>/. Use when the user says 'propose', 'design', 'rfc', or needs to think through a system before building it.
---

# /propose

Produce artifacts at `~/.agents/artifacts/<slug>/`. Context-aware – picks up where the pipeline left off.

## Bootstrap

1. Read `~/.agents/conventions/artifact-templates.md` for schemas.
2. Determine slug from $ARGUMENTS or conversation context. Confirm with user if ambiguous.
3. Create `~/.agents/artifacts/<slug>/` if missing.
4. Inspect what exists, pick up there:
   - **Nothing**: start with `problem.md`.
   - **problem.md only**: read it, continue to `design.md`.
   - **design.md exists**: confirmation gate. Read it + problem.md, present:
     1. Iterate on design
     2. Generate `plan.md`
     3. Start fresh
     Plan only after explicit "generate plan" choice.
   - **plan.md exists**: offer to revise or hand off to /execute.

## Workflow

1. **Research** (before design; skip for quick tasks): spawn Explore subagent to scan related systems, utilities, conventions, prior art. Append findings to `problem.md ## Context`.
2. Ask 2-3 focused questions to clarify scope. Skip if context is clear.
3. Draft iteratively – present each section, refine.
4. Write the next doc in the pipeline.
5. When `plan.md` is reached, offer /execute handoff.

## Scaling

Match verbosity to size:
- **Quick task** (alias, config tweak, small fix): lightweight `problem.md` (3-5 lines), skip research + design, go straight to `plan.md`. No confirmation gate.
- **Medium** (feature, refactor, tool): problem + design, maybe combined.
- **Large** (system, architecture, multi-session): full pipeline, all sections.

## Principles

- Most important info first. Problem statement stands alone.
- Concise. Cut what a reader can infer.
- `## Open` is for real blockers/decisions, not wishlists.
- Tradeoffs: steelman each alternative before choosing. If user pushes back, steelman their position before responding.
- Plan phases feed directly to /execute.

## Done

Print: `Plan ready at ~/.agents/artifacts/<slug>/plan.md. Next: /execute <slug>.`
