---
layout: post
title: "Arch Linux on Lenovo IdeaPad Y700 15\""
date: 2015-12-11 13:20
comments: true
categories: [arch, linux, lenovo, laptop]
---

Collection of tweaks that I gathered after installing Arch Linux on to Lenovo IdeaPAd Y700.

<!-- more -->

# What works so far
* WIFI
* Suspend (look at the bumblebee issue with suspend if nvidia module gets loaded on resume)
* Sound without subwoofer
* Video (I used bumblebee to switch between intel/nvidia GPUs)
* Brightness
* Keyboard backlit
* Powermanagment via laptop mode tools and systemd.
* Card reader

# What does not work
* Subwoofer

# Not tested yet
* HDMI output

# Installation

## Boot
* Add nomodeset to the kernel options on Live USB boot
* Make sure secure boot is disabled (to make your life easier)
* Follow [arch linux installation instructions](https://wiki.archlinux.org/index.php/Installation_guide)

# Extra tweaking

## Video

* Make sure switchable GPUs are enabled in BIOS
* Follow [insructions on the arch wiki](https://wiki.archlinux.org/index.php/Bumblebee#Installing_Bumblebee_with_Intel.2FNVIDIA)
* To enable intel GPU add `i915.preliminary_hw_support=1` to `GRUB_CMDLINE_LINUX_DEFAULT` in the `/etc/default/grub` file. This should be solved after 4.3 kernel release.
* Problems with video scaling in fullscreen mode can be solved by using gl as an output driver (mplayer -vo gl).

## Wifi

Since there is no HW based wifi switch (only Fn+F5 combination) and kernel still tries to read it wifi is reported disabled on every boot.
There was a patch for the 17 inch model [here](http://www.gossamer-threads.com/lists/linux/kernel/2323659).

### Temporary solution:

* `sudo systemctl enable rfkill-unblock@wifi.service`
* `sudo rfkill unblock wifi`
* Works fine with `wicd`
* Configuring networkmanager service to be run antefr rfkill service should also work

## Audio clicking

This is caused by suspend-on-idle module in the pulse audio. Instead of disabling the module I decided to just set very long timeout.
To do that append `timeout=36000` to line `load-module module-suspend-on-idle` in the `/etc/pulse/default.pa` config file.
And now restart pulse by running `pulseaudio -k` and `pulseaudio -D`.
