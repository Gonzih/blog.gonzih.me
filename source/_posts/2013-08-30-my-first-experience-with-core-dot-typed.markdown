---
layout: post
title: "My first experience with core.typed"
date: 2013-08-30 12:30
comments: true
categories: [clojure, core.typed, rss]
---
Today I started improving my feeds2imap.clj project with core.typed.
And already hit few issues, so this post is something like collection of tips how to solve issues with core.typed based on my experience.
I couldn't find answers on my issues in wiki or documentation.
But I got answers annoying Ambrose Bonnaire-Sergeant on Google+.
Thank you for you patience, man!
And keep doing what you are doing, core.typed is just amazing thing!

<!--more-->

### Unresolved constructor invocation
Core.typed can't match constructor based on arguments type,
you should provide type hints to help core.typed with that.

### By default core.typed assumes that all java methods can return nil
Use `(non-nil-return ClassOrObject/methodName :all)` to tell core.typed that method won't return nil.
Core.typed will trust you and will skip further checks.

Or for example if you are expecting String as a result you can convert result to String with str before returning it.

### Core.typed doesn't understand inner class syntax inside non-nil-return
So something like that would not work:

```clojure
(non-nil-return javax.mail.Message$RecipientType/TO :all)

(ann recipient-type-to [-> Message$RecipientType])
(defn ^Message$RecipientType recipient-type-to []
  (Message$RecipientType/TO))

(comment
  Type mismatch:
  Expected:       (Fn [-> Message$RecipientType])
  Actual:         (Fn [-> (U Message$RecipientType nil)]))
```

Solution:

```clojure
(non-nil-return javax.mail.Message$RecipientType/TO :all)

(ann recipient-type-to [-> Message$RecipientType])
(defn ^Message$RecipientType recipient-type-to
  []
  {:post [%]}
  (Message$RecipientType/TO))
```

Which is the same as:

```clojure
(non-nil-return javax.mail.Message$RecipientType/TO :all)

(ann recipient-type-to [-> Message$RecipientType])
(defn ^Message$RecipientType recipient-type-to []
  (let [temp (Message$RecipientType/TO)]
    (assert temp)
    temp)
```

So unless assert evaluates temp to logical true exception will be raised,
so function will always return non nil value, which makes core.typed happy.

### Defining Parameterized alias type
```clojure
(def-alias Folder
  (TFn [[x :variance :covariant]] (Map Keyword x)))

(comment
  (Folder Items)
  (Folder Urls))
```

[Here is](https://github.com/Gonzih/feeds2imap.clj/commit/1c41d814bdb054d57e644013c85275ec9a45a114) commit with changes related to core.typed.
I must say writing type annotations for code that you wrote few months ago is tricky.
But still I enjoyed process and results and I'm still a little bit amazed about all core.typed thing.
Power of lisp combined with really smart people :)
