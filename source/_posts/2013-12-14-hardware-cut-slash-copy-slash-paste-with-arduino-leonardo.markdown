---
layout: post
title: "Hardware Cut/Copy/Paste with Arduino Leonardo"
date: 2013-12-14 20:02
comments: true
categories: [arduino, leonardo, keyboard, ruby]
published: false
---
Since I switched to Programmed Dvorak layout default keybindings for different operations started to annoy me sometimes.
I was thinking about hardware cut/copy/paste in apps even before that. But only with Dvorak I realized how useful it can be.
I always wondered why there is no hardware support for that on various keyboard that out there. And then I saw (keyboard.io)[keyboard.io].
Project is about hackable ergonomic mechanical keyboards build on top of Teensy/Arduino Micro boards. And I decided to play a little bit with that idea.
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

void pressShift() {
  Keyboard.press(KEY_LEFT_SHIFT);
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

It works! But... for example in my terminal I use Ctrl+Shift+C to copy selection.
Of course I can press Shift+Copy combination. But maybe there is better solution.

## Automatic detection of key combination.

Idea is simple. We have serial port open on Leonardo and our Linux PC.
When I'm pressing copy on Leonardo it will ask through serial port PC about required combination.
On PC there will be running ruby script that will detect currently focused window and look up at the configuration file for
keys combination. If there is no combination will be found or reply from script will be timed out we will use default combination.

## Detecting WM_CLASS from Ruby.

From my experience with Xmonad best method to detect unique window type is by WM_CLASS string from X properties.
Here is Window class for the job:

```ruby
class Window
  def self.current
    Window.new(`xprop -root`)
  end

  def initialize(data)
    @root_data = data
  end

  def id
    matches = @root_data.lines.grep(/_NET_ACTIVE_WINDOW\(WINDOW\)/)

    if matches
      match_data = matches.first.match(/_NET_ACTIVE_WINDOW\(WINDOW\):.*#\s(.*)\n/)
      match_data[1]
    else
      raise 'No Window id was found'
    end
  end

  def wm_class
    out = `xprop -id '#{id}'`
    matches = out.lines.grep(/WM_CLASS\(STRING\)/)

    if matches
      match_data = matches.first.match(/WM_CLASS\(STRING\)[^"]*(".*")\n/)
      match_data[1].gsub(/"/,'').split(', ')
    else
      raise 'No Window class was found'
    end
  end

  def is_a?(class_string)
    wm_class.any? { |s| s == class_string }
  end
end
```

Usage examples:

```ruby
Window.current.wm_class
=> ["gvim", "Gvim"]

Window.current.is_a?("gvim")
=> true
```

## Keys configuration.

For now lets implement simplest class for that and store all configuration in constant.

```ruby
class Keys
  CONFIG = {
    'terminology' => {
      copy: 'ctrl-shift-c',
      paste: 'ctrl-shift-v',
      cut: nil
    }
  }

  def [](key)
    CONFIG[key]
  end
end
```

Usage:

```ruby
Keys.new['terminology'][:copy]
=> 'ctrl-shift-c'
```

## Communicating with Arduino via SerialPort.

```cpp
String stringIn;
// Let's assume than combination aren't longer than 4 keys
String collectedStrings[4];
int counter, inByte, i;

void setup(){
  Serial.begin(9600);
  counter = 0;
  stringIn = String("");
}

void resetReader() {
  counter = 0
  stringIn = String("")
  for (i = 0; i <= 4; i++) {
    collectedStrings[i] = String("")
  }
}

void readLine() {
  while(Serial.available()){
    inByte = Serial.read();
    stringIn += inByte;

    if (inByte == '-'){  // Handle delimiter
      collectedStrings[counter] = String(stringIn);
      stringIn = String("");
      counter = counter + 1;
    }

    if(inByte ==  '\r'){  // end of line
      resetReader();
      return;
    }
  }
}

void executeCombination() {
  for(i = 0; i <= 4; i++) {
    pressKey(collectedstrings[i]);
  }

  Keyboard.releaseAll();
}

void pressKeys(String key) {
  switch(key) {
    case "ctrl":
      pressCtrl();
      break;
    case "shift":
      pressShift();
      break;
    default:
      Keyboard.write(key);
  }
}
```

<!--
vim: ts=2:sts=2:sw=2:expandtab
-->
