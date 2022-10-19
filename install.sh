#!/usr/bin/env bash
set -eu
install_git_if_needed() {
    SUDO_IF_NEEDED=''
    if [[ $EUID > 0 ]]; then
        SUDO_IF_NEEDED=sudo
    fi
    if ! hash git 2>/dev/null; then
        ${SUDO_IF_NEEDED} apt-get install --yes git
    fi
}

HOLDING_LOCATION="${HOME}/.homesick/repos/dotfiles"

if [[ ! -d ${HOLDING_LOCATION} ]]; then
  install_git_if_needed
  git clone --recursive https://github.com/ylogx/dotfiles.git ${HOLDING_LOCATION}
fi
cd ${HOLDING_LOCATION}

if [[ -d ${HOLDING_LOCATION}/.git ]]; then
    # if [[ ! -f ~/.dev_aliases ]]; then # TODO: Use better proxy to figure out if installation has finished.
    if [[ ! `git status --porcelain --untracked-files=no` ]]; then # No local git changes, can pull safely
        if $(git show-ref --verify --quiet "refs/heads/main"); then
            install_git_if_needed
            echo "Pulling latest changes from dotfiles repo."
            git pull origin main
        fi
    fi
fi

./run_ansible.sh
