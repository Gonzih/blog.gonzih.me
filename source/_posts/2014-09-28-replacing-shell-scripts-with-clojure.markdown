---
layout: post
title: "Replacing shell scripts with Clojure+JamVM"
date: 2014-09-28 11:04
comments: true
categories: [clojure, jvm, jamvm, linux]
---
We all hate shell scripting.
Scripts are annoyingly hard to debug, test and verify.
Would be lovely, to use some kind of lisp for scripting, right?
To do interactive development with repl in your favorite editor.
To write it in a nice predictable language that you also enjoy.
But sometimes it's impossible to add some external dependencies to the system.
What if you have only JVM to your disposal, will you be able to pull it off only with JVM and clojure.jar?

<!--more-->

# Basic setup

First what we will need is to get clojure jar file:

```
wget -O /opt/clojure.jar 'http://central.maven.org/maven2/org/clojure/clojure/1.6.0/clojure-1.6.0.jar'
```

Next lets create executable that will live in `/usr/bin` (or `/opt/bin` or `/home/youruser/bin`):

```bash /usr/bin/clojure
#!/bin/bash

java -jar /opt/clojure.jar $@
```

And now it's time for our hello world script:

```clojure /opt/test.clj
#!/usr/bin/clojure

(println "hello world")
```

Make it executable:

```bash
chmod +x /opt/test.clj
```

And run it:

```bash
$ /opt/test.clj
hello world
```

Yay! But it feels kind of slow:

```bash
time /opt/test.clj
hello world

real  0m2.684s
user  0m2.239s
sys   0m0.186s
```

2 seconds startup time, not really suitable for scripting, right?
Can we improve that? What if there would be JVM with fast startup and low memory usage.

# Introducing JamVM.

*"But but you told us that there is only JVM available on production system without ability to add external dependencies."*

I lied, sorry.

Compiling JamVM with OpenJDK support:

```bash
# Fetching required dependencies and source
apt-get -y install openjdk-7-jdk openjdk-7-jre build-essential zlib1g-dev
cd /opt
wget -O jamvm-2.0.0.tar.gz 'http://downloads.sourceforge.net/project/jamvm/jamvm/JamVM%202.0.0/jamvm-2.0.0.tar.gz'
tar -xvzf jamvm-2.0.0.tar.gz

# Building
cd /opt/jamvm-2.0.0
./configure --with-java-runtime-library=openjdk7 && make check && make && make install

# Installing in to the openjdk installation
mkdir /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/jamvm
cp /usr/local/jamvm/lib/libjvm.so /usr/lib/jvm/java-7-openjdk-amd64/jre/lib/amd64/jamvm/libjvm.so

# Trying it out
java -jamvm -version
```

JamVM will be installed as separate vm in openjdk, so it will not mess with existing installation.
You will need to use -jamvm option to java command to run it with small overhead vm.

Let's update our clojure executable:

```bash /usr/bin/clojure
#!/bin/bash

java -jamvm -jar /opt/clojure.jar $@
```

Let's try it out:

```bash
time /opt/test.clj
hello world

real  0m0.866s
user  0m0.764s
sys   0m0.076s
```

Better, right?

## How slow is JamVM? Some benchmarks:

```text
Clojure 1.6

JamVM:

(factorial 5000) Avg: 248.65890986500017
(fib 20)         Avg: 35.33471996000001
(sort-seq)       Avg: 405.7438969800002

OpenJDK:

(factorial 5000) Avg: 25.016900630000006
(fib 20)         Avg: 0.69957772
(sort-seq)       Avg: 11.553695560000001
```

Much slower, but if you think about it
shell scripting most of the time is about executing external commands,
IO and data filtering. Might be as well not so bad.
Also memory usage of JamVM makes it perfect for embedded systems.

## Why not use something like lein exec?

Lein exec is nice. But it adds overhead.
If you need external dependencies you can solve it (in theory)
with classpath manipulations in java command (`java -cp dep.jar:dep2.jar:.`).
Still you can plug lein exec to JamVM if you want.
