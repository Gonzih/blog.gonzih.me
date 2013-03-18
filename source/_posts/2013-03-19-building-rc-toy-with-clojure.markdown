---
layout: post
title: "Building RC Toy with Clojure"
date: 2013-03-19 11:09
comments: true
categories:
---
Bored and have free time? Lets build something.
Lets build RC Toy. Hm, and lets use Clojure (because clojure is pure fun to use).
First of all we need some parts.

* Tamiya Universal Plate Set (TAM70157) (better to order 2 pcs)
* Tamiya Track and Wheel Set (TAM70100)
* Tamiya Twin Motor Gearbox  (TAM70097)
* Arduino (I have UNO and Leonardo, UNO was choosen since I don't need to make lot of modifications in Firmata code for it)
* HBridge IC L293 (L293 was used)
* Bluetooth module (you can buy Arduino ready module, I will be using cheapest possible module)
* Bluetooth in PC
* Wires
* Batteries or Accumulator (I have 9v batteries so I will use them)

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

# Writing some code
I stuck with [Clojure](http://clojure.org/) as main language for controlling Arduino. I took [Clodiuno](https://github.com/nakkaya/clodiuno) library.
It is Firmata protocol implementation for Clojure. Why Firmata? Because it's easy, fast and provide great way to extend your project in future.

So I wrote some code, uploaded Firmata to Arduino. And... it's not working.

So after some digging in Firmata and Clodiuno code I wrote 2 pull request to Clodiuno.

First issue was that bluetooth uses 9600 baudrate for communications. Fix? [pull.](https://github.com/nakkaya/clodiuno/pull/5)

* Update standart Firmata example code in Arduino IDE. Change baudrate to 9600.
* Change Clodiuno baudrate to 9600.

Second was that Clodiuno waits for version response from Firmata. It's ok for wired UNO since it will be restarted when serial connection is established.
But boards like Leonardo or if you use bluetooth don't support that behavior.

Fix? [pull.](https://github.com/nakkaya/clodiuno/pull/6) Manually ask firmware version on Clodiuno initialization.

# Raspberry Pi
## Native dependencies issue
Seems like jvm tries to load linux64 native dependencies for Raspberry Pi. Fix:
```sh
#INFO: Failed to load library: no jinput-linux64 in java.library.path
sudo ln -s /usr/lib/jni/libjinput.so /usr/lib/jni/libjinput-linux64.so`
```
## Gamepad configuration
add `joydev` to `/etc/modules`
to see my gamepad in /etc/input I switched it to direct input mode (X -> D switch at the back of gamepad)

Failed to open device (/dev/input/js0): Failed to open device /dev/input/js0
