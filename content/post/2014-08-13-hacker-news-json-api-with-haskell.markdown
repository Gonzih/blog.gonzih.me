---
layout: post
title: "Building Hacker News json api with Haskell"
date: "2014-08-13"
comments: true
categories: [haskell, hxt, scotty, heroku, hn]
---
Small announcement post.

Today I launched tiny scotty server that serves json for Hacker News front page.
Project source code is located on [github](https://github.com/Gonzih/HNApi).
You can access api [here](http://hn.gonzih.me/).

Hacker news parser is implemented using [HXT](http://hackage.haskell.org/package/hxt-8.5.2)
and [HandsomeSoup](http://egonschiele.github.io/HandsomeSoup/).
Json is served with help of [Scotty](https://github.com/scotty-web/scotty/) web framework.
Currently it's running on Heroku using [this ghc-7.8 buildpack](https://github.com/begriffs/heroku-buildpack-ghc).

I don't use RSS since I'm also interested in points and amount of comments.
For me HN is more about interesting links than community and conversations behind the posts.
So I don't really care about anything except front page.

Originally I started this project as a Haskell learning exercise.
I hope someone will find it useful.
<!--more-->
