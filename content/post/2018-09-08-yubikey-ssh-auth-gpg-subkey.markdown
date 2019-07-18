---
layout: post
title: "YubiKey as a portable SSH key"
date: "2018-09-08"
comments: true
categories: [arch, linux, ssh, yubikey, pgp, openpgp]
---

This blog post is just a bunch of shell snippets quickly put together that explain how to use YubiKey as your ssh key.

<!--more-->

## Setup

So first things first, we will have to enable CCID (smartcard interface) on YubiKey:

For YubiKey Neo or YubiKey 4 run following:

```shell
$ ykpersonalize -m82
```

For YubiKey 5:

```shell
$ ykman config usb --enable-all # For USB
$ ykman config nfc --enable-all # For NFC
```


Next step would be to change default PINs on YubiKey:

```shell
$ gpg --card-edit

gpg/card> admin
Admin commands are allowed

gpg/card> passwd
gpg: OpenPGP card no. _____ detected

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

# default password here is 123456
Your selection? 1

...

gpg: OpenPGP card no. _____ detected

1 - change PIN
2 - unblock PIN
3 - change Admin PIN
4 - set the Reset Code
Q - quit

# default password here is 12345678
Your selection? 3

...

```

If you mess anything up (forgot your PIN for example), you can always nuke OpenPGP configuration on your YubiKey:

```shell
$ ykman openpgp reset
WARNING! This will delete all stored OpenPGP keys and data and restore factory settings? [y/N]: y
```

There are two ways to use your YubiKey as a ssh key:


## Method #1: Generating keys on YubiKey itself

Simply run the following commands:

```shell
gpg --card-edit

gpg/card> generate
```

Benefit of this method is that your keys and YubiKey are self contained, this is also a downside of this method.
If you lost a key, you also going to loose access to your private key.
There is no way to backup secret keys from YubiKey itself.
I did not really test this method extensively, but still felt like mentioning this as a valuable option.


## Method #2: Generating a subkey for your own private key

So lets say you generated your own private key with id `ABCDEFG`, now we can generate 2 subkeys and store them on our YubiKey.
The advantage of this approach is in the fact that subkeys can be revoked by using your private key.

```shell
$ gpg --edi-key ABCDEFG

gpg> addcardkey

Signature key ....: [none]
Encryption key....: [none]
Authentication key: [none]

Please select the type of key to generate:
   (1) Signature key
   (2) Encryption key
   (3) Authentication key
Your selection? 3

# Now answer bunch of questions and enter PIN couple of times to make gpg happy
# After that we can do the same for the Signature key

...

gpg> addcardkey

Signature key ....: [none]
Encryption key....: [none]
Authentication key: OUR NEW KEY ID

Please select the type of key to generate:
   (1) Signature key
   (2) Encryption key
   (3) Authentication key
Your selection? 1

# Now lets use toggle to switch in to private key listing mode
> toggle

# And now lets select our main private key
> key 1

# Time to upload card keys to our YubiKey in to encryption slot
> keytocard

Signature key ....: ANOTHER ID
Encryption key....: [none]
Authentication key: OUR NEW KEY ID

Please select where to store the key:
   (2) Encryption key
Your selection? 2

# And we are done here
gpg> save
```

Don't forget to distribute your private key if needed:

```shell
$ gpg --keyserver hkps://keys.gnupg.net --send-key ABCDEFG
```

## Final steps

Generating ssh key out of our gpg key is pretty straightforward:
```shell
$ gpg --export-ssh-key ABCDEFG
ssh-rsa BLABLABLA openpgp:someid
```

Now its time to start `gpg-agent` with ssh support on:
```shell
$ gpg-agent --daemon --enable-ssh-support
# or on older gpg versions you can generate env file that you can source in your .bashrc directly
$ gpg-agent --daemon --enable-ssh-support --write-env-file ~/.gpg-agent-env
```

Or if you are on systemd based system there is a chance that your user already has a bunch of systemd sockets enabled for this purpose.
One socket that you should be interested in is `gpg-agent-ssh.socket`, you can see if its running by running `systemctl --user status gpg-agent-ssh.socket`.

Add this to your `.bashrc` to initialize env var properly:
```bash
export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
```

Last improvement that can be made to this setup is forcing gpg-agent to use pcscd instead of ccid.
This should solve some issues with a card being unavailable when some other application is accessing it.
Just add following to the `~/.gnupg/scdaemon.conf` file:

```text
pcsc-driver /usr/lib/libpcsclite.so
card-timeout 5
disable-ccid
```

## Setting up key on a new machine

```shell
$ gpg --keyserver hkps://pgp.mit.edu --recv-key ABCDEFG
```

And if gpg-agent is setup properly you should be ready to go. Just plug in your YubiKey and try to ssh to some host, you should see PIN prompt which means everything works as expected.

## Caching PIN on a key itself

It might be annoying to type in PIN on every action every time, there is an option to cache PIN on YubiKey itself, so you will have to input PIN only once after you plugged your key (will have to do that every time you unplug/plug your key) for every action (separate key cache for signing/authenticating using the key).
To do that you should enable `forcesig` in `gpg`:

```shell
$ gpg --card-edit

gpg/card> admin
Admin commands are allowed

gpg/card> forcesig
gpg/card> save
```

To add extra layer of security, you can enable [YubiKey 4 Touch](https://developers.yubico.com/PGP/Card_edit.html) feature (every action will have to be confirmed with a touch), this can be enabled using `yubikey-manager` cli:

```shell
$ ykman openpgp touch aut on
$ ykman openpgp touch sig on
$ ykman openpgp touch enc on
```
