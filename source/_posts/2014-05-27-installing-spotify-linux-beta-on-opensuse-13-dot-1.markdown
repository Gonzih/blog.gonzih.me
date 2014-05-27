---
layout: post
title: "Installing Spotify Linux beta on OpenSUSE 13.1"
date: 2014-05-27 13:31
comments: true
categories: [linux, opensuse, zypper, rpm, spotify, deb]
---

Very small post (more like insruction for myself for the future) on how to convert deb packages provided by Spotify to rpm.
Solution can be applied to any rpm based system (I think so).

* Install [alien](http://software.opensuse.org/package/alien) (perl scripts for converting packages).
* Download deb from [spotify repository](http://repository.spotify.com/pool/non-free/s/spotify/), pay attention to architecture.
* Convert deb -> rpm by running `sudo alien -r spotify*.deb`.
* Install rpm `sudo zyppen in spotify*.rpm`.
* Run `spotify`.

And it should work.
I noticed few warning about default locates and no libraries, but client still works fine even without any changes (symlinks, locales and etc).
