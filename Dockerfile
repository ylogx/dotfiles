FROM ubuntu:latest

MAINTAINER Shubham Chaudhary <me@shubhamchaudhary.in>

RUN set -eu \
    && apt-get update \
    && curl -sL shubham.chaudhary.xyz/dotfiles | bash \
    && rm -rf /var/lib/apt/lists/*
