---
layout: post
title: "Tmux + Rvm + Zsh Fix"
date: 2011-09-15 14:52
comments: true
categories: [tmux, zsh, rvm, ruby, terminal]
---

If you have throuble with tmux and rvm default simple add following to end of your .zshrc file.
``` bash
[[ $TERM = "screen" ]] && rvm use default
```
