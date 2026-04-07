FROM ubuntu:24.04

LABEL maintainer="Shubham Chaudhary <shubham@chaudhary.xyz>"

# Install minimal dependencies
RUN set -eu \
    && apt-get update \
    && apt-get install --yes --no-install-recommends \
       curl git sudo zsh ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install chezmoi
RUN sh -c "$(curl -fsLS get.chezmoi.io)" -- -b /usr/local/bin

# Copy repo as chezmoi source
COPY . /root/.dotfiles

# Apply dotfiles (skip run_once scripts — they install packages which we test separately)
RUN chezmoi apply --source=/root/.dotfiles/home --force --exclude=scripts

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
    && test -f /root/.gitconfig \
    && echo "VERIFY: all managed files present"

# Verify templates rendered (no {{ in output)
RUN ! grep -r '{{' /root/.zshrc /root/.bashrc /root/.shell_aliases /root/.shell_functions /root/.profile 2>/dev/null \
    && echo "VERIFY: no unresolved templates"

# Verify shell_aliases has no runtime hash checks (all resolved by chezmoi)
RUN ! grep '^hash ' /root/.shell_aliases \
    && echo "VERIFY: no runtime hash checks in aliases"

# Verify bash can parse the config
RUN bash -c 'source /root/.shell_aliases && source /root/.shell_functions && echo "VERIFY: bash parse OK"'

CMD ["zsh"]
