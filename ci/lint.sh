#!/usr/bin/env bash
set -eux

if ! hash ansible-lint 2>/dev/null; then
  pip2 install ansible-lint
fi

ansible-lint playbooks/*.yml
