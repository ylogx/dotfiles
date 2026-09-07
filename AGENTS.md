# AGENTS.md

## Repo Layout

Cross-platform (macOS + Linux) dotfiles managed by [chezmoi](https://chezmoi.io). The repo root is not the dotfiles: `.chezmoiroot` points at `home/`, the chezmoi source dir. Files use chezmoi naming (`dot_zshrc.tmpl`; `private_` prefix = 0600 perms) and are written into `~` on apply. Ansible (`playbooks/`) is legacy/minimal — package install happens in chezmoi run_once scripts, not Ansible.

## Commands

```bash
make apply   # chezmoi apply --verbose
make test    # docker build (Ubuntu 24.04) — this repo's test suite
make lint    # shellcheck -S warning install.sh run_ansible.sh home/bin/executable_*
chezmoi diff            # preview before applying
chezmoi add ~/.file     # start tracking a file
chezmoi edit ~/.zshrc   # edit chezmoi source, re-applies on save
```

- No test framework exists; the Docker build is the verification. It applies with `--exclude=scripts` (run_once package installs are NOT exercised), asserts key files exist, no unresolved `{{` templates, and that bash can parse aliases/functions. CI (`.github/workflows/ci.yml`) runs the same plus `chezmoi execute-template < <file>` on every `.tmpl` — use that as a fast template syntax check. Lint is warnings-only and non-blocking in CI.

## Chezmoi Gotchas

- Platform branching is resolved at apply time: `{{ if eq .chezmoi.os "darwin" }}`. Never add runtime `uname`/`$PLATFORM` checks to shell files, and never delete the other platform's config just because this machine lacks it.
- `run_onchange_after_install-{vim,tmux}-plugins.sh.tmpl` embed `{{ include "dot_vimrc" | sha256sum }}` hash comments, so editing `.vimrc`/`.tmux.conf` automatically re-runs plugin install on the next apply. Follow this pattern for any config that needs a follow-up step.
- Template data comes from `home/.chezmoi.toml.tmpl` prompts (`name`, `email`, `signingkey`, `github_user`, `headless`), stored in `~/.config/chezmoi/chezmoi.toml`. `headless` gates GUI packages (e.g. pinentry-mac).
- `home/.chezmoiignore` excludes fish config on Linux; `home/.chezmoiremove.tmpl` deletes legacy files (antigen, homesick, `.zsh_aliases`, …) and Linux-only files on macOS — don't recreate them.
- `home/.chezmoiversion` pins chezmoi >= 2.50.0 — avoid newer-version-only features.
- `home/.chezmoiexternal.toml` fetches external deps: bass (fish), vim-plug (not Vundle), TPM. Neovim config (`~/.config/nvim`) is a symlink to `~/.vim`.

## Shell Config

- Shared by all shells: `~/.config/shell/env.sh` (POSIX env vars + PATH — the single source of truth, don't duplicate into shell-specific files), `~/.shell_aliases`, `~/.shell_functions` (sourced by bash and zsh; fish reuses env via `bass`).
- ZSH chain: `.zshenv` (brew/cargo PATH, sources env.sh) → `.zshrc` sources `~/.zsh/0N-*.zsh` in numbered order — renumbering changes load order.
- Plugins via antidote: list in `~/.zsh_plugins.txt`, compiled to a static `~/.zsh_plugins.zsh` by `01-plugins.zsh` (regenerates when the txt is newer OR the antidote clone cache is empty — deleting the `.zsh` also forces regen). starship/zoxide/direnv load via OMZ plugins in that list (zoxide/direnv `kind:defer`); only pyenv and thefuck are deferred with manual `zsh-defer`.
- Startup-performance conventions: prefer builtins over external commands (`read -r var < file` not `$(cat file)`, `(( $+commands[x] ))` not `which x`), guard every tool init on command existence, and `typeset -U path` at the end of `.zshrc` dedupes PATH.
- `~/.temp_aliases` (untracked, machine-local) is sourced at the end of `.shell_aliases`.

## Ansible

`run_ansible.sh` picks `playbooks/osx.yml` (common role: chezmoi install + apply) or `unix.yml` (ubuntu role does `chsh` to zsh, needs sudo). Not needed for most changes.
