---
layout: post
title: "Two way data bindings in Reagent"
date: 2014-10-22 17:29
comments: true
categories: [clojure, clojurescript, core.async, react.js, reagent]
---
Small code snippet showing ability to generate 2 way data bindings in Reagent.
Underneath it's all about core.async.
Also provides ability to apply transformation using transducers.

```clojure

(defonce form (atom {}))

(defn bind-input
  "Generat on-change callback,
   bind value to form-key of form-atom.
   Provides ability to implement transformation using transducers."
  [form-atom form-key xform]
  (let [local-chan (chan 1 xform)]
    (go-loop []
      (swap! form-atom assoc form-key (<! local-chan))
      (recur))
    (fn [event]
      (put! local-chan
            (.-value (.-target event))))))

(defn bound-input
  "Generate input,
   create two way data binding
   between input value and value under form-key in form-atom.
   Provides ability to implement transformation using transducers."
  [attrs form-atom form-key xform]
  [:input (merge attrs
                 {:value (form-key @form-atom)
                  :on-change (bind-input form-atom form-key xform)})])

(defn main-component []
  [:div
   [:h3 (:name @form) " value"]
   [bound-input {:type :text} form :name (filter #(> 15 (count %)))]])

(reagent/render-component [main-component]
                          (js/document.getElementById "content"))
```
