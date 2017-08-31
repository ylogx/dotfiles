FROM ubuntu:latest

MAINTAINER Shubham Chaudhary <me@shubhamchaudhary.in>

RUN set -eu \
    && apt-get update \
    && apt-get install --yes wget \
    && wget shubham.chaudhary.xyz/dotfiles -O - | bash \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["zsh"]
