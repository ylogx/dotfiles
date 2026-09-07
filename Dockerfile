FROM ubuntu:24.04

LABEL maintainer="Shubham Chaudhary <shubham@chaudhary.xyz>"

# UTF-8 locale (C.UTF-8 is built in) — the vim config uses unicode
# fillchars/listchars which fail to parse under a plain C locale
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install minimal dependencies + parse-test tools (vim/tmux for config
# smoke tests, lua for nvim config syntax checks)
RUN set -eu \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
       ca-certificates curl git sudo zsh vim tmux lua5.4 make gcc libc6-dev \
    && rm -rf /var/lib/apt/lists/*

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Neovim (apt ships 0.9.5 — too old for this config, which uses the
# 0.11+ native LSP API); stable tarball from GitHub releases, arch-aware
RUN set -eu \
    && case "$(uname -m)" in \
        aarch64 | arm64) NVIM_ARCH=arm64 ;; \
        *) NVIM_ARCH=x86_64 ;; \
    esac \
    && curl -fsSL "https://github.com/neovim/neovim/releases/download/stable/nvim-linux-${NVIM_ARCH}.tar.gz" -o /tmp/nvim.tar.gz \
    && tar -xzf /tmp/nvim.tar.gz -C /opt \
    && ln -s "/opt/nvim-linux-${NVIM_ARCH}/bin/nvim" /usr/local/bin/nvim \
    && rm /tmp/nvim.tar.gz

# Copy repo as chezmoi source
COPY . /root/.dotfiles

# Use the CI fixture as config: supplies name/email/signingkey/headless so
# .chezmoi.toml.tmpl's prompts resolve deterministically (no TTY games)
RUN mkdir -p /root/.config/chezmoi \
    && cp /root/.dotfiles/.github/chezmoi-testdata.toml /root/.config/chezmoi/chezmoi.toml

# Apply dotfiles (skip run_once scripts — they install packages which we test separately)
RUN chezmoi apply --source=/root/.dotfiles/home --force --exclude=scripts

# Drift check: applying must leave nothing to change (catches
# non-deterministic templates and scripts fighting the managed state)
RUN [ -z "$(chezmoi diff --source=/root/.dotfiles/home --exclude=scripts)" ] \
    && echo "VERIFY: no drift after apply"

# Verify key files exist
RUN test -f /root/.zshrc \
    && test -f /root/.bashrc \
    && test -f /root/.shell_aliases \
    && test -f /root/.shell_functions \
    && test -f /root/.config/shell/env.sh \
    && test -f /root/.config/starship.toml \
    && test -d /root/.zsh \
    && test -f /root/.zsh/01-plugins.zsh \
    && test -f /root/.tmux.conf \
    && test -f /root/.vimrc \
    && test -f /root/.config/nvim/init.lua \
    && test -f /root/.config/nvim/lua/plugins/lsp.lua \
    && test -f /root/.gitconfig \
    && echo "VERIFY: all managed files present"

# Verify templates rendered (no {{ in output)
RUN ! grep -r '{{' /root/.zshrc /root/.bashrc /root/.shell_aliases /root/.shell_functions /root/.profile 2>/dev/null \
    && echo "VERIFY: no unresolved templates"

# Verify shell_aliases has no runtime hash checks (all resolved by chezmoi)
RUN ! grep '^hash ' /root/.shell_aliases \
    && echo "VERIFY: no runtime hash checks in aliases"

# Verify bash can parse the config. `;` between sources (not &&): the
# aliases file legitimately ends with a failing [ -f ~/.temp_aliases ]
# conditional, so plain `source` returns 1; real syntax errors abort hard
RUN bash -c 'source /root/.shell_aliases; source /root/.shell_functions && echo "VERIFY: bash parse OK"'

# Parse smoke test: vim config loads cleanly (plugins installed first —
# the colorscheme is a plugin; the install invocation itself may report
# the missing-colorscheme error on first boot, hence || true — the strict
# parse below is the actual check)
# Parse smoke test: vim config loads cleanly (plugins installed first —
# the colorscheme is a plugin). The PlugInstall invocation's exit code is
# not authoritative (benign startup noise can set it); the strict parse
# below is the real check.
RUN vim -Nu /root/.vimrc -es "+PlugInstall --sync" "+qall!" || true \
    && vim -Nu /root/.vimrc -es "+qall!" \
    && echo "VERIFY: vimrc parses (with plugins)"

# Parse smoke test: tmux config is valid
RUN tmux -f /root/.tmux.conf -L smoke start-server \; kill-server \
    && echo "VERIFY: tmux.conf parses"

# Parse smoke test: every nvim lua file is syntactically valid lua
RUN find /root/.config/nvim -name '*.lua' -print0 | xargs -0 -n1 luac5.4 -p \
    && echo "VERIFY: nvim lua syntax OK"

CMD ["zsh"]
