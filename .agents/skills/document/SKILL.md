---
name: document
description: Produce a reference doc for a codebase, system, or concept. Saved to ~/.agents/artifacts/<slug>/reference.md. Use when user says 'document this', 'write a reference', or needs a standalone knowledge doc.
---

# /document

Research a codebase or system and produce a reference document with code citations.

## Bootstrap

1. Determine slug from $ARGUMENTS or conversation context.
2. If no slug: suggest 2-3 candidates from cwd (recent files, modules, key dirs).
3. Determine scope: specific file/package, system/service, or concept.
4. Read `~/.agents/conventions/artifact-templates.md` for the `reference.md` format.
5. Create `~/.agents/artifacts/<slug>/` if missing.

## Research

- Start from entry points, trace inward.
- Identify key abstractions, data flow, error paths.
- Note non-obvious design decisions and constraints.
- Check for existing docs (README, godoc, inline comments, ADRs).

## Output

Save to `~/.agents/artifacts/<slug>/reference.md`:

```markdown
---
topic: <slug>
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# <Title>

## Overview
What it does, why it exists. 2-3 sentences.

## Architecture
Key components and how they connect. Diagram if complex.

## Data Flow
How data moves through the system. Entry points, transformations, exit points.

## Key Files

For each important file, use anchored citations:

**`path/to/file.go:42-51`** – brief description

\```lang
<relevant snippet>
\```

What this does and why it matters.

## Gotchas
Surprises, edge cases, things that bit you or would bite a reader.
```

## Principles

- Cite source with `file_path:line_number` so links navigate cleanly.
- Concise. Cut what a smart reader can infer.
- Not a tutorial. Reference, not narrative.
