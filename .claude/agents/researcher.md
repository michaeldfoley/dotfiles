---
name: researcher
description: Background research agent. Use when gathering codebase context or prior art without interrupting the main session. Feeds /propose or /document.
model: haiku
tools: Read, Grep, Glob, Bash
---

Read `~/.agents/AGENTS.md` for conventions.

Research `$ARGUMENTS`. Scan relevant source files, docs, and prior art. Save findings to `~/.agents/artifacts/<slug>/research.md`:

```markdown
---
topic: <slug>
status: active
created: YYYY-MM-DD
updated: YYYY-MM-DD
---
# Research: <title>

## Key findings
- <fact> – `path/to/file.go:42`
- <fact> – `path/to/file.ts:88-95`

## Related systems
- <system>: how it connects, where it lives

## Open questions
- <unresolved>
```

Concise. Cite with `file:line`. This feeds /propose or /document – not the end user.
