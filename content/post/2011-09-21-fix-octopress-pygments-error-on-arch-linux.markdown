---
layout: post
title: "How To Fix Octopress Pygments Error on Arch Linux"
date: "2011-09-21"
comments: true
categories: [ruby, octopress, arch linux, pygments]
---
If your get following pygments error using octopress with arch linux.

```text
Building site: source -> public
  File "<string>", line 1
    import sys; print sys.executable
                        ^
SyntaxError: invalid syntax
```
It's happens because RubyPython use Python version 2 by calling "python" command. By default python equal to python3 in Arch Linux.

For fix simple add ruby file to plugins directory with following code.
<!--more-->

`ruby_python_arch_linux_fix.rb`:
```ruby
RubyPython.configure :python_exe => 'python2.7'
```

Also if you get following lib.so related error:
```text
LoadError: Could not open library 'lib.so': lib.so: cannot open shared object file: No such file or directory
```
You can find solution [here](https://github.com/tmm1/pygments.rb/issues/10).

[via](https://github.com/tmm1/pygments.rb/issues/7#issuecomment-2154024)

### Update
Another Workaround:
edit "vendor/bundle/ruby/1.9.1/gems/rubypython-0.5.3/lib/rubypython/pythonexec.rb" file (path might be different for you)
```ruby
-- 31 @library = find_python_lib
++ 31 @library = "/usr/lib/libpython2.7.so"

-- 126 %x(#{@python} -c "#{command}").chomp if @python
++ 126 %x("#{@python} -c #{command}").chomp if @python
```
