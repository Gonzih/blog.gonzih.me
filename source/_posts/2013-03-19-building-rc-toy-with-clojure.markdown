---
layout: post
title: "Building RC Toy with Clojure"
date: 2013-03-19 11:09
comments: true
categories:
---
Bored and have free time? Lets build something.
Lets build RC Toy. Hm, and lets use Clojure (because clojure is pure fun to use).

<!-- more -->

First of all we need some parts.

* Tamiya Universal Plate Set (TAM70157) (better to order 2 pcs)
* Tamiya Track and Wheel Set (TAM70100)
* Tamiya Twin Motor Gearbox  (TAM70097)
* Arduino (I have UNO and Leonardo, UNO was choosen since I don't need to make modifications in Firmata code for it (except baudrate))
* HBridge IC L293 (L293B was used)
* Bluetooth module (you can buy Arduino ready module, I will be using cheapest possible module)
* Bluetooth in PC
* Wires
* Batteries or Accumulator (I have 9v batteries so I will use them)
* Gamepad (Logitech Rumble Gemapad F510 was used)

# Putting things together
## Chassis
First lets build gearbox. You can use it in few different modes of gear ratio. I selected 114.7:1 gear ratio (lucky guess).
Read instructions, take your time. I had 2 9v motors, so since I will be using 9v batteries I decided to replace default motors with 9v ones.

Next assemble tracks. Pretty easy, right? Next is time to put it all together. Since I han only 1 plate I made second one from peace of plexiglass.
I made something like 2 floor chassis. First floor is for motor and wheels (and maybe batteries) and second is for Arduino (and maybe batterries).

## Bluetooth
We need to do 2 thing with our cheap bluetooth module:

Solder legs to it
![Soldered bluetooth module](https://dl.dropbox.com/u/4109351/octopress/rc-toy/bluetooth-module-for-Arduino.jpg)

Use voltage divider (module is working on 3.3v, Arduino is working on 5v)
![Voltage devider](https://dl.dropbox.com/u/4109351/octopress/rc-toy/bluetooth-module-for-Arduino.svg)

## Gearbox and HBridge Driver
To control motors I decided to use HBridge. You can use bunch of transistors if you want, but I'm afraid it will be messy.
To understand how HBridge works you should read [Adafruit post](http://learn.adafruit.com/adafruit-Arduino-lesson-15-dc-motor-reversing/overview).

HBridge -> Arduino Schematics:
![Schematics](https://dl.dropbox.com/u/4109351/octopress/rc-toy/arduino-and-hbridge-l293b-rc-toy.svg)

## Final version

### Photos
![rc-toy-001](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-001.jpg)
![rc-toy-002](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-002.jpg)
![rc-toy-003](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-003.jpg)
![rc-toy-004](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-004.jpg)
![rc-toy-005](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-005.jpg)
![rc-toy-006](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-006.jpg)
![rc-toy-007](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-007.jpg)
![rc-toy-008](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-008.jpg)
![rc-toy-009](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-009.jpg)
![rc-toy-010](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-010.jpg)
![rc-toy-011](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-011.jpg)
![rc-toy-012](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-012.jpg)
![rc-toy-013](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-013.jpg)
![rc-toy-014](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-014.jpg)
![rc-toy-015](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-015.jpg)
![rc-toy-016](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-016.jpg)
![rc-toy-017](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-017.jpg)
![rc-toy-018](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-018.jpg)
![rc-toy-019](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-019.jpg)
![rc-toy-020](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-020.jpg)
![rc-toy-021](https://dl.dropbox.com/u/4109351/octopress/rc-toy/photos/photo-021.jpg)

### Video
{% video https://dl.dropbox.com/u/4109351/octopress/rc-toy/video-1.flv 640 480 https://dl.dropbox.com/u/4109351/octopress/rc-toy/video-1-cover.jpg %}

# Writing some code
## Bluetooth as Serial port
I used blueman on my Arch Laptop. Gui is straightforward and easy to use.

## Gamepad and kernel
You need to find kernel module for your gamepad. For my gamepad module `joydev` was required.
After module is loaded you should see new device in `/dev/input`.

## Clojure code
I stuck with [Clojure](http://clojure.org/) as main language for controlling Arduino. I took [Clodiuno](https://github.com/nakkaya/clodiuno) library.
It is Firmata protocol implementation for Clojure. Why Firmata? Because it's easy, fast and provide great way to extend your project in future.

So I wrote some code, uploaded Firmata to Arduino. And... it's not working.

After some digging in Firmata and Clodiuno code I wrote 2 pull request to Clodiuno.

First issue was that bluetooth uses 9600 baudrate for communications. Fix? [pull.](https://github.com/nakkaya/clodiuno/pull/5)

* Update standart Firmata example code in Arduino IDE. Change baudrate to 9600.
* Change Clodiuno baudrate to 9600.

Second was that Clodiuno waits for version response from Firmata on startup. It's ok for wired UNO since it will be restarted when serial connection is established.
But boards like Leonardo or if you are using bluetooth miss that behavior.

Fix? [pull.](https://github.com/nakkaya/clodiuno/pull/6) Manually ask firmware version on Clodiuno initialization.

Most of controller related logic was extracted from awesome library [overtone-jinput](https://github.com/gavilancomun/jinput-overtone).
I just replaced overtone related events handling with my own code based on Clodiuno.

Final version of code is on [GitHub](https://github.com/Gonzih/clj-arduino-rc-toy)

You can run it with `./run.sh`.

# Raspberry Pi

Currently work in progress on moving Clojure code to Rapberry Pi.

## Fixed Issues

### Native dependencies issue
Seems like jvm tries to load linux64 native dependencies for Raspberry Pi. Fix:

```sh
#INFO: Failed to load library: no jinput-linux64 in java.library.path
sudo ln -s /usr/lib/jni/libjinput.so /usr/lib/jni/libjinput-linux64.so`
```

### Gamepad configuration
Add `joydev` to `/etc/modules` to see gamepad in `/etc/input`.
Also you need to switch gamepad to direct input mode (X -> D switch on the back of gamepad).

## Unfixed Issues

### Bluetooth as Serial port
To scan for devices from command line use `hcitool scan`.

To bind bluetooth to serial port on startup use following code (untested yet):

```text /etc/bluetooth/rfcomm.conf
rfcomm0 {
        bind yes;
        device mac-adress-of-bluetooth-on-arduino;
        channel 1;
        comment "Arduino";
}
```

### JInput permissions
For now I have no idea how to fix that issue. Looks like something is wrong with permissions.
```
Failed to open device (/dev/input/js0): Failed to open device /dev/input/js0
```
