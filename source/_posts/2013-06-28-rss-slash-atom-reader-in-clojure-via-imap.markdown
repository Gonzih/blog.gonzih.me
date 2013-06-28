---
layout: post
title: "RSS/Atom reader in Clojure via IMAP"
date: 2013-06-28 10:15
comments: true
categories: [clojure, rss, atom, racket, google, ruby]
---
### Motivation
Google Reader was shut down and I started looking for alternatives.
And sadly I did not found anything close to Google Reader experience.
There are plenty good alternatives, but all of them suffer from some kind of background noise (social based features, weird hotkeys, weird ui, unusable mobile clients and etc.).
All I wanted was simple to use news reader.

<!-- more -->

### Idea
Then I found post in the Racket community about storing your feeds in the IMAP folders using "APPEND" command by [Greg Hendershott](http://www.greghendershott.com/2013/05/feeds2gmail.html).
That was it. Simplest possible solution, that I can run on small device or server by cron. I played a little bit with Racket source code and decided to write my own version to do the job.

### Clojure version
First I implemented my [prototype in Ruby](https://github.com/Gonzih/feeds2imap.rb) in few hours. I picked up Ruby because of built-in rss/atom and imap libraries.
I used it for few days and liked it. Simple, reliable solution.
So then I decided to rewrite it in Clojure.
Why Clojure?
Because it's pure fun to use.
I decided to use java.mail framework for message storing and folder manipulations, feedparser-clj to fetch and parse rss/atom feeds and hiccup for templating.
I was really pleased with feedparser-clj in comparison with Ruby built-in library.
java.mail framework was not so bad as I was expecting at first.

### How it works?
Here is project logic:

* Fetch folders and urls from feeds file.
* Fetch and parse RSS/Atom data from urls.
* Select only new items using cache file.
* Create required imap folders.
* Store new items as email messages.
* Mark items as read (put md5 hashes in to the clj file with set of old hashes).

It's running now by cron (every hour) on my BeagleBone (using latest ejre version).

Source code is hosted on github [here](https://github.com/Gonzih/feeds2imap.clj). Take a look at project README for usage.

### More implementations

* [My Ruby prototype](https://github.com/Gonzih/feeds2imap.rb)
* [My Clojure implementation](https://github.com/Gonzih/feeds2imap.clj)
* [Racket implementation](https://github.com/greghendershott/feeds2gmail)
* [Haskell implementation](https://github.com/cordawyn/rss2imap)
