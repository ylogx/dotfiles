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

./run_ansible.sh
