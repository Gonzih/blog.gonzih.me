---
layout: post
title: "ln -sf /usr/bin/emacs /usr/bin/vim ?"
date: 2015-02-15 19:21
comments: true
categories: [vim, emacs, clojure]
---

Some time ago I actually did run `ln -sf /usr/bin/emacs /usr/bin/vim`.
And left it like that for a couple of days.
I must say that it was surprisingly nice experience.
Tinkering around with elisp, building editing environment from scratch.

Of course interesting question is "How did I end up with this idea in my head?".

<!--more-->

I tried to play with emacs few times couple of years ago.
But as a modal editing kind of guy I was unable to comprehend finger bending experience that default key bindings in emacs give you.

I tried evil mode, but it went not so well.
Problem is that I'm also using programmer dvorak layout, so I need to remap couple of keys for better comport.
I failed all my previous attempts because it was not very trivial at that time to remap those keys everywhere.
Also probably my lack of patience played against me.
So I gave up and continued using vim (something like 5 years of hapiness).

Recently ClojureScript tool called [figwheel](https://github.com/bhauman/lein-figwheel) added repl support.
So as a result you have repl that compiles your clojure code into javascript and executes result in your browser session printing result back to you.
Development flow like that is very common practice in clojure world and one reason why it makes clojure much better.
Problem here is that it does not support nrepl (network repl) protocol and best tool for clojure in vim [vim-fireplace](https://github.com/tpope/vim-fireplace) relies on nrepl.
I was using for some time [tslime2](https://github.com/sjl/tslime2.vim) in vim to work with ClojureScript.
Idea is very simple - tslime allows you to send pieces of text from your vim into some tmux panel.
It works. You don't have out of the box tooling that will select your top most clojure form sadly.
Once upon a time I had discussion on #clojurescript irc and [@martinklepsh](https://twitter.com/martinklepsch) mentioned that nowadays evil-mode is much better.
I was bored and followed that track. I did run `rm -rf .emacs.d` and started from scratch.
As a result my workflow from vim was ported to emacs in a couple of hours.
It surprised me both how simple was that and how relatively close my setup is to default one in vim/evil.
I set my default editor to emacs and continued doing my thing for a couple of days.

And here what I think so far.

Good:

* Evil mode is good and it's very close. It's probably closest thing to vim that I ever tried.
It's not fancy smart like vim mode in IntelliJ IDEA that actually reads your .vimrc and uses it to configure keybindings
(Big shout outs to the author of idea plugin. It's very impressive.)
* Writing configuration in a language that I understand was a big relieve.
* Mapping configuration is simpler. You are mapping elisp function to the key. It's simpler and easier to understand than remapping mechanism in vim.
* Helm surprised me in it's speed and functionality, I spent lot of time fighting with Ctrl-P/Unite in vim. Configuring Unite was painful experience. Helm on the other hand just works. And works well.
* Inferior lisp is so goooood. Having editor with lisp support in mind is incredible experience for any lisp developer. ([inf-clojure](https://github in inferior lisp mode tuned to play well with clojure)
* It can do async stuff! If you used vim then you know what I mean. In emacs it's just there. Without required pythor/ruby support enabled during compilation.
* Built-in package manager. Just run `package-install` and it's there. No NeoBundle/Bundle installation needed. No need to mess with git submodules.
* Ability to inspect everything at run time helps during configuration. Some key executes something weird? Just run `describe-key` and see what is going on. You can do something similar in vim, but in emacs it's much better.
* Startup time is slow and it's solvable. Just run systemd user service with `emacs --daemon` and that is enough for most cases.
* And you still have emacs operating system at your disposal!
* Configuring emacs from scratch made me realize that my vim configuration is really really messy and big. I need probably to think about some changes in there.

Not so good:

* Paredit feels different from one that exists in vim. Less strict I guess most of the time and too strict when it's unnecessary. Of course this is related only to my habits and muscle memory.
* Evil is slower.
Most of the time it's not a problem. But sometimes I'm mashing my keyboard too fast and mess happens.
Good example is replace (`r`) key.
Press `r:` too fast and you might end up in vim command line.
* Evil is just a plugin. Sometimes you are forced to use default emacs mode in some menus/buffers that don't play well with evil.
* Good example of painful evil integration is cider.
It just does not work with evil mode.
Most configuration examples that I was able to find on github related to cider and evil mode where just forcing default emacs mode in cider repl and related buffers.
That was big disappointment for me. I had high hopes for the cider. I'm realizing that I don't really need everything that cider provides.
I'm very happy with just ability to evaluate code, without even debugger and nice stacktraces.
But cider looked so shiny and cool. And bloated. Seems like author of cider does not use evil mode so my hopes that cider+evil story will improve are low.
After few hours of grinding my teeth over emacs configuration I gave up and decided to rely on [inf-clojure](https://github.com/clojure-emacs/inf-clojure).

Will I continue using emacs? Yes.

Will it be my default editor? Probably no.
Vim feels more reliable because it provides modal editing experience out of the box.
In emacs it an option.
I'm totally fine with giving away all that goodness that emacs provides to have proper editing experience **all the time**.
In every buffer, in every menu.
And I will continue slowly improving my emacs configuration.

This experiment reminded me how many things are missing from my setup.
It also reminded me that [neovim](https://neovim.org) might be next big thing in my tool belt.
I'm really hoping to see big movement around neovim once project becomes more or less compatible with current viml based configurations.

**PS**

* [Here](http://juanjoalvarez.net/es/detail/2014/sep/19/vim-emacsevil-chaotic-migration-guide/) is very good tutorial to get vim users started in emacs.
* My .emacs.d is [here](https://github.com/Gonzih/.emacs.d). I tried to keep it minimalistic.
* My .vim is [here](https://github.com/Gonzih/.vim).
* If you are looking for the best vim like experience in emacs please take a look at the [spacemacs project](https://github.com/syl20bnr/spacemacs).
* Looking for the good color theme in emacs? Take a look at the port of [vim's gruvbox theme](https://github.com/morhetz/gruvbox).
