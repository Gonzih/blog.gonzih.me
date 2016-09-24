---
layout: post
title: "Set New PostgreSQL Databases Encoding to Unicode"
date: "2011-09-30"
comments: true
categories: [db, postgresql]
---
You must change encoding for template1. For do that run following.

```
su - postgres
psql

UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';
DROP DATABASE template1;
CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';

#recomended
\c template1
VACUUM FREEZE;
```

[via](http://journal.tianhao.info/2010/12/postgresql-change-default-encoding-of-new-databases-to-utf-8-optional/)
<!--more-->
