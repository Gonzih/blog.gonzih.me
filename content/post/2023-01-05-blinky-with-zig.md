---
layout: post
title: "Blinky on Arduino UNO with Zig"
date: "2023-01-05"
comments: true
draft: false
categories: [zig, arduino, embed]
---

Let's give Zig a try on Arduino UNO with [microzig](https://github.com/ZigEmbeddedGroup/microzig)

<!--more-->

Lets create and setup our project first:

```
mkdir blink && cd blink
zig init-exe
```

Now we can add [microzig](https://github.com/ZigEmbeddedGroup/microzig) as a dependency, for now lets do this in a simple manner, no package managers, just git:


```
mkdir deps
git clone https://github.com/ZigEmbeddedGroup/microzig.git deps/microzig
```

Lets now setup `build.zig`:

```zig
const std = @import("std");
const microzig = @import("deps/microzig/src/main.zig");

pub fn build(b: *std.build.Builder) !void {
    const backing = .{
        .board = microzig.boards.arduino_uno,
    };

    var exe = microzig.addEmbeddedExecutable(
        b,
        "blink",
        "src/main.zig",
        backing,
        .{},
    );

    exe.setBuildMode(.ReleaseSmall);
    exe.install();
}
```


And now it's time to write actual blink code:

```zig
const micro = @import("microzig");

const led_pin = micro.Pin("D13");

pub fn main() void {
    const led = micro.Gpio(led_pin, .{
        .mode = .output,
        .initial_state = .low,
    });
    led.init();

    while (true) {
        busyloop();
        led.toggle();
    }
}

fn busyloop() void {
    const limit = 100_000;

    var i: u24 = 0;
    while (i < limit) : (i += 1) {
        @import("std").mem.doNotOptimizeAway(i);
    }
}
```


After that we should be able to build this:

```
zig build
ls zig-out/bin
```

And we can now use `avrdude` to upload this to our Arduino UNO.

```
avrdude -carduino -patmega328p -D -P /dev/ttyACM0 -Uflash:w:./zig-out/bin/blink:e
```

Double check what your device is on your OS, on apple silicon macbook for me device was `/dev/cu.usbmodem11101`.

Thats it, it should be blinkin!
