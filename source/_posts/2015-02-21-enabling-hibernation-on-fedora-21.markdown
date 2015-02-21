---
layout: post
title: "Enabling hibernation on Fedora 21"
date: 2015-02-21 21:32
comments: true
categories: [linux, powermanagment, fedora]
---

I'm currently running fedora on old mackbook-pro (early 2011 cursed by ATI graphics).

After intstallation of Fedora 21 I noticed that hibernation and suspend do not work.
Suspend is broken because of ATI graphics.
It actually works. You just have black screen on resume.
Hibernate was disabled. It took me quiet some time to figure out how to enable it and make it work.
Tricky part might be due to the fact that it's UEFI based system with LVM and full disk encryption on top of that.

So here is what you need to enable hibernate back:

<!--more-->

1. Enable recovery in `/etc/default/grub`:

```text /etc/default/grub

...
GRUB_DISABLE_RECOVERY="false"
```

2. If you have LVM make sure that disk is activated. You should see something like `rd.lvm.lv=my-lvm-group/swap` in the `GRUB_CMDLINE_LINUX`.
3. Add resume target based on `swapon -s` output to the `GRUB_CMDLINE_LINUX`. Example: `resume=/dev/dm-1`.

Full `/etc/default/grub` file:

```text /etc/default/grub
GRUB_TIMEOUT=5
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL_OUTPUT="console"
GRUB_CMDLINE_LINUX="rd.lvm.lv=fedora_mylaptop/swap rd.luks.uuid=luks-numbers rd.lvm.lv=fedora_mylaptop/root resume=/dev/dm-1 rhgb quiet"
GRUB_DISABLE_RECOVERY="false"
```

4. Generate new grub configuration by running: `sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`
5. Reboot.
6. Enjoy!
