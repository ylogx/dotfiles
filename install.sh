#!/usr/bin/env bash
set -eu

install_git_if_needed() {
    if ! command -v git >/dev/null 2>&1; then
        if [[ $EUID > 0 ]]; then
            sudo apt-get install --yes git
        else
            apt-get install --yes git
        fi
    fi
}

install_chezmoi_if_needed() {
    if ! command -v chezmoi &>/dev/null; then
        echo "Installing chezmoi..."
        if command -v curl >/dev/null 2>&1; then
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
        elif command -v wget >/dev/null 2>&1; then
            sh -c "$(wget -qO- get.chezmoi.io)" -- -b ~/.local/bin
        else
            echo "Error: curl or wget required to install chezmoi"
            exit 1
        fi
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

install_chezmoi_if_needed

NEW_REPO="${HOME}/.dotfiles"
if [ ! -d "$NEW_REPO" ]; then
    install_git_if_needed
    chezmoi init --apply ylogx
else
    chezmoi apply
fi

echo ""
echo "Dotfiles applied."
