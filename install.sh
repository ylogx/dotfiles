#!/usr/bin/env bash
set -eu

HOLDING_LOCATION="${HOME}/.homesick/repos/dotfiles"

if [[ ! -d ${HOLDING_LOCATION} ]]; then
  git clone --recursive git://github.com/shubhamchaudhary/dotfiles.git ${HOLDING_LOCATION}
fi
cd ${HOLDING_LOCATION}

./run_ansible.sh
