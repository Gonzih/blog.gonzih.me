---
layout: post
title: "Autoconnect to NetworkManager VPN on systemd based system"
date: "2014-05-26"
comments: true
categories: [linux, vpn, privacy]
---

Here is small post with instructions how to setup auto connect to VPN.
Of course you can probably figure out all this yourself, but what if you are lazy?

<!--more-->

Following was tested on OpenSuse 13.1.

* First create new VPN connection in NetworkManager.

* Create dispatcher file that will connect your VPN.

`/etc/NetworkManager/dispatcher.d/vpn-up`:
```text
#!/bin/sh

CONN="MY-CONNECTION-NAME"

nmcli con status id $CONN > /dev/null

rc=$?
if [[ $rc != 0 ]] ; then
    nmcli con up id $CONN
    sleep 5 # optional wait time
fi

```

* Make file executable `chmod +x /etc/NetworkManager/dispatcher.d/vpn-up`
* Make sure that dispatcher is running by running `journalctl -b -u NetworkManager` and looking for the line that looks like:

`NetworkManager`:
```text journalctl -b -u
<warn> Dispatcher failed: (32) Unit dbus-org.freedesktop.nm-dispatcher.service failed to load: No such file or directory.
```

* If you see line about dispatcher service - enable it manually by running `systemctl enable NetworkManager-dispatcher.service`.
* By default NetworkManager will store VPN password in keyring, to start VPN without keyring dependencies update VPN connection configuration with following changes:

`/etc/NetworkManager/system-connections/MY-CONNECTION-NAME`:
```text
...
[vpn]
password-flags=0
...
[vpn-secrets]
password=MY-VPN-PASSWORD

```

And now everything should work like a charm!
