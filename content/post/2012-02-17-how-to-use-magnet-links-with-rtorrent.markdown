---
layout: post
title: "How to use Magnet Links with RTorrent"
date: "2012-02-17"
comments: true
categories: [rtorrent, magnet links, bash]
---

Here simple script that will add magnet link as torrent file to your watch directory. You can use it from command line or set it in your browser to handle magnet links.

``` bash
#!/bin/bash

cd ~/watch    # set your watch directory here
[[ "$1" =~ xt=urn:btih:([^&/]+) ]] || exit;
echo "d10:magnet-uri${#1}:${1}e" > "meta-${BASH_REMATCH[1]}.torrent"
```
[via](https://libtorrent.rakshasa.no/ticket/2100)
<!--more-->
