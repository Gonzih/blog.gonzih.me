---
layout: post
title: "Yin-Yang Call/cc puzzle in Ruby"
date: 2013-11-26 11:23
comments: true
categories: [ruby, call/cc, scheme]
---
Digging deeper in to the call/cc land I found interesting puzzle called yin-yang.

Here is Scheme implementation:

```scheme
(let* ((yin
        ((lambda (cc) (display #\@) cc) (call-with-current-continuation (lambda (c) c))))
       (yang
        ((lambda (cc) (display #\*) cc) (call-with-current-continuation (lambda (c) c)))))
(yin yang))
```

It will print `@*@**@***@****@*****@******@...` forever.

<!-- more -->

[Here](http://yinwang0.wordpress.com/2012/07/27/yin-yang-puzzle/) you can find good explanation,
also few of explanations can be found on [StackOverflow](http://stackoverflow.com/questions/2694679/how-does-the-yin-yang-puzzle-work).

After I understand how it works I got all that excited and implemented given puzzle in ruby:

```ruby
require "continuation"

yin  = ->(cc) { print "@"; cc }.call(callcc { |c| c })
yang = ->(cc) { print "*"; cc }.call(callcc { |c| c })

yin.call(yang)
```

And it doesn't work. It prints `@*@*********...` forever.

No idea why. Maybe there are some limitations of [ruby's call/cc](http://www.ruby-doc.org/core-2.0.0/Continuation.html).
I will research further, but if you have any information about that feel free to comment or email me.

Cheers!

**UPDATE** Abinoam Praxedes Marques Junio [figured](https://www.ruby-forum.com/topic/4418860#1129811) out that let (which is basically lambda application underneath) is crucial here.
So here is his fixed version:

```ruby
require "continuation"

lambda do |yin, yang|
  yin.call(yang)
end.call(lambda { |cc| print "@"; cc }.call(callcc { |c| c }),
         lambda { |cc| print "*"; cc }.call(callcc { |c| c }))
```
