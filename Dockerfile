FROM gonzih/archlinux
MAINTAINER Max Gonzih <gonzih at gmail dot com>

RUN pacman -Suy --noconfirm

RUN pacman -S python2 ruby nodejs make base-devel --noconfirm

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
ENV PATH $PATH:$HOME/bin
ENV PATH $PATH:$HOME/.gem/ruby/2.2.0/bin
RUN gem install bundler

WORKDIR /var/blog
