---
layout: post
title: "DIY Dependabot for Clojure"
date: "2021-01-28"
comments: true
draft: false
categories: [clojure, dependabot, dependencies]
---

![preview](https://d1wvxg652jdms0.cloudfront.net/diy-dependabot-clojure/pr-preview.png)

Unfortunately, [dependabot](https://dependabot.com) does not support [Clojure](https://clojure.org/).
And as such, I came up with a silly idea of putting something similar together using Github Actions.

<!--more-->

First things first here is the complete Github Actions workflow:

```yaml
name: Dependencies

on:
  schedule:
    - cron: '0 */3 * * *'
  workflow_dispatch:

jobs:
  bump:
    runs-on: ubuntu-latest
    container:
      image: nixos/nix
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0
    - run: nix-env -i clojure
    - name: run depot
      run: |
      clojure -Sdeps '{:aliases {:outdated {:replace-deps {olical/depot {:mvn/version "2.1.0"}}}}}' -M:outdated -m depot.outdated.main --every --write > deps-output.txt
    - uses: actions/upload-artifact@v2
      with:
        name: deps-output
        path: deps-output.txt
    - uses: actions/upload-artifact@v2
      with:
        name: deps
        path: deps.edn

  open-pr:
    runs-on: ubuntu-latest
    needs: bump
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0
    - uses: actions/download-artifact@v2
      with:
        name: deps-output
    - uses: actions/download-artifact@v2
      with:
        name: deps
    - id: get-pr-body
      run: |
        body=$(cat deps-output.txt)
        echo ::set-output name=body::$body
    - name: create PR
      id: cpr
      uses: peter-evans/create-pull-request@v3
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        title: "Update dependencies"
        body: ${{ steps.get-pr-body.outputs.body }}
        branch: update-dependencies
        labels: |
          dependencies
    - name: check outputs
      run: |
        echo "Pull Request Number - ${{ steps.cpr.outputs.pull-request-number }}"
        echo "Pull Request URL - ${{ steps.cpr.outputs.pull-request-url }}"
    - uses: geekyeggo/delete-artifact@v1
      with:
        name: deps-output
    - uses: geekyeggo/delete-artifact@v1
      with:
        name: deps
```

And now lets step by step to see what is going on here.

First, we allow workflow to be scheduled manually for testing purposes and via cron schedule every 3 hours:

```yaml
on:
  schedule:
    - cron: '0 */3 * * *'
  workflow_dispatch:
```

After that, we define our first job.
Workflow is split into two pieces because `peter-evans/create-pull-request@v3` has some issues running in custom containers (based on my experience).
And because of `rlwrap` issue in docker.
If you are able to run clojure clj tool in ubuntu image directly this config can be drastically simplified.

I do run actions for this project in nixos countainers and after checkout is done I make sure that clojure cli tool is available:
```yaml
    - run: nix-env -i clojure
```

To run depot in this example I just use example command from depot [README.md](https://github.com/Olical/depot#usage)
```yaml
    - name: run depot
      run: |
        clojure -Sdeps '{:aliases {:outdated {:replace-deps {olical/depot {:mvn/version "2.1.0"}}}}}' -M:outdated -m depot.outdated.main --every --write > deps-output.txt
```

After this is done we get two files that we care about:
* `deps.edn` - dependencies file that was modified by depot
* `deps-output.txt` - depot stdout that we can use as a body for a pull request

To transfer those two files we are going to utilize Github artifacts:

```yaml
    - uses: actions/upload-artifact@v2
      with:
        name: deps-output
        path: deps-output.txt
    - uses: actions/upload-artifact@v2
      with:
        name: deps
        path: deps.edn
```

And now we can proceed with creating pull request.
It is important to tell our second job that it has to wait for the first one to complete.
Otherwise, there would be no files available for download from storage.
To do that we can simply say that job `needs: bump`, `bump` being the name of our first job of course.

First, lets download our two files from artifact storage:

```yaml
    - uses: actions/download-artifact@v2
      with:
        name: deps-output
    - uses: actions/download-artifact@v2
      with:
        name: deps
```

Once this is done we need to read the output file and store it in output variable of a step.
To later reuse this variable we give this step id `get-pr-body`.

```yaml
    - id: get-pr-body
      run: |
        body=$(cat deps-output.txt)
        echo ::set-output name=body::$body
```

And now let's create our pull request.
To allow this action to access our repository we will need to give it a token.
I used [Personal Access Token](https://github.com/settings/tokens) with `repo` scope fully enabled.
You can see how we extract body using variable inlining with `${{ steps.get-pr-body.outputs.body }}`.

```yaml
    - name: create PR
      id: cpr
      uses: peter-evans/create-pull-request@v3
      with:
        token: ${{ secrets.GITHUB_TOKEN }}
        title: "Update dependencies"
        body: ${{ steps.get-pr-body.outputs.body }}
        branch: update-dependencies
        labels: |
          dependencies
```

Once this step succeeded we can print pull request information (mostly for debugging purposes)
```yaml
    - name: check outputs
      run: |
        echo "Pull Request Number - ${{ steps.cpr.outputs.pull-request-number }}"
        echo "Pull Request URL - ${{ steps.cpr.outputs.pull-request-url }}"
```

And of course lets not forget to clean up after ourselves!

```yaml
    - uses: geekyeggo/delete-artifact@v1
      with:
        name: deps-output
    - uses: geekyeggo/delete-artifact@v1
      with:
        name: deps
```

And that's it! One day there might be a better tool or approach to solve this, but for now our small workflow should do just fine :)
