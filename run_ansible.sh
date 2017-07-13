#!/usr/bin/env bash
install_ansible() {
    sudo apt-get install python3-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev libjpeg8-dev zlib1g-dev  # https://askubuntu.com/a/797363/259638
    sudo apt-get install python3-pip
    sudo pip3 install ansible
}

# TODO: Run only if ansible-playbook doesn't exists
install_ansible
# TODO: Be smart and infer os automatically
ansible-playbook playbooks/$1.yml -c local -i 'localhost,'  # Use as ./run_ansible.sh unix or ./run_ansible.sh osx

