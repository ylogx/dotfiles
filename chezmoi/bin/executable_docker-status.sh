#!/bin/bash
set -eux


~/bin/docker-restart-policies.sh | sort -t '|' -k 2
~/bin/docker-container-sources.sh | sort -t '|' -k 2
