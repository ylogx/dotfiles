# AGENTS.md

## Repo Layout

Cross-platform (macOS + Linux) dotfiles managed by [chezmoi](https://chezmoi.io). The repo root is not the dotfiles: `.chezmoiroot` points at `home/`, the chezmoi source dir. Files use chezmoi naming (`dot_zshrc.tmpl`; `private_` prefix = 0600 perms) and are written into `~` on apply. Ansible (`playbooks/`) is legacy/minimal — package install happens in chezmoi run_once scripts, not Ansible.

## Commands

```bash
make apply   # chezmoi apply --verbose
make test    # container build (Ubuntu 24.04) — this repo's test suite; docker, falls back to nerdctl (Rancher Desktop)
make lint    # shellcheck -S warning install.sh run_ansible.sh home/bin/executable_*
chezmoi diff            # preview before applying
chezmoi add ~/.file     # start tracking a file
chezmoi edit ~/.zshrc   # edit chezmoi source, re-applies on save
chezmoi init --apply ylogx   # bootstrap a fresh machine
antidote update         # refresh zsh plugins (after editing ~/.zsh_plugins.txt)
```

- No test framework exists; the Docker build is the verification. It applies with `--exclude=scripts` (run_once package installs are NOT exercised) using the CI fixture config (`.github/chezmoi-testdata.toml`), then asserts: no drift (`chezmoi diff` empty), key files exist, no unresolved `{{` templates, bash parses aliases/functions, vimrc parses under vim (plugins installed first), tmux.conf parses, and every nvim lua file passes `luac -p`. CI (`.github/workflows/ci.yml`) runs that image plus zsh/bash/nvim-boot smoke tests, renders every `.tmpl` with the fixture on both ubuntu and macos runners, and shellchecks repo scripts AND rendered `.chezmoiscripts` (blocking). Template rendering needs `--source "$PWD" --config .github/chezmoi-testdata.toml` when run outside a configured machine; `.chezmoi.toml.tmpl` itself is covered by `chezmoi init --dry-run` (promptStringOnce only exists there).

## Chezmoi Gotchas

- Platform branching is resolved at apply time: `{{ if eq .chezmoi.os "darwin" }}`. Never add runtime `uname`/`$PLATFORM` checks to shell files, and never delete the other platform's config just because this machine lacks it.
- `run_onchange_after_install-{vim,tmux}-plugins.sh.tmpl` embed `{{ include "dot_vimrc" | sha256sum }}` hash comments, so editing `.vimrc`/`.tmux.conf` automatically re-runs plugin install on the next apply. Follow this pattern for any config that needs a follow-up step.
- Template data comes from `home/.chezmoi.toml.tmpl` prompts (`name`, `email`, `signingkey`, `github_user`, `headless`), stored in `~/.config/chezmoi/chezmoi.toml`. `headless` gates GUI packages (e.g. pinentry-mac).
- `home/.chezmoiignore` excludes fish config on Linux; `home/.chezmoiremove.tmpl` deletes legacy files (antigen, homesick, `.zsh_aliases`, …) and Linux-only files on macOS — don't recreate them.
- `home/.chezmoiversion` pins chezmoi >= 2.50.0 — avoid newer-version-only features.
- `home/.chezmoiexternal.toml` fetches external deps: bass (fish), vim-plug (not Vundle), TPM. Neovim (`~/.config/nvim`) is an independent Lua config (lazy.nvim, lockfile at `home/dot_config/nvim/lazy-lock.json`); terminal vim still uses `dot_vimrc` + vim-plug. Update plugin keys via `:Lazy` / `:PlugInstall`.

## Chezmoi Scripts (home/.chezmoiscripts/)

```
run_once_before_install-packages.sh.tmpl         → brew bundle (macOS, honors headless) / apt (Linux)
run_once_before_remove-linux-only-files.sh.tmpl  → removes homeshick-symlinked Linux dotfiles on macOS
run_once_after_setup-macos.sh.tmpl               → macOS defaults
run_onchange_after_install-vim-plugins.sh.tmpl   → vim +PlugInstall/+PlugClean (on .vimrc hash change)
run_onchange_after_install-nvim-plugins.sh.tmpl  → nvim +Lazy! sync (on hash of every nvim lua file)
run_onchange_after_install-tmux-plugins.sh.tmpl  → tpm install (on .tmux.conf hash change)
run_onchange_after_reload-gpg-agent.sh.tmpl      → gpgconf --kill gpg-agent (on gpg-agent.conf hash change)
```

## Shell Config

- Shared by all shells: `~/.config/shell/env.sh` (POSIX env vars + PATH — the single source of truth, don't duplicate into shell-specific files), `~/.shell_aliases`, `~/.shell_functions` (sourced by bash and zsh; fish reuses env via `bass`).

### Shell Startup Chains

ZSH:
```
.zshenv              → brew shellenv, cargo PATH (before everything), sources env.sh
.zshrc               → sources ~/.zsh/0N-*.zsh in numbered order (renumbering changes load), then `typeset -U path`
  ~/.zsh/
    01-plugins.zsh   → antidote static load, generates ~/.zsh_plugins.zsh (new plugins → ~/.zsh_plugins.txt, not here)
    02-platform.zsh  → darwin/linux branches: GNU coreutils/sed paths, ls colors, ssh-add-if-agent-running (macOS);
                       JAVA_HOME, `open`→xdg-open (Linux)
    03-path.zsh      → sources env.sh, then platform-specific PATH (cuda, linuxbrew on Linux)
    04-tools.zsh     → tool inits, deferred where slow: pyenv/thefuck (zsh-defer), gcloud, fzf history widgets
    05-aliases.zsh   → sources .shell_aliases + .shell_functions, zsh-specific aliases (suffix aliases, `reload`)
    06-welcome.zsh   → welcome_message
```

Bash:
```
.profile             → TERM setup, path_helper (macOS), sources env.sh, sources .bashrc
  └─ .bashrc         → history, PS1, starship, fzf, direnv, zoxide
      ├─ .shell_aliases
      └─ .shell_functions
```

Fish (macOS only — `.chezmoiignore` skips it on Linux):
```
~/.config/fish/config.fish → bass sources env.sh, starship, zoxide, direnv (each guarded), native aliases
```

- Placement rule: env vars/PATH → `env.sh`; tool init → `04-tools`; aliases/functions → `.shell_aliases`/`.shell_functions`; zsh-only tweaks → `05-aliases`.
- Plugins via antidote: list in `~/.zsh_plugins.txt`, compiled to a static `~/.zsh_plugins.zsh` by `01-plugins.zsh` (regenerates when the txt is newer OR the antidote clone cache is empty — deleting the `.zsh` also forces regen). starship/zoxide/direnv load via OMZ plugins in that list (zoxide/direnv `kind:defer`); only pyenv and thefuck are deferred with manual `zsh-defer`.
- Startup-performance conventions: prefer builtins over external commands (`read -r var < file` not `$(cat file)`, `(( $+commands[x] ))` not `which x`), guard every tool init on command existence, and `typeset -U path` at the end of `.zshrc` dedupes PATH.
- `~/.temp_aliases` (untracked, machine-local) is sourced at the end of `.shell_aliases`.

## Ansible

`run_ansible.sh` picks `playbooks/osx.yml` (common role: chezmoi install + apply) or `unix.yml` (ubuntu role does `chsh` to zsh, needs sudo). Not needed for most changes.
