# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A cross-platform dotfiles repository (macOS + Linux). Dotfiles are managed by [chezmoi](https://chezmoi.io) (source in `chezmoi/`). Ansible playbooks automate package installation and system setup. Legacy `home/` directory contains the original homeshick-era files.

## Key Commands

```bash
# Apply dotfiles to home directory
chezmoi apply --verbose
# or: make apply

# Edit a dotfile (opens chezmoi source, applies on save)
chezmoi edit ~/.zshrc

# Add a new dotfile to chezmoi
chezmoi add ~/.some_config

# See what chezmoi would change
chezmoi diff

# Update chezmoi plugins
antidote update

# Run ansible provisioning (installs packages, configures system)
./run_ansible.sh

# Lint ansible playbooks
./ci/lint.sh     # runs ansible-lint

# Build Docker image for testing
make build
```

## Architecture

### Dotfile Management
- `chezmoi/` is the chezmoi source directory — files use chezmoi naming (`dot_zshrc`, `dot_gitconfig.tmpl`, etc.)
- `chezmoi apply` writes managed files directly to `~` (no symlinks)
- `.gitconfig` is a chezmoi template (`dot_gitconfig.tmpl`) — user/email/signingkey are populated from `~/.config/chezmoi/chezmoi.toml`
- `home/` is the legacy homeshick source (kept for reference/ansible compatibility, not actively managed)

### Shell Startup Chain (ZSH)
```
.zshenv          → brew shellenv + cargo env (runs for ALL zsh invocations)
.zshrc           → antidote plugins (static file), platform setup, PATH, deferred tool inits
  ├─ .zsh_plugins.txt → antidote plugin list (compiled to .zsh_plugins.zsh)
  ├─ .zsh_aliases     → sources .bash_aliases (shared alias file)
  │   ├─ .bash_aliases    → 150+ aliases, sources .dev_aliases.sh + .temp_aliases
  │   └─ .bash_functions  → welcome_message, utility functions
  └─ welcome_message()    → parallelized system info display
```

### Shell Startup Chain (Bash)
```
.profile         → TERM setup, sources .bashrc, cargo env
  └─ .bashrc     → platform detection, history, prompt, completion
      ├─ .bash_aliases
      └─ .bash_functions
```

### Ansible Structure
```
playbooks/
  osx.yml        → roles: osx + common
  unix.yml       → roles: ubuntu + common
  roles/
    common/tasks/ → ohmyzsh, homesick, plugins, ohmyfish, vim
    osx/tasks/    → homebrew packages/casks, macOS settings
    ubuntu/tasks/ → apt packages, hub, shell change
```

## Important Conventions

- **Shared config across machines**: This config runs on both macOS and Linux. Don't remove things just because they're absent on the current machine — use conditional checks instead (e.g., `(( $+commands[tool] ))` in zsh, `hash tool 2>/dev/null` in bash).
- **Platform detection**: Use `$OSTYPE` (zsh builtin) or `$PLATFORM` variable, never raw `uname` subprocesses in hot paths. `$PLATFORM` is set to `Mac`, `Linux`, or `FreeBSD` early in `.zshrc`.
- **Antidote plugin manager**: Plugins listed in `~/.zsh_plugins.txt`, compiled to a static `~/.zsh_plugins.zsh`. After editing the plugin list, delete `~/.zsh_plugins.zsh` to force regeneration. Update plugins with `antidote update`.
- **Deferred loading**: `direnv`, `zoxide`, `pyenv`, and `thefuck` are initialized via `zsh-defer` — they load after the prompt renders to avoid blocking startup.
- **PATH deduplication**: `typeset -U path` at the end of `.zshrc` deduplicates.
- **Subprocess avoidance**: In shell startup, prefer zsh builtins over external commands. Use `read -r var < file` instead of `$(cat file)`, `$OSTYPE` instead of `$(uname)`, `(( $+commands[x] ))` instead of `which x`.
- **welcome_message**: Uses parallel subshell (`( ... & ... & wait )`) to gather system info concurrently. Platform-aware: uses `sysctl`/`vm_stat`/`ipconfig` on Mac, `/proc/*`/`free`/`hostname -I` on Linux.
- **`.temp_aliases`**: Machine-specific aliases not tracked in git (sourced by `.bash_aliases` if present).
- **chezmoi templates**: `.gitconfig` uses Go template syntax. Template data is in `~/.config/chezmoi/chezmoi.toml`.
