---
layout: post
title: "Clojure on BeagleBone: OpenJDK vs Oracle Embedded JRE benchmark"
date: 2012-09-07 16:20
comments: true
categories: [clojure, java, jre, bealbebone, ejre, openjdk]
---
After installing Embedded JRE on BeagleBone I decided to benchmark it against OpenJDK.

BeagleBone is running Ubuntu 12.04.
```
> cat /etc/*-release
DISTRIB_ID=Ubuntu
DISTRIB_RELEASE=12.04
DISTRIB_CODENAME=precise
DISTRIB_DESCRIPTION="Ubuntu 12.04 LTS"
```

BeagleBone CPU is running on 500Mhz.
```
> cpufreq-info | grep 'current CPU'
current CPU frequency is 500 MHz.
```

Clojure version is 1.4.0.

Benchmark code is from [nakkaya's post](http://nakkaya.com/2011/03/15/clojure-on-the-beagleboard/):
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

So here are numbers:

OpenJDK:
```
> sudo apt-get install openjdk-7-jre-headless

> java -version
java version "1.7.0_03"
OpenJDK Runtime Environment (IcedTea7 2.1.1pre) (7~u3-2.1.1~pre1-1ubuntu3)
OpenJDK Zero VM (build 22.0-b10, mixed mode)

> ps -eu
%CPU %MEM VSZ    RSS   TTY    STAT START  TIME COMMAND
96.9 16.3 267932 41172 pts/1    Sl+  09:07   9:28 java

> lein run
(factorial 5000) Avg:  1681.9940255249999
(fib 20)         Avg:  490.16940197000025
(sort-seq)       Avg:  7129.159457125003
```

Embedded JRE:
```
> java -version
java version "1.7.0_06"
Java(TM) SE Embedded Runtime Environment (build 1.7.0_06-b24, headless)
Java HotSpot(TM) Embedded Client VM (build 23.2-b09, mixed mode)

> ps -eu
%CPU %MEM VSZ    RSS   TTY    STAT START  TIME COMMAND
91.2 16.4 221740 41372 pts/1  Sl+  08:28  5:16 java

> lein run
(factorial 5000) Avg:  1061.0568413899998
(fib 20)         Avg:  30.877820054999983
(sort-seq)       Avg:  1729.9035516600002
```

Here you are. Better performance and memory usage.
Good Job, Embedded Java Team :)
Looking forward for hardfloat ABI version to test it on Raspberry Pi.
