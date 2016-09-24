FROM ubuntu:16.04
MAINTAINER Max Gonzih <gonzih at gmail dot com>

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install go

VOLUME /var/blog

EXPOSE 4000

# Set the locale
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV USER gnzh

RUN useradd -m $USER

USER $USER
RUN mkdir $HOME/bin
ENV HOME /home/$USER/

WORKDIR /var/blog
