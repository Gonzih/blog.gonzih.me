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

* Enable recovery in `/etc/default/grub`:

```text /etc/default/grub

...
GRUB_DISABLE_RECOVERY="false"
```

* If you have LVM make sure that disk is activated. You should see something like `rd.lvm.lv=my-lvm-group/swap` in the `GRUB_CMDLINE_LINUX`.
* Add resume target based on `swapon -s` output to the `GRUB_CMDLINE_LINUX`. Example: `resume=/dev/dm-1`.

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

* Generate new grub configuration by running: `sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg`

* Make sure that hibernate method is set to shutdown:

```text /etc/pm/config.d/defaults
HIBERNATE_MODE="shutdown"
```

* Reboot.
* Enjoy!

**PS** For me sometimes hibernate recovery fails due to error that looks like that:

```text
kernel: PM: 0x87534000 in e820 nosave region: [mem 0x87534000-0x87534fff]
kernel: PM: Read 3221640 kbytes in 0.19 seconds (16956.00 MB/s)
kernel: PM: Error -14 resuming
kernel: PM: Failed to load hibernation image, recovering.
```

No idea why, seems to be related to the apple EFI.
If you have any information on that then please share it in the comments section!
