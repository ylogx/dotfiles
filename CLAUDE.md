# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A cross-platform dotfiles repository (macOS + Linux). Dotfiles are managed by [chezmoi](https://chezmoi.io) (source in `home/`, using chezmoi's `dot_` naming convention). Chezmoi handles package installation, tool setup, and system configuration via `run_once`/`run_onchange` scripts.

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

# Bootstrap a fresh machine
chezmoi init --apply ylogx

# Update zsh plugins
antidote update

# Build Docker image for testing
make build
```

## Architecture

### Dotfile Management
- `home/` is the chezmoi source directory — files use chezmoi naming (`dot_zshrc.tmpl`, `dot_gitconfig.tmpl`, etc.)
- `.chezmoiroot` points chezmoi at `home/`
- `chezmoi apply` writes managed files directly to `~` (no symlinks)
- Platform-specific files use chezmoi templates (`.tmpl`) — resolved at apply time, not runtime
- `.chezmoiexternal.toml` manages Vundle and TPM as git repos
- `.chezmoiscripts/` contains `run_once`/`run_onchange` scripts for package install, plugin setup, macOS defaults

### Shared Shell Config
```
~/.config/shell/env.sh  → POSIX-compatible env vars, PATH (sourced by all shells)
~/.shell_aliases         → 150+ aliases (sourced by bash and zsh)
~/.shell_functions       → welcome_message, utility functions (sourced by bash and zsh)
~/.temp_aliases         → Machine-specific aliases, not tracked in git
```

### Shell Startup Chain (ZSH)
```
.zshenv              → brew shellenv, cargo env, sources env.sh
.zshrc               → module loader (sources ~/.zsh/*.zsh)
  ~/.zsh/
    01-plugins.zsh   → antidote static load, starship prompt
    02-platform.zsh  → platform-specific paths, coreutils/gnu-sed, SSH agent
    03-path.zsh      → sources env.sh, platform-specific PATH (cuda, linuxbrew)
    04-tools.zsh     → deferred inits: direnv, pyenv, fzf, zoxide, thefuck, gcloud
    05-aliases.zsh   → sources .shell_aliases + .shell_functions, zsh-specific aliases
    06-welcome.zsh   → welcome_message
```

### Shell Startup Chain (Bash)
```
.profile             → TERM setup, sources env.sh, sources .bashrc
  └─ .bashrc         → history, prompt, starship, completion, direnv, zoxide
      ├─ .shell_aliases
      └─ .shell_functions
```

### Shell Startup Chain (Fish)
```
~/.config/fish/config.fish → bass sources env.sh, starship, zoxide, direnv, common aliases
```

### Chezmoi Scripts (home/.chezmoiscripts/)
```
run_once_before_install-packages.sh.tmpl  → brew bundle (macOS) / apt (Linux)
run_once_before_install-ohmyzsh.sh        → oh-my-zsh framework
run_once_before_install-ohmyfish.sh.tmpl  → oh-my-fish (macOS only)
run_once_after_setup-macos.sh.tmpl        → macOS defaults (screenshots, Finder)
run_onchange_after_install-vim-plugins.sh.tmpl  → vim +PluginInstall (on vimrc change)
run_onchange_after_install-tmux-plugins.sh.tmpl → tpm install (on tmux.conf change)
```

### Ansible (minimal — most tasks migrated to chezmoi)
```
playbooks/
  osx.yml        → common role only
  unix.yml       → roles: ubuntu + common
  roles/
    common/tasks/ → chezmoi install + apply (manager.yml)
    ubuntu/tasks/ → chsh to zsh (requires sudo)
```

## Important Conventions

- **Shared config across machines**: This config runs on both macOS and Linux. Don't remove things just because they're absent on the current machine — use chezmoi templates for platform-specific code.
- **Platform detection**: In chezmoi templates use `.chezmoi.os` (`darwin`/`linux`). All platform branching is resolved at `chezmoi apply` time — no runtime `$PLATFORM` variable or `uname` subprocesses needed.
- **Shared env vars**: `EDITOR`, `GOPATH`, `FZF_DEFAULT_COMMAND`, `LC_ALL`, PATH entries — all live in `~/.config/shell/env.sh`. Don't duplicate in shell-specific files.
- **Antidote plugin manager**: Plugins listed in `~/.zsh_plugins.txt`, compiled to a static `~/.zsh_plugins.zsh`. After editing the plugin list, delete `~/.zsh_plugins.zsh` to force regeneration.
- **Deferred loading**: `direnv`, `zoxide`, `pyenv`, and `thefuck` are initialized via `zsh-defer` in zsh — they load after the prompt renders to avoid blocking startup.
- **PATH deduplication**: `typeset -U path` at the end of `.zshrc` deduplicates.
- **Subprocess avoidance**: In shell startup, prefer builtins over external commands. Use `read -r var < file` instead of `$(cat file)`, `(( $+commands[x] ))` instead of `which x`.
- **welcome_message**: Uses parallel subshell (`( ... & ... & wait )`) to gather system info concurrently. Platform-aware. Defined in `.shell_functions`, called by both zsh and bash.
- **chezmoi templates**: Use Go template syntax. Template data is in `~/.config/chezmoi/chezmoi.toml`. Platform branching: `{{ if eq .chezmoi.os "darwin" }}`.
- **Fish parity**: Fish uses `bass` to source the shared POSIX env file. Common aliases are defined natively in `config.fish`.
