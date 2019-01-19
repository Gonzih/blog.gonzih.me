---
layout: post
title: "Routing with Go on Google Cloud Functions"
date: "2019-01-18"
comments: true
categories: [go, google, cloud functions, gke, routing]
---

Couple of days ago Google cloud functions got [official support for go 1.11](https://cloud.google.com/blog/products/application-development/cloud-functions-go-1-11-is-now-a-supported-language).
I got interested in how to handle routing in cloud functions in go, so after couple of experiments I came up with a solution based on `http.ServeMux`.

<!--more-->

To get started with cloud functions you can follow [this simple tutorial](https://codelabs.developers.google.com/codelabs/cloud-starting-cloudfunctions/index.html?index=..%2F..index#0).

One of many neat things about cloud functions is that they can be built from existing Github repository. You simply have to define Google source repository that mirrors one on Github and use this repository as source for your newly defined cloud function.

It feels like go code you upload to cloud function gets loaded by some generated code as a dependency.
Ultimately we can simply define our own router using `NewServeMux` like this:

```go
package function

import (
	"net/http"
)

//F represents cloud function entry point
func F(w http.ResponseWriter, r *http.Request) {
	newMux().ServeHTTP(w, r)
}

func newMux() *http.ServeMux {
	mux := http.NewServeMux()
	mux.HandleFunc("/one", one)
	mux.HandleFunc("/two", two)
	mux.HandleFunc("/subroute/three", three)

	return mux
}

func one(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello from one"))
}

func two(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello from two"))
}

func three(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("hello from three"))
}
```

Now you can access your handlers by appending `/one`, `/two` or `/subroute/three` to URL that cloud functions will have in triggers section of the UI like this: `https://us-central1-my-test-project-123456.cloudfunctions.net/my-function-1/one`.

This works because your cloud function receives request with prefix stripped away from the URL. This is very handy since allows one to port existing http server in to cloud function without changing it too much.

I hope that helps, and happy hacking on cloud functions with go!

Example code can be [found here](https://github.com/Gonzih/go-google-functions-demo).
