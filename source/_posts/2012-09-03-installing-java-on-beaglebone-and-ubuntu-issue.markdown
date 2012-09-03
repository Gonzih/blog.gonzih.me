---
layout: post
title: "Installing Oracle Embedded Java on Beaglebone and Ubuntu Issue"
date: 2012-09-03 20:58
comments: true
categories: [java, beaglebone, arm, issue]
---
Recently I was playing with Clojure on Beaglebone and decided to give a try to Oracle's new Embedded JRE.
But after downloading JRE from Oracle website (with filling useless stupid forms) I received following error:
```text
java: no such file or directory
```
So here is fix:
```sh
sudo apt-get install -y libc6-armel libsfgcc1
```
[via](https://groups.google.com/forum/?fromgroups=#!topic/pandaboard/bb53tEV5GKA)
