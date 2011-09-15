---
layout: post
title: "Tmux + Rvm + Zsh Fix"
date: 2011-09-15 14:52
comments: true
categories: [tmux, zsh, rvm, ruby, terminal]
---

If your have throuble with tmux and rvm default simple add "[[ $TERM = "screen" ]] && rvm use default" to end of your .zshrc file.
