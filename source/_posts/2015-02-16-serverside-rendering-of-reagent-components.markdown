---
layout: post
title: "ServerSide rendering of Reagent components"
date: 2015-02-16 10:12
comments: true
categories: [clojure, clojurescript, reagent]
---

Great thing about React is that you can write what kids nowadays call "isomorphic JavaScript".
In this post we will not discuss how wrong this term is in many ways, but instead we will focus on how to achieve similar results in your ClojureScript code using Reagent library.

<!--more-->

In my experience simplest optimization to run in some js engine on servire side is whitespace.
It does not do any renaming/restructuring of your code but eliminates need to take care of dependencies loading.
So our compiler options should look something like that:

```clojure
{:id "server-side"
 :source-paths ["src"]
 :compiler {:output-to "resources/public/javascripts/server-side.js"
            :output-dir "resources/public/javascripts/out-server-side"
            :preamble ["meta-inf/resources/webjars/react/0.12.1/react-with-addons.min.js"]
            :pretty-print false
            :warnings true
            :optimizations :whitespace}}
```

Next step is to make sure that all functions that use browser specific stuff like document/window are moved in to react lifecycle methods:

```clojure
(def main-component
  (with-meta
    (fn [] ...)
    {:component-did-mount (init-my-scroll-handler!)}))
```

Next let's create function that will do some rendering to string.
I like to keep this function in component specific ns just for convenience.

```clojure
(def ^:export render-me-to-s [initial-state]
  (reset! my-main-state (js->clj initial-state))
  ; Render component to markup without reactid
  (reagent.core/render-to-static-markup [main-component])
  ; Or render component to ready to-go react markup
  (reagent.core/render-to-string [main-component]))
```

Now server side bootstrapping, big part of this code was taken from [react-rails plugin](https://github.com/reactjs/react-rails).

First of all react expects to have global or window objects:

```javascript
var global = global || this;
var self = self || this;
var window = window || this;
var console = global.console || {};
['error', 'log', 'info', 'warn'].forEach(function (fn) {
  if (!(fn in console)) {
    console[fn] = function () {};
  }
});
```

Now let's try and use all this in our code (for now in Ruby):

```ruby
cxt = V8::Context.new
cxt.eval(setup_js)
cxt.load('resources/public/javascripts/server-side.js')
html = cxt.eval("my.amazing_component.ns.render-me-to-s(#{init-state.to_json})")
```

And that's it. As a way to pass data from ruby to clojurescript json works fine.
Sometimes you might want to use ActionController::Bas.helpers.j helper that will
escape your data for usage inside json, but most of the time you should be alright without it.

If you have issues with core.async there are 2 ways to solve it.
I personally prefer to move core.async initialization to some lifecycle method.
Another solution is to stab setTimeout function like that in your setup_js snippet:

```javascript
goog.global.setTimeout = function(cb, t) {
    cb();
}
```

**Useful Links:**

* [ClojureScript mailing list topic](https://groups.google.com/forum/#!topic/clojurescript/IIjUxnl4Zbw)
