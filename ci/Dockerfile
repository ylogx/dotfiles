FROM ubuntu:latest

MAINTAINER Shubham Chaudhary <me@shubhamchaudhary.in>

WORKDIR /root/dotfiles

RUN set -eu \
    && apt-get update \
    && apt-get install -y gcc python-dev libffi-dev libssl-dev libxml2-dev libxslt1-dev zlib1g-dev python-pip \
    && python -m pip install ansible \
    && rm -rf /var/lib/apt/lists/*

CMD ["./run_ansible.sh", "--skip-tags=vim"]
