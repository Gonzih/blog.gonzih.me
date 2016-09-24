---
layout: post
title: "Programmer Dvorak and switching workspaces in XMonad"
date: "2012-10-08"
comments: true
categories: [haskell, xmonad, wm, linux]
---
Recently I migarted from awesome to xmonad. I'm Programmer Dvorak freak, so I stuck with controlling current workspace from numbers row.
<!--more-->

First hack was to use functional keys [F1..F12] like so:

```haskell
    -- mod-[F1..F12]       Switch to workspace N
    -- mod-shift-[F1..F12] Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_F1 .. xK_F12]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

```


But after some research I found that I can detect key symbol using xev command. Here is my latest solution:

```haskell
    -- Programmer Dvorak
    -- mod-[1..9]       Switch to workspace N
    -- mod-shift-[1..9] Move client to workspace N
    --
    [((m .|. modm, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_ampersand, xK_bracketleft, xK_braceleft, xK_braceright, xK_parenleft
                                                 ,xK_equal, xK_asterisk, xK_parenright, xK_plus, xK_bracketright, xK_exclam]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]

```

Hooray! It works!
