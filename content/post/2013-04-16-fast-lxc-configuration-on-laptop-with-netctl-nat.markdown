---
layout: post
title: "Quick LXC configuration with netctl nat"
date: "2013-04-16"
comments: true
categories: [linux containers, netctl, nat, ubuntu, arch linux]
---

So I spend few hours playing with Linux Containers. Pretty interesting stuff. So here is small tutorial on how to create and use container on Arch Linux as host machine.

<!--more-->

Install `lxc` first.
```sh
sudo pacman -S lxc
```

Next is bridge device for nat. I'm already migrated to netctl in arch linux so my configuration is for netctl.
`/etc/netctl/lxcbridge`:
```ini
Description="LXC Bridge connection"
Interface=lxcbr0
Connection=bridge
BindsToInterfaces=()
IP=static
Address=192.168.100.1/24
FwdDelay=0
```

Make sure you have `dnsmasq` installed.
```sh
pacman -S dnsmasq
```

Run interface.
```sh
sudo netctl start lxcbridge
```

And enable it for startup
```sh
sudo netctl enable lxcbridge
```

Add iptables rule:
```sh
sudo iptables -t nat -A POSTROUTING -o <you-main-ethernet-device-here> -j MASQUERADE
```

Save iptables (as superuser):
```sh
iptables-save > /etc/iptables/iptables.rules
```

Enable ip_forward:
```sh
sudo sysctl net.ipv4.ip_forward=1
```
Or to save forwarding persisent add following line:
`/etc/sysctl.conf`:
```text
net.ipv4.ip_forward=1
```

Create new Ubuntu container:
```sh
sudo lxc-create -n playtime -t ubuntu
```

It will create new root filesystem with new configuration. Lets now change conatiner's configuration:
`/var/lib/lxc/playtime/config`:
```ini
lxc.network.type = veth
lxc.network.flags = up
lxc.network.link = lxcbr0
lxc.network.hwaddr = 00:FF:AA:00:00:01
lxc.network.ipv4 = 192.168.100.10/24
```

Lets boot our conatiner. Better use screen or tmux for it.
```sh
sudo lxc-start -n playtime
```

Default user and password for ubuntu template is `ubuntu`.

Login to container and add default gateway configuration on network up:
`/etc/network/if-up.d/routes`:
```sh
#! /bin/sh

route add default gw 192.168.100.1

exit 0
```

Reboot container with `sudo reboot` in it.

Now you can ssh to your container `ssh ubuntu@192.168.100.10`.
You can also run container as daemon `sudo lxc-start -n playtime -d`.
And you can shutdown container with `sudo shutdown` inside container.

Thanks for reading. Let me know if I miss something or you know better way of configuring all this stuff.
