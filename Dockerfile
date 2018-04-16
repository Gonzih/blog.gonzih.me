FROM golang:1.10-alpine
MAINTAINER Max Gonzih <gonzih at gmail dot com>

RUN apk update && apk add git make bash

VOLUME /var/blog

EXPOSE 1313

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

ENV USER gnzh

ARG GNZHUID 1000

RUN adduser -S -u $GNZHUID $USER

USER $USER
RUN mkdir $HOME/bin
ENV HOME /home/$USER/

RUN go get -u github.com/spf13/hugo

WORKDIR /var/blog
