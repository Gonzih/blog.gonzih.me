---
layout: post
title: "Hardware Cut/Copy/Paste with Arduino Leonardo"
date: 2013-12-14 20:02
comments: true
categories: [arduino, leonardo, keyboard, ruby]
---
Since I switched to Programmed Dvorak layout default keybindings for different operations started to annoy me sometimes.
I was thinking about hardware cut/copy/paste in apps even before that. But only with Dvorak I realized how useful it can be.
I always wondered why there is no hardware support for that on various keyboard that out there. And then I saw (keyboard.io)[keyboard.io].
Project about hackable ergonomic mechanical keyboards build on top of Teensy/Arduino Micro boards. And I decided to play a little bit with that idea.
Lets start with implementing hardware cut/copy/paste using Leonardo and then lets see how far we can push the idea.

<!-- more -->

## Emulating keyboard on Leonardo.

Since first boards based on ATmega32u4 (as far as I know first one was Leonardo) Keyboard and Mouse libraries where introduced.
Those libraries allow you to emulate fully functional mouse and keyboard from your Arduino board using USB connection. For more information take a look at the (documentation)[http://arduino.cc/en/Reference/MouseKeyboard].

## Arduino wiring.

Wiring will be very simple. We will have 3 buttons on pins 2, 3 and 4 with pull down resistors.

![visualruby](https://dl.dropboxusercontent.com/u/4109351/octopress/hardware-cut-copy-paste/schematics1.png)

## Hardware Cut/Copy/Paste.

So this will be our simplest solution to the my original idea. Here is Arduino sketch:

```cpp
// version 0.0.1

int cutPin   = 2;
int copyPin  = 3;
int pastePin = 4;

void setup() {
  pinMode(cutPin, INPUT);
  pinMode(copyPin, INPUT);
  pinMode(pastePin, INPUT);
  Keboard.begin()
}

void loop() {
  if (digitalRead(cutpin)   == high) { cut();   }
  if (digitalRead(copypin)  == high) { copy();  }
  if (digitalRead(pastepin) == high) { paste(); }
}

void pressCtrl() {
  Keyboard.press(KEY_LEFT_CTRL);
}

void cut() {
  pressCtrl();
  Keyboard.write('x');
  Keyboard.releaseAll();
}

void copy() {
  pressCtrl();
  Keyboard.write('c');
  Keyboard.releaseAll();
}

void paste() {
  pressCtrl();
  Keyboard.write('v');
  Keyboard.releaseAll();
}
```
