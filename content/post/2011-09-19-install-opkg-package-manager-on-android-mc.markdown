---
layout: post
title: "Installing opkg Package Manager on Android (mc, rsync, screen, htop, zip, busybox, tree)"
date: "2011-09-19"
comments: true
categories: [android, opkg, packages manager, mc, rsync, screen, htop, zip, busybox, tree]
---
<!--more-->

## Install adb
### Installing adb on arch linux
``` bash
yaourt -S adb
```

## Running adb
``` bash
adb kill-server
sudo adb start-server
adb shell
```

## Installing opkg
Now run in adb shell following:

``` bash
cd /sdcard
wget http://dl.dropbox.com/u/4109351/soft/android/opkg-bootstrap-v2.tar.bz2
cd /
tar xjf /sdcard/opkg-bootstrap-v2.tar.bz2
# for non cyanogen users
wget http://dl.dropbox.com/u/4109351/soft/android/opkg.conf -O /data/local/opkg.conf
# for cyanogen users
wget http://dl.dropbox.com/u/4109351/soft/android/opkg_cyanogen.conf -O /data/local/opkg.conf
# add /data/xbin to your path
export PATH="/data/xbin:$PATH"
# make /system writable
mount -o remount,rw /system
opkg install /sdcard/opkg_0.1.7+svn519-2_arm.ipk
opkg -f /data/local/opkg.conf update
opkg install opkg
mount -o remount,ro /system
```

## Opkg usage
``` bash
opkg install rsync
opkg remove rsync
# list installed packages
opkg list_installed
# list files belonging to package
opkg files rsync
```

## Available packages
* rsync - Lightweight package management system.
* htop - Interactive processes viewer.
* mc - Midnight Commander - a powerful file manager.
* zip - Archiver for .zip files.
* tree - Tree is a recursive directory listing program.
* busybox - Tiny utilities for small and embedded systems.
* dropbear - Lightweight SSH2 server and client.
* nano - Free Pico clone with some new features.
* opkg - Lightweight package management system.
* screen - Terminal multiplexor with VT100/ANSI terminal emulation.
* terminfo - Basic terminal type definitions.
* zip - Archiver for .zip files.

[via](http://android.modaco.com/topic/299984-linux-tools-coming-to-mcr/)
