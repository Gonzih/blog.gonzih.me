---
layout: post
title: "Clojure on Raspberry Pi: OpenJDK vs Oracle JRE (Java 8 armhf beta) benchmark"
date: 2013-04-14 12:00
comments: true
categories: [clojure, java, jre, raspberry pi, openjdk, java 8, armhf]
---
[Here](http://jdk8.java.net/fxarmpreview/) you can download latest Java 8 preview for armhf. Lets benchmark it on Raspberry Pi!
<!-- more -->
Pi is running Raspbian.
```
> cat /etc/*-release
PRETTY_NAME="Debian GNU/Linux 7.0 (wheezy)"
NAME="Debian GNU/Linux"
VERSION_ID="7.0"
VERSION="7.0 (wheezy)"
```

Pi CPU is running on 700Mhz.
```
> cpufreq-info | grep 'current CPU'
current CPU frequency is 700 MHz.
```

Clojure version is 1.5.1.

Benchmark code is from [nakkaya's post](http://nakkaya.com/2011/03/15/clojure-on-the-beagleboard/), also used for my BeagleBone Clojure/ClojureScript benchmarks:
```clojure
(ns benchmark.core)

(defn factorial [x]
  (reduce * (range 1N (inc x))))
;                   ^ integerOverflow fix

(defn fib [n]
  (if (<= n 1)
    1
    (+ (fib (- n 1)) (fib (- n 2)))))

(defn sort-seq []
  (sort (repeat 100000 (rand-int 2000000))))

(defn time-it [fn]
  (let [values  (for [i (range 200)] (with-out-str (time (fn))))
        doubles (map #(Double. (nth (.split % " ") 2)) values)]
    (/ (apply + doubles) (count doubles))))

(defn -main []
  (println "(factorial 5000) \t Avg: " (time-it #(factorial 5000)))
  (println "(fib 20) \t Avg: " (time-it #(fib 20)))
  (println "(sort-seq) \t Avg: " (time-it #(sort-seq))))
```

This time I was a little bit smarter to run all code with `lein trampoline run` to eliminate overhead.

Numbers:

OpenJDK:
```
> sudo apt-get install openjdk-7-jre-headless

> java -version
java version "1.7.0_07"
OpenJDK Runtime Environment (IcedTea7 2.3.2) (7u7-2.3.2a-1+rpi1)
OpenJDK Zero VM (build 22.0-b10, mixed mode)

> ps eu
%CPU %MEM
90.5 15.7

> lein trampoline run
(factorial 5000) Avg: 5956.007845080006
(fib 20)         Avg: 713.6807171
(sort-seq)       Avg: 9633.873322030007
```

Oracle JRE:
```
> java -version
java version "1.8.0-ea"
Java(TM) SE Runtime Environment (build 1.8.0-ea-b36e)
Java HotSpot(TM) Client VM (build 25.0-b04, mixed mode)

> ps eu
%CPU %MEM
87.9 18.9

> lein trampoline run
(factorial 5000) Avg: 685.5312071299996
(fib 20)         Avg: 29.505588125000017
(sort-seq)       Avg: 1137.3281607850001
```

Startup time for "Hello, World!":
```
# OpenJDK
> time lein run
Hello, World!
lein run  56.51s user 1.58s system 87% cpu 1:06.16 total
> time lein trampoline run
Hello, World!
lein trampoline run  57.73s user 0.96s system 96% cpu 1:00.57 total

# Oracle JRE
> time lein run
Hello, World!
lein run  31.47s user 1.43s system 95% cpu 34.298 total
> time lein trampoline run
Hello, World!
lein trampoline run  32.11s user 1.18s system 94% cpu 35.070 total
```

Looks promising for clojure on small arm devices :)
