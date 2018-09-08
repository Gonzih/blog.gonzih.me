---
layout: post
title: "Yubikey as a portable SSH key"
date: "2018-09-08"
comments: true
categories: [arch, linux, ssh, yubikey, pgp, openpgp]
---

This blog post is just a bunch of shell snippets quickly put together that explain how to use yubikey as your ssh key.

<!--more-->

## Setup

So first things first, we will have to enable CCID (smartcard interface) on yubikey:

```shell
$ ykpersonalize -m82
```

Next step would be to change default PINs on yubikey:

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

If you mess anything up (forgot your PIN for example), you can always nuke OpenPGP configuration on your yubikey:

```shell
$ ykman openpgp reset
WARNING! This will delete all stored OpenPGP keys and data and restore factory settings? [y/N]: y
```

There are two ways to use your yubikey as a ssh key:


## Method #1: Generating keys on yubikey itself

Simply run the following commands:

```shell
gpg --card-edit

gpg/card> generate
```

Benefit of this method is that your keys and yubikey are self contained, this is also a downside of this method.
If you lost a key, you also going to loose access to your private key.
There is no way to backup secret keys from yubikey itself.
I did not really test this method extensively, but still felt like mentioning this as a valuable option.


## Method #2: Generating a subkey for your own private key

So lets say you generated your own private key with id `ABCDEFG`, now we can generate 2 subkeys and store them on our yubikey.
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

# Time to upload card keys to our yubikey in to encryption slot
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
$ gpg --keyserver hkps://pgp.mit.edu --send-key ABCDEFG
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

## Setting up key on a new machine

```shell
$ gpg --keyserver hkps://pgp.mit.edu --recv-key ABCDEFG
```

And if gpg-agent is setup properly you should be ready to go. Just plug in your yubikey and try to ssh to some host, you should see PIN prompt which means everything works as expected.
