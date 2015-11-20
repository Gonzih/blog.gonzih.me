---
layout: post
title: "Arch Linux on Macbook Pro 8.2 (17\" 2011)"
date: 2015-08-08 09:53
comments: true
categories: [linux, archlinux, macbook]
---

Couple of tips from my experience of running Arch on Macbook 8.2.

<!--more-->

## Installation

<a href="https://wiki.archlinux.org/index.php/MacBook">Arch Wiki page</a> covers installation well enough in my opinion.

## Use broadcom-wl wireless module from AUR

This is proprietary broadcom driver. Works fine with BCM4331.
Only thing that does not work - hidden SSID.

OpenSource driver (that is part of the kernel) and reverse engeneered ones (b43) are too unstable in my experience.

To make sure that correct module is used by hardwrare blacklist every other module and reboot:

```
#/etc/modprobe.d/wl.conf
blacklist b43
blacklist b43legacy
blacklist ssb
blacklist bcm43xx
blacklist brcm80211
blacklist brcmfmac
blacklist brcmsmac
blacklist bcma
```

## Disable Radeon GPU for better power consumption

This will reduce power usage dramatically but also will disable external screen support via display port.
This laptop relies on the external gpu to work with display port.

Edit `/etc/grub.d/00_header` and add outb lines in between `set gfxmode=${GRUB_GFXMODE}` and `load video`:

```
...
set gfxmode=${GRUB_GFXMODE}
outb 0x728 1
outb 0x710 2
outb 0x740 2
outb 0x750 0
load video
...
```

Generate new grub config:

```
# grub-mkconfig -o /boot/grub/grub.cfg
```

PS. This post will probably grow over time.
