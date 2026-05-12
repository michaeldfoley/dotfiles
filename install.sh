#!/bin/bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

# Install fzf if missing
if ! command -v fzf &> /dev/null; then
  echo "Installing fzf..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    brew install fzf
  elif command -v apt-get &> /dev/null; then
    sudo apt-get update && sudo apt-get install -y fzf
  else
    echo "Warning: fzf not found, install manually"
  fi
fi

mkdir -p ~/.claude ~/.cursor ~/.agents

# Shared source of truth
ln -sfn "$DOTFILES/.agents/skills" ~/.agents/skills
ln -sfn "$DOTFILES/.agents/conventions" ~/.agents/conventions
ln -sf "$DOTFILES/.agents/AGENTS.md" ~/.agents/AGENTS.md

# Claude Code discovery
ln -sfn "$DOTFILES/.agents/skills" ~/.claude/skills
ln -sf "$DOTFILES/.claude/CLAUDE.md" ~/.claude/CLAUDE.md
ln -sf "$DOTFILES/.claude/settings.json" ~/.claude/settings.json
ln -sfn "$DOTFILES/.claude/agents" ~/.claude/agents

# Cursor discovery
ln -sfn "$DOTFILES/.agents/skills" ~/.cursor/skills
ln -sfn "$DOTFILES/.cursor/rules" ~/.cursor/rules

# Gemini CLI – imports shared AGENTS.md
mkdir -p ~/.gemini
ln -sf "$DOTFILES/.gemini/GEMINI.md" ~/.gemini/GEMINI.md

# Codex CLI – config.toml stays manual (merge from .codex/config.toml.example).
# review-instructions.md is referenced by absolute path from config profiles.

git config --global pull.rebase true

echo "Done. Symlinked:"
echo "  ~/.agents/AGENTS.md → $DOTFILES/.agents/AGENTS.md"
echo "  ~/.agents/skills/ → $DOTFILES/.agents/skills/"
echo "  ~/.agents/conventions/ → $DOTFILES/.agents/conventions/"
echo "  ~/.claude/CLAUDE.md → $DOTFILES/.claude/CLAUDE.md"
echo "  ~/.claude/settings.json → $DOTFILES/.claude/settings.json"
echo "  ~/.claude/agents/ → $DOTFILES/.claude/agents/"
echo "  ~/.claude/skills/ → $DOTFILES/.agents/skills/"
echo "  ~/.cursor/skills/ → $DOTFILES/.agents/skills/"
echo "  ~/.cursor/rules/ → $DOTFILES/.cursor/rules/"
echo "  ~/.gemini/GEMINI.md → $DOTFILES/.gemini/GEMINI.md"
