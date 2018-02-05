#!/usr/bin/env bash
set -eu
set -o pipefail

if ! hash ansible-lint 2>/dev/null; then
  pip2 install ansible-lint
fi

echo "Running Lint:"
ansible-lint playbooks/*.yml || ansible-lint playbooks/*.yml | grep ANSIBLE | sort -rn | uniq -c
echo "Successfully passed."
