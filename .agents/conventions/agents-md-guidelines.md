# AGENTS.md Writing Guidelines

Rules for AGENTS.md and the conventions/ system. Consult during /triage when promoting INBOX items.

## Why a ceiling

Instruction compliance decays with volume. Target AGENTS.md under 200 lines.
AGENTS.md + local-AGENTS.md + CLAUDE.md all load every session – every line competes for attention.

## Inline vs conventions

- **Inline (AGENTS.md):** behavioral rules that change defaults. Short, imperative. Used every session.
- **Conventions (`.agents/conventions/`):** lookup tables, command references, language/tool how-to. On-demand.
- Test: "does the agent need this every session?" Yes → inline. No → convention.

## Gate pattern

When a topic warrants a convention, embed a gate in AGENTS.md:

```
Topic: MUST consult conventions/X.md before <trigger>. Key: <1-2 critical rules inline>.
```

- The MUST-consult is probabilistic; inline keys are the safety net.
- Works as pre-task gates (before writing shell scripts). Unreliable mid-flow.

## Mid-flow stays inline

PR body template, commit format, branch naming – used during /checkpoint, not before. Always inline.

## Triage promotion

- Apply the test above. Default to inline if uncertain – easier to extract later than to recall.
- Before adding a line: check if an existing rule covers it. Strengthen existing > add new.
- Promote general principles, not session-specific friction.
