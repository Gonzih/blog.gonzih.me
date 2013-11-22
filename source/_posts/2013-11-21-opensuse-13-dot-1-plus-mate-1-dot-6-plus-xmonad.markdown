---
layout: post
title: "OpenSUSE 13.1 + Mate 1.6 + Xmonad"
date: 2013-11-21 22:46
comments: true
categories: [linux, mate, xmonad, opensuse]
---
So OpenSUSE 13.1 was released. And it's great. But...
Since gnome 3.9 support for custom window managers was broken.
How to restore sanity to your desktop? Mate it! Here is quick how to.

[![preview](https://dl.dropbox.com/u/4109351/octopress/suse-mate-xmonad/re_1.png)](https://dl.dropbox.com/u/4109351/octopress/suse-mate-xmonad/1.png)

<!-- more -->

Patterns for installing mate in OpenSUSE can be found here [http://en.opensuse.org/Portal:MATE](http://en.opensuse.org/Portal:MATE)

Xmonad can be installed using cabal install or using packages from OBS.

```sh
cabal install xmonad         --flags="with_utf8 with_xft"
cabal install xmonad-contrib --flags="with_utf8 with_xft"
cabal install xmobar         --flags="with_utf8 with_xft"
```

Create following file:

```text /usr/share/applications/xmonad.desktop
[Desktop Entry]
Type=Application
Name=Xmonad
# Replace it with your xmonad launcher
Exec=xmonad
NoDisplay=true
Terminal=false
StartupNotify=false
Categories=
```

Set xmonad as window manager for Mate:

```sh
# Mate 1.4
mateconftool-2 -s /desktop/mate/session/required_components/windowmanager xmonad --type string

# Mate 1.6
gsettings set org.mate.session.required-components windowmanager xmonad
```

If you have Gnome 3 installed make sure that gnome-settings daemon is not running in mate (can cause gsettings error).

Enjoy!

Btw I have some weird issues with gnome 3 apps rendering, no idea how to fix this for now.
Also `caja -n` which is responsible for displaying icons on desktop loves to hide my xmobar. Killing it helps.

If you have any tips feel free to comment!

**UPDATE** issues with rendering was caused by `setWMName "LG3D"` in `startupHook`. Removed it for now (probably will cause issues with some Java(AWT) applications).
