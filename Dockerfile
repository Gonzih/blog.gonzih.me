from gonzih/archlinux
maintainer Max Gonzih <gonzih at gmail dot com>

run pacman -Suy --noconfirm

run pacman -S ruby nodejs make base-devel --noconfirm

volume /var/blog

expose 4000

# Set the locale
run locale-gen en_US.UTF-8
env LANG en_US.UTF-8
env LANGUAGE en_US:en
env LC_ALL en_US.UTF-8

env USER gnzh

run useradd $USER
run mkdir -p /home/$USER
run chown $USER:$USER /home/$USER

user $USER
env HOME /home/$USER/
env PATH $PATH:/home/$USER/.gem/ruby/2.2.0/bin
run gem install bundler

workdir /var/blog
