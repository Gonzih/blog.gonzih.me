---
layout: post
title: "Scripting with Go on NixOS"
date: "2019-04-26"
comments: true
categories: [go, nixos, scripting, link]
---

This is a short HOWTO based on great idea from [this blog post](https://blog.cloudflare.com/using-go-as-a-scripting-language-in-linux/) on how
to utilize [gorun](https://github.com/erning/gorun) and `binfmt_misc` to use go files for scripting.

<!--more-->

First lets install `gorun` as a system package on NixOS.

Lets create `gorun.nix` file first:

```
with import <nixpkgs> {};

buildGoPackage rec {
  name = "gorun-${version}";
  version = "master-85cd5f5e084af0863ed0c3f18c00e64526d1b899";
  goPackagePath = "github.com/erning/gorun";

  src = fetchFromGitHub {
    owner = "erning";
    repo = "gorun";
    rev = "85cd5f5e084af0863ed0c3f18c00e64526d1b899";
    sha256 = "sha256:1hdqimfzpynnpqc7p8m8hkcv9dlfbd8kl22979i6626nq57dvln8";
  };

  meta = with stdenv.lib; {
    description = "gorun is a tool enabling one to put a \"bang line\" in the source code of a Go program to run it";
    homepage = https://github.com/erning/gorun;
    license = licenses.mit;
    maintainers = with maintainers; [ Gonzih ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
```

Next lets add this package to `systemPackages` list:

```
environment.systemPackages = with pkgs; [
  ...
  (import ./gorun.nix)
  ...
];
```

Next step would be to utilize `boot.binfmtMiscRegistrations` to register our `gorun` in `binfmt_misc` module which is
responsible for parsing shebang scripts and binary files. Drop the following lines in to your `configuration.nix`:

```
boot.binfmtMiscRegistrations = {
  go = {
    recognitionType = "extension";
    magicOrExtension = "go";
    interpreter = "/run/current-system/sw/bin/gorun";
    preserveArgvZero = false;
    openBinary = true;
    matchCredentials = true;
    fixBinary = false;
  };
};
```

What does this configuration do? `recognitionType` tells `binfmt` to make a decision based on file extension,
`magicOrExtension` tells it to look for `.go` extension, `interpreter` specifies which binary to invoke,
`openBinary` corresponds to `O` flag of `binfmt` (which I dont fully understand tbh), `matchCredentials` tells kernel to run
interpreter with permissions set on original script. For more information on `binfmt` please do check out [these amazing kernel docs](https://www.kernel.org/doc/html/v4.14/admin-guide/binfmt-misc.html).

Now lets simply run `sudo nixos-rebuild --switch` and after everything is done lets give it a try.

First lets create a simple hello world script:

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello World!")
}
```

Lets make it executable with `chmod +x hello.go`.

And now lets run it:

```
$ ./hello.go
Hello World!
```

Yay! It works!

Hope that helps somewhat.
