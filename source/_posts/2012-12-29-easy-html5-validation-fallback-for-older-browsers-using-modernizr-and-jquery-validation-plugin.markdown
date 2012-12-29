---
layout: post
title: "Easy HTML5 Validation Fallback for Older Browsers using Modernizr and JQuery Validation Plugin"
date: 2012-12-29 12:15
comments: true
categories: [web, html5, ie, jquery, validation, coffeescript]
---

So I heard that you hate IE. Also I heard that you love HTML5. Is that true? Great, I feel the same about IE. So here is quick fallback script for html5 validation in older browsers (or crappy ones, like IE).
You will need three things for that.

First is [Modernizr](http://modernizr.com/) javascript library. It allows you to detect which features are supported by your browser and which aren't.

Second is [JQuery](http://jquery.com/). I think you are already familiar with it, so there is no need to tell you why it's awesome and how to use it.

Third is [JQuery Validation Plugin](http://docs.jquery.com/Plugins/Validation). It provides mechanism for form validation based on input classes.

So now only things you need to do is to convert html5 validation attributes to html classes and run validation plugin. Here is small [CoffeeScript](http://coffeescript.org/) snippet:

```coffeescript
# initialize plugin on page ready
$ ->
  unless (Modernizr.input.required)
    $('form').find('input[required]').each ->
      $(this).attr('class', 'required ' + this.getAttribute('type')).removeAttr('required')

    $('form').each ->
      $(this).validate()

# check if form is valid by hand
$('form').valid()
```

And as always, Have a nice day! :)
