#!/usr/bin/env bash
set -eu

install_git_if_needed() {
    if ! hash git 2>/dev/null; then
        if [[ $EUID > 0 ]]; then
            sudo apt-get install --yes git
        else
            apt-get install --yes git
        fi
    fi
}

# Install chezmoi if missing
if ! command -v chezmoi &>/dev/null; then
    echo "Installing chezmoi..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"
fi

# Bootstrap: clone repo and apply dotfiles in one step
if [ ! -d "${HOME}/.dotfiles" ]; then
    install_git_if_needed
    chezmoi init --apply ylogx
else
    # Repo already exists — just apply
    chezmoi apply
fi

echo ""
echo "Dotfiles applied. Run ./run_ansible.sh for system packages and settings."
