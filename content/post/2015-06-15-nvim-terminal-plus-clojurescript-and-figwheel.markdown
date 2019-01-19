---
layout: post
title: "Nvim terminal + ClojureScript and figwheel"
date: "2015-06-15"
comments: true
url: "/blog/2015/06/15/nvim-terminal-plus-clojurescript-and-figwheel/"
categories: [vim, nvim, clojure, clojurescript, figwheel]
---

This is a small post on how to improve your ClojureScript development flow in NeoVim using its terminal feature.

<!--more-->

[NeoVim](https://neovim.io/) nowadays is almost fully compatible with vim.
It is able to reuse my [.vimrc](https://github.com/Gonzih/.vim/blob/master/vimrc) file without any issues.
And recently it got proper terminal emulator built-in.
So how about reusing it for ClojureScript development?

If you are lazy (like I am) and don't want to setup piggieback support
for fireplace.vim or don't feel like tmux integration is good enough
this solution should be your new starting point.

Just open some clojure[script] file and create second split.
Open terminal using `:terminal` command.

Here are some keybindings that will help you to send code from
your clojure buffer to the terminal buffer.

```vim
if has("nvim")
  " Open terminal and run lein figwheel
  nmap <Leader>term <C-w>v:terminal<CR>lein figwheel<CR><C-\><C-n><C-w>p
  " Evaluate anything from the visual mode in the next window
  vmap <buffer> ,e y<C-w>wpi<CR><C-\><C-n><C-w>p
  " Evaluate outer most form
  nmap <buffer> ,e ^v%,e
  " Evaluate buffer"
  nmap <buffer> ,b ggVG,e
endif
```

Hey! Now you can finally stop looking at the emacs land!
