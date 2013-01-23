---
layout: post
title: "ClojureScript on BeagleBone: simple benchmark with Node.js"
date: 2013-01-23 17:16
comments: true
categories: [clojure, clojurescript, node.js, bealbebone]
---
Benchmark is based on my [previous experiments](/blog/2012/09/07/clojure-on-beaglebone-openjdk-vs-oracle-embedded-jre-benchmark/) with BeagleBone and Clojure. Setup is the same. BeagleBone is running Ubuntu 12.04. Cpu is running on 500 Mhz.
Node version is 0.6.12. ClojureScript is compiled with advanced and simple optimizations.
<!-- more -->

[Code](https://github.com/Gonzih/clojurescript-small-benchmark-for-embed) is modified to run on top of the JavaScript:
```clojure
(ns benchmark.core)

(defn factorial [x]
  (reduce * (range 1 (inc x))))

(defn fib [n]
  (if (<= n 1)
    1
    (+ (fib (- n 1)) (fib (- n 2)))))

(defn sort-seq []
  (sort (repeat 100000 (rand-int 2000000))))

(defn time-fun [fun] 
  (let [start  (.getTime (js/Date.))
        _      (fun)
        end    (.getTime (js/Date.))
        result (- end start)]
    result))

(defn time-it [fun]
  (let [values  (for [i (range 200)] (time-fun fun))]
    (/ (apply + values)
       (count values))))

(defn -main []
  (println "(factorial 5000) \t Avg: " (time-it #(factorial 5000)))
  (println "(fib 20) \t Avg: "         (time-it #(fib 20)))
  (println "(sort-seq) \t Avg: "       (time-it #(sort-seq))))

(set! *main-cli-fn* -main)
```

Benchmark results:

```
> node --version
v0.6.12

# advanced compiler optimization
> ps eu
%CPU %MEM VSZ    RSS   TTY    STAT START  TIME COMMAND
99.0 20.9 92200  52776 pts/0  Rl+  07:14  0:44 node clojurescript-benchmark-optimization-advanced.js

> node clojurescript-benchmark-optimization-advanced.js
(factorial 5000) Avg: 64.345
(fib 20)         Avg: 5.575
(sort-seq)       Avg: 7281.975

# simple compiler optimization
> ps eu
%CPU %MEM VSZ    RSS   TTY    STAT START  TIME COMMAND
99.0 20.9 92200  52776 pts/0  Rl+  07:14  0:44 node clojurescript-benchmark-optimization-advanced.js

> node clojurescript-benchmark-optimization-advanced.js
(factorial 5000) Avg: 54.775
(fib 20)         Avg: 2.77
(sort-seq)       Avg: 6325.71
```

So as you can see from output above - ClojureScript can be well suitable for development and scripting on small boards like BeagleBone or Raspberry Pi.
Good speed and better semantics at low prices, I ♥ Clojure and ClojureScript :)
