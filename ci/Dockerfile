FROM ubuntu:latest

MAINTAINER Shubham Chaudhary <me@shubhamchaudhary.in>

WORKDIR /root/dotfiles

RUN set -eu \
    && apt-get update

CMD ["./run_ansible.sh", "--skip-tags=vim"]
