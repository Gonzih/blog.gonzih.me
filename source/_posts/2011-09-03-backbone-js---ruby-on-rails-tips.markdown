---
layout: post
title: "Backbone.js + Ruby on Rails Tips"
date: 2011-09-03 10:05
comments: true
categories: [ror, rails, backbone.js]
---
<!-- more -->
* Add initializer that disable sending data in namespaces in json.
``` ruby
ActiveRecord::Base.include_root_in_json = false

# {"post": {"title": "some title", "content": "some content"}}
# will be
# {"title": "some title", "content": "some content}
```
* Use attr_accessible for filtering attributes in mass assigments from backbone. In rails > 3.1 you can use attr_accessible with :as => role.
* Use [inherited resources](https://github.com/josevalim/inherited_resources) for faster development.
