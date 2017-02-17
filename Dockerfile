FROM golang:1.8
MAINTAINER Max Gonzih <gonzih at gmail dot com>

VOLUME /var/blog

EXPOSE 4000

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV USER gnzh

RUN useradd -m $USER

USER $USER
RUN mkdir $HOME/bin
ENV HOME /home/$USER/

RUN go get github.com/spf13/hugo

WORKDIR /var/blog
