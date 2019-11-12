FROM nixos/nix
MAINTAINER Max Gonzih <gonzih at gmail dot com>

RUN nix-env -i gnumake git hugo

RUN mkdir -p /var/blog
VOLUME /var/blog

EXPOSE 1313

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /var/blog
