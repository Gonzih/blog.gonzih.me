---
layout: post
title: "ServerSide rendering of Reagent components"
date: 2015-02-16 10:12
comments: true
categories: [clojure, clojurescript, reagent]
---

Great thing about React is that you can write what people nowadays call "isomorphic JavaScript".
In this post we will not discuss how wrong this term is in many ways,
but instead we will focus on how to achieve similar results in your ClojureScript code using Reagent library.

<!--more-->

In my experience simplest optimization to run in some js engine on server side is whitespace.
It does not do any renaming/restructuring of your code but eliminates need to take care of dependencies loading.
So our compiler configuration should look something like that:

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
    {:component-did-mount (comp init-my-scroll-handler!
                                also-init-my-go-loop!)}))
```

Next let's create function that will do some rendering to the string.
I like to keep this function in a component specific ns just for convenience.

```clojure
(def ^:export render-me-to-s [initial-state]
  (reset! my-main-state (js->clj initial-state))
  ; Render component to markup without reactid
  (reagent.core/render-to-static-markup [main-component])
  ; Or render component to ready to-go react markup
  (reagent.core/render-to-string [main-component]))
```

Now server side bootstrapping, most of this code was taken from [react-rails plugin](https://github.com/reactjs/react-rails).

First of all react expects to have global or window objects in your js engine:

```javascript setup.js
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
cxt.load('setup.js')
cxt.load('resources/public/javascripts/server-side.js')
html = cxt.eval("my.amazing_component.ns.render_me_to_s(#{init_state.to_json})")
```

And that's it. As a way to pass data from ruby to clojurescript json works fine.
Sometimes you might want to use `ActionController::Base.helpers.j` helper that will
escape your data for usage inside json, but most of the time you should be alright without it.

If you have issues with core.async there are 2 ways to solve it.
I personally prefer to move core.async initialization into some lifecycle method.
Another solution is to implement setTimeout function like that in your `setup.js` snippet:

```javascript
goog.global.setTimeout = function(cb, t) {
    cb();
}
```

Now frontend part. First let's in-line generated html in to the container:

```erb
<div id="content"><%= html %></div>
```

Then let's write function that will render our component on frontend:

```clojure
(def ^:export mount-me [initial-state]
  (reset! my-main-state (js->clj initial-state))
  (reagent.core/render [main-component]
                       (js/document.getElementById "content")))
```

As far as I understand react should reuse your markup on frontend and just attach new handlers to it.
Am I wrong on this one? Don't know yet.

Inline javascript that you should use on frontend looks like that:

```erb
<script>
my.amazing_component.ns.mount_me(<%= init_state.to_json %>)
</script>
```

### Nashorn example (result of my experiments in the REPL)

```clojure
(import '[javax.script ScriptEngineManager])
(def nashorn (.getEngineByName (ScriptEngineManager.) "nashorn"))

; Same as in ruby version
(def setup-script (slurp "setup.js"))
(def ss-script (slurp "resources/public/javascripts/server-side.js"))
(def render-script (str "my.amazing_component.ns.render_me_to_s(" my-state-json-string ");"))

(.eval nashorn setup-script)
(.eval nashorn ss-script)
(.eval nashorn render-script) ; our html markup
```

I must admit that this example works on small reagent example.
I'm unable to load production code from my current project in to Nashorn.

Also it helps a lot if you started developing your project with server side rendering in mind.

Of course it's better to have some kind of "renderers pool" in JVM.
Good thing that clojure allows you to implement thing like that in few lines of code.
In ruby it's not a problem since we have 1 context per worker.

**Useful Links:**

* [ClojureScript mailing list topic](https://groups.google.com/forum/#!topic/clojurescript/IIjUxnl4Zbw)
