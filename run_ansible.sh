#!/usr/bin/env bash
#set -eux
set -eu

install_ansible() {
    SUDO_IF_NEEDED=''
    if [[ $EUID > 0 ]]; then
        SUDO_IF_NEEDED=sudo
    fi
    if ! hash gcc 2>/dev/null; then
	${SUDO_IF_NEEDED} apt-get install --yes gcc
    fi
    if ! hash python3 2>/dev/null; then
	${SUDO_IF_NEEDED} apt-get install --yes python3 python3-pip  # https://askubuntu.com/a/797363/259638
    fi
    ${SUDO_IF_NEEDED} python3 -m pip install ansible
}

if ! hash ansible-playbook 2>/dev/null; then
    install_ansible
fi
case "${OSTYPE}" in
  #solaris*) echo "SOLARIS" ;;
  darwin*)  PLAYBOOK_NAME="osx" ;;
  #linux-gnu*)   PLAYBOOK_NAME="debian"  ;;
  linux*)   PLAYBOOK_NAME="unix"  ;;
  #bsd*)     echo "BSD" ;;
  #msys*)    echo "WINDOWS" ;;
  *)        echo "Unknown OS: ${OSTYPE}" && exit -1 ;;
esac
echo "Running playbook for ${PLAYBOOK_NAME} os."

ansible-playbook playbooks/${PLAYBOOK_NAME}.yml \
  -u `whoami` \
  -c local -i 'localhost,' \
  ${1:-} ${2:-} ${3:-} ${4:-} ${5:-}  # Use as ./run_ansible.sh ...  # Any additional ansible flags

# TODO: Run if not chaudhary in username
echo 'Please update git credential to your email address now'
echo 'Current values are:'
echo `cat ~/.gitconfig | grep 'name =' -A1`
echo 'Run'
echo
echo '  git config --global user.email "you@example.com"'
echo '  git config --global user.name "Your Name"'
