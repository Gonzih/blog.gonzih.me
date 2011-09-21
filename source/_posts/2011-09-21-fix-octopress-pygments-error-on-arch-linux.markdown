---
layout: post
title: "How To Fix Octopress Pygments Error on Arch Linux"
date: 2011-09-21 18:28
comments: true
categories: [ruby, octopress, arch linux, pygments]
---
If your get following pygments error using octopress with arch linux.
```
Building site: source -> public
  File "<string>", line 1
    import sys; print sys.executable
                        ^
SyntaxError: invalid syntax
```
It's happens because RubyPython use Puthon version 2 by calling "python" command. By default python equal to python3 in Arch Linux.

For fix simple add ruby file to plugins directory with next code.
``` ruby ruby_python_arch_linux_fix.rb
RubyPython.configure :python_exe => 'python2.7'
```

[via](https://github.com/tmm1/pygments.rb/issues/7#issuecomment-2154024)
