# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A cross-platform dotfiles repository (macOS + Linux) managed by [homeshick](https://github.com/andsens/homeshick). Files under `home/` are symlinked to `~` via homeshick. Ansible playbooks automate package installation and system setup.

## Key Commands

```bash
# Link dotfiles to home directory
make link
# or: ~/.homesick/repos/homeshick/bin/homeshick link dotfiles --verbose

# Track a new dotfile
homeshick track dotfiles ~/.some_config

# Run ansible provisioning (installs packages, configures system)
./run_ansible.sh

# Lint ansible playbooks
make lint        # runs prettier
./ci/lint.sh     # runs ansible-lint

# Build Docker image for testing
make build
```

## Architecture

### Dotfile Management
- `home/` mirrors `~` — homeshick creates symlinks from `~/.<file>` → `home/.<file>`
- If a symlink breaks (e.g., cargo installer overwrites `~/.zshenv`), re-link with `homeshick link --force dotfiles`

### Shell Startup Chain (ZSH)
```
.zshenv          → brew shellenv + cargo env (runs for ALL zsh invocations)
.zshrc           → antigen plugins, platform setup, PATH, tool inits
  ├─ .zsh_aliases    → sources .bash_aliases (shared alias file)
  │   ├─ .bash_aliases   → 150+ aliases, sources .dev_aliases.sh + .temp_aliases
  │   └─ .bash_functions → welcome_message, utility functions
  └─ welcome_message()  → parallelized system info display
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
- **Antigen plugin manager**: Plugins are loaded conditionally based on `$+commands[...]` checks. After changing the bundle list, delete `~/.antigen/init.zsh` to force cache rebuild.
- **PATH deduplication**: `typeset -U path` at the end of `.zshrc` deduplicates. All PATH additions use `export PATH=...:$PATH` style (not the `path+=()` array style).
- **Subprocess avoidance**: In shell startup, prefer zsh builtins over external commands. Use `read -r var < file` instead of `$(cat file)`, `$OSTYPE` instead of `$(uname)`, `(( $+commands[x] ))` instead of `which x`.
- **welcome_message**: Uses parallel subshell (`( ... & ... & wait )`) to gather system info concurrently. Platform-aware: uses `sysctl`/`vm_stat`/`ipconfig` on Mac, `/proc/*`/`free`/`hostname -I` on Linux.
- **`.temp_aliases`**: Machine-specific aliases not tracked in git (sourced by `.bash_aliases` if present).
