#!/usr/bin/env bash
#set -eux
set -eu
install_ansible() {
    sudo apt-get install python3-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev  # https://askubuntu.com/a/797363/259638
    sudo apt-get install python3-pip
    sudo pip3 install ansible
}

if ! hash ansible-playbook 2>/dev/null; then
    install_ansible
fi
# TODO: Be smart and infer os automatically
ansible-playbook playbooks/$1.yml -c local -i 'localhost,' ${2:-} ${3:-} ${4:-} ${5:-}  # Use as ./run_ansible.sh unix or ./run_ansible.sh osx

echo 'Please update git credential to your email address now'
echo 'Run'
echo
echo '  git config --global user.email "you@example.com"'
echo '  git config --global user.name "Your Name"'
