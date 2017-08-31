FROM ubuntu:latest

MAINTAINER Shubham Chaudhary <me@shubhamchaudhary.in>

RUN set -eu \
    && apt-get update \
    && apt-get install --yes curl \
    && curl -sL shubham.chaudhary.xyz/dotfiles | bash \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["zsh"]
