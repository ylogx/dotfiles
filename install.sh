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

install_chezmoi_if_needed() {
    if ! command -v chezmoi &>/dev/null; then
        echo "Installing chezmoi..."
        if hash curl 2>/dev/null; then
            sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin
        elif hash wget 2>/dev/null; then
            sh -c "$(wget -qO- get.chezmoi.io)" -- -b ~/.local/bin
        else
            echo "Error: curl or wget required to install chezmoi"
            exit 1
        fi
        export PATH="$HOME/.local/bin:$PATH"
    fi
}

# Migrate from homeshick if needed
OLD_REPO="${HOME}/.homesick/repos/dotfiles"
NEW_REPO="${HOME}/.dotfiles"

if [ -d "$OLD_REPO/.git" ] && [ ! -d "$NEW_REPO" ]; then
    echo "Migrating from homeshick to chezmoi..."

    # Remove old homeshick symlinks (they point to renamed/deleted files)
    echo "Removing old homeshick symlinks..."
    find "$HOME" -maxdepth 1 -type l -lname "${OLD_REPO}/home/*" -delete 2>/dev/null || true

    # Move repo to new location
    echo "Moving repo from $OLD_REPO to $NEW_REPO..."
    mv "$OLD_REPO" "$NEW_REPO"
    cd "$NEW_REPO"  # in case we were standing in the old dir

    # Clean up empty homesick directory
    rmdir "$HOME/.homesick/repos" "$HOME/.homesick" 2>/dev/null || true

    # Install chezmoi and apply
    install_chezmoi_if_needed
    chezmoi init --source="$NEW_REPO/home" --apply --force

    echo ""
    echo "Migration complete! Dotfiles now managed by chezmoi."
    echo "  Apply changes:  chezmoi apply"
    echo "  Edit a file:    chezmoi edit ~/.zshrc"
    exit 0
fi

# Fresh install or existing chezmoi setup
install_chezmoi_if_needed

if [ ! -d "$NEW_REPO" ]; then
    install_git_if_needed
    chezmoi init --apply ylogx
else
    chezmoi apply
fi

echo ""
echo "Dotfiles applied."
