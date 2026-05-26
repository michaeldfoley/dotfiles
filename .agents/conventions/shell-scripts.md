# Shell Script Conventions

Consult before writing or modifying shell scripts (`install.sh`, dotfiles tools, aliases).

## Strict mode

- `set -euo pipefail` at top of every bash script.
- Add `-E` (errtrace) if using ERR traps – ensures functions/subshells inherit them.
- `-u` breaks when sourcing files with unset vars – wrap with `set +u; source file; set -u`.
- `pipefail` is bash-only (not POSIX sh/dash) – errors if script runs as `sh`.
- bash 3.2 (macOS): `local -a arr` without init triggers unbound under `-u`. Always `local -a arr=()`.

## BSD vs GNU (macOS portability)

dotfiles must work on macOS (BSD coreutils) and Linux (GNU). Verify before shipping:

- `sed -i` – BSD requires backup arg: `sed -i '' 's/x/y/'` vs GNU `sed -i 's/x/y/'`.
- `date` – GNU `date -d "..."` vs BSD `date -j -f "..." "..."`.
- `readlink -f` – GNU only. BSD has no `-f`; use a python fallback or guard.
- `stat` – GNU `stat -c` vs BSD `stat -f`.
- `find -printf` – GNU only. Use `-exec` on BSD.
- Guard branches: `if [[ "$OSTYPE" == "darwin"* ]]; then ...`.
- Platform commands (`open`, `pbcopy`, `pbpaste`): guard with `command -v`.

## Quoting

- Always quote variable expansions: `"$var"`, `"$(cmd)"`, `"${arr[@]}"`.
- Unquoted = deliberate word splitting; comment why.
- `"${arr[@]}"` expands each element as a separate word.
- Command substitution: `$(cmd)` not backticks.

## Error handling

- `trap cleanup EXIT` for temp files and background processes.
- Temp files: always `mktemp`, never hardcoded `/tmp/myfile`.
- Batch processors: rescue per item, not per batch. One bad input shouldn't kill the run.

## Shell startup (zshrc)

- Never source commands that hit the network at startup. Auth/token refreshes: on-demand or lazy.
- Conditional last lines: end with `true` to avoid exit-code leaks from the final branch.

## Setup scripts (install.sh, bootstrap)

- Never reference repo-internal paths that don't exist in the repo (no aspirational symlinks). A local env may have the missing dir so it works for the author, while a fresh checkout fails under `set -e`.
- Guard optional directories with `[[ -d <path> ]]` or commit a placeholder so the path exists.
- Test from a fresh checkout (`git clean -fdx` + reinstall) before merging – `set -e` aborts silently for downstream users.
