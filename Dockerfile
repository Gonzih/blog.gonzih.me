FROM ubuntu:14.04
MAINTAINER Max Gonzih <gonzih at gmail dot com>

RUN apt-get update && apt-get -y upgrade

RUN apt-get -y install python2.7 ruby ruby-dev nodejs make build-essential
RUN gem install bundler

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
RUN ln -s /usr/bin/python2 $HOME/bin/python
ENV HOME /home/$USER/

WORKDIR /var/blog
