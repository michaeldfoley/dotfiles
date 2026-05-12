# CLI Design Guidelines

Source: https://clig.dev/

Consult before writing or improving any CLI tool (Go, shell, TS).

## Arguments & flags

- Prefer flags over positional args – clearer, easier to extend.
- Both short (`-h`) and long (`--help`); short forms only for top-level common options.
- Standard names: `-q/--quiet`, `-v/--verbose`, `-f/--force`, `-n/--dry-run`, `--json`, `-o/--output`, `--no-input`.
- Never read secrets from flags (visible in `ps`, shell history). Use stdin, `--password-file`, or credential stores.
- Support `-` for stdin/stdout in file arguments.
- Order-independent flags where feasible.

## Output

- Primary output → stdout. Messages/errors/progress → stderr.
- Detect TTY: human-readable by default, machine-friendly when piped.
- `--json` for structured output. `--plain` to disable formatting.
- Respect `NO_COLOR` env var + `TERM=dumb`. Add a `--no-color` flag too.

## Errors

- Say what went wrong AND suggest a fix.
- Non-zero exit on failure; document exit codes if more than 0/1.
- Don't swallow errors silently – log to stderr at minimum.

## Subcommands

- First arg is always a verb. Explicit subcommands over positional fallthrough.
- `--help` works at every level (top-level + each subcommand).
- Order: `tool <verb> [flags] [args]`.

## Composition

- Tool layering: lower-level tools never call higher-level. Each independently useful.
- One job per tool. If a tool needs a "mode" flag for fundamentally different behavior, it's two tools.
