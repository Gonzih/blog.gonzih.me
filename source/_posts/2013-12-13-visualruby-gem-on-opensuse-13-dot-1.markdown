---
layout: post
title: "VisualRuby gem on OpenSUSE 13.1"
date: 2013-12-13 10:10
comments: true
categories: [ruby, gkt, opensuse]
---
![visualruby](https://dl.dropboxusercontent.com/u/4109351/octopress/visualruby/1.jpg)

I found out about ruby gem called [visualruby](http://visualruby.net/) and decided to give it a try. Unfortunately it has a lot of dependencies that were missing on my system.
So to save my (or maybe your's if you are reading this now) time in the future here are required dependencies for OpenSUSE 13.1.
I bet you can figure out similar packages for different distribution.

<!-- more -->

```sh
sudo zypper -n in glib2 glib2-branding-openSUSE glib2-devel atk-devel cairo-devel pango-devel gdk-pixbuf-devel gtk2-devel gtksourceview2-devel glade
```

Adjust glade command in settings to glade from glade-gtk2. And now you can run it! :)
It's not working very well (at least in examples) since most of stuff in suse 13.1 is based on gtk3+.
But I'm still in process of figuring things out.
