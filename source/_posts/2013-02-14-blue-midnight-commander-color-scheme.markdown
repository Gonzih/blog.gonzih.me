---
layout: post
title: "Blue Midnight Commander color scheme"
date: 2013-02-14 21:22
comments: true
categories: [mc, linux, color, terminal]
---
I spend today few hours reading mc documentation about color scheme configuration. Came up with following color scheme. Enjoy :)

[![Blue Midnight Commander color scheme](https://dl.dropbox.com/u/4109351/octopress/midnight-commander-theme/theme.png)](https://raw.github.com/Gonzih/dotfiles/a43c06d7cd12f3e1e06f3efe655e082e4dc78012/.config/mc/theme.png)


```ini .config/mc/ini
[Colors]
base_color=lightgray,blue:normal=blue,default:reverse=green,default:gauge=gray,lightgray:selected=white,blue:marked=yellow,default:markselect=yellow,default:directory=brightblue,default:executable=brightgreen,default:link=cyan,default:device=brightmagenta,default:core=red,default:special=lightgray,default:dnormal=lightgray,blue:dfocus=lightgray,black:dhotnormal=yellow,blue:dhotfocus=yellow,black:menunormal=lightgray,blue:menuhot=yellow,blue:menusel=lightgray,black:menuhotsel=yellow,black:menuinactive=lightgray,gray:errors=lightgray,red:errdhotnormal=yellow,red:errdhotfocus=yellow,lightgray:input=lightblue,gray:inputunchanged=blue,gray:inputmark=white,blue:bbarhotkey=white,black:bbarbutton=lightgray,blue:viewbold=lightgray,default:viewunderline=lightblue,default:viewselected=lightgray,grey:helpnormal=lightgray,default:helpitalic=lightblue,default:helpbold=lightgray,default:helplink=green,default:helpslink=lighgreen,defalt:
```

For more information take look at [mc wiki](http://www.midnight-commander.org/wiki/doc/common/skins) and run `mc --help-color` to see available color variables in your mc version.
Format of color configuration is `what=foreground,background:`. All configuration shoud be in one line (ofcourse you can write it in multiple lines and then use vim (or other cool editor) magic).
