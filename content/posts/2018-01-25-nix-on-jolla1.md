+++
title = "Nix on the Jolla 1 (Sailfish OS armv7 phone)"
slug = "2018-01-25-nix-on-jolla1"

[extra]
comments = true
language = "english"
tags = ["nix", "nixos", "Jolla", "Jolla Phone", "Sailfish OS", "tutorial"]
image = "/public/assets/nix-on-sailfish.png"
+++

I recently managed to make the [nix package manager](https://nixos.org/nix/) work on my [Jolla 1](https://en.wikipedia.org/wiki/Jolla_%28smartphone%29) phone. nixos.org only provides precompiled nix binaries and a binary cache for packages for the x86_64, AArch64[^sfosx] and some others, but not for armv7 (the architecture of the Jolla Phone's processor), so some compiling was necessary (and some patching too).

This post is a summary of what I did.
<!-- more -->
Unfortunately I forgot to write down the exact steps, so forgive me (and [tell me](/about)!) if some steps are missing or incomplete.

EDIT: At the time of writing, cross compilation is broken, but if you are reading this from the future you may be able to skip all this and simply cross compile nix with the following command (thanks Infinisil, Sonarpulse and LnL):

```
$ nix-build '<nixpkgs>' --arg crossSystem '(import <nixpkgs/lib>).systems.examples.armv7l-hf-multiplatform' -A nix
```

## Installing nix

This is all done from the terminal, so open it, or better yet open an ssh connection from your computer to your phone.

During the process you may get some errors about missing packages.
Just Install them with `pkcon install pkgname`.
If some package which is not in the repos is needed I'll specify it.

### Getting the sources

You can download a source tarball from [here](https://nixos.org/nix/download.html).

For example, at the moment of writing this post:

```
$ curl https://nixos.org/releases/nix/nix-1.11.16/nix-1.11.16.tar.xz > nix.tar.xz
```

You'll also need [libseccomp](https://github.com/seccomp/libseccomp/releases):

```
$ curl https://github.com/seccomp/libseccomp/releases/download/v2.3.3/libseccomp-2.3.3.tar.gz > libseccomp.tar.gz
```

Decompress everything:

```
$ unxz nix.tar.xz # busybox's tar doesn't support xz
$ tar -xf nix.tar
$ tar -xzf libseccomp.tar.gz
```

### Other dependencies & patching them

You'll need at least
`bison`,
`flex`,
`libcrypto`,
`openssl-devel`,
`bzip2-devel`,
`lzma-devel`,
`xz-devel`,
`sqlite-devel`,
all from the main repos.
As I said before, there are probably some missing.

nix needs some perl modules, so let's install cpan

```
pkcon install perl-CPAN
```

...and [patch it for busybox](http://www.perlmonks.org/?node_id=1144161) (the file to patch is in `/usr/share/perl5/CPAN/Tarzip.pm`).

And use it to install the modules (globally as root):

```
$ devel-su
# cpan install DBI
# cpan install DBD::SQLite
```

cpan may tell you about some missing modules. Just install them too and retry.

We also need `WWW::Curl`, but it needs a patch too.

```
# cpan -g WWW::Curl
# tar -xzf WWW-Curl-*.tar.gz
# rm WWW-Curl-*.tar.gz
# cd WWW-Curl-*
```

Then follow one of the two patching methods described [here](https://github.com/sparky/perl-Net-Curl/issues/18) and run

```
# cpan install .
```

to install the patched module.

Finally, you'll need to install `gnutar` (named `tar` in the repos): nix needs the additional functionality.
This may actually supersede the cpan patch, which was done to adapt it to busybox's tar.

### libseccomp

Cd to where you extracted libseccomp's sources and:

```
$ ./configure
$ make
$ devel-su
# make install
```

This will install it in `/usr/local`.

### Finally, nix

Cd to where you extracted nix's sources and

```
$ ./configure
$ make
$ devel-su
# make install
```

...and prepare to wait for [a long time :)](https://www.xkcd.com/303/)

## Configuration

You thought you were done, didn't you?

### preparing the /nix folder

Nix needs a writable /nix folder

```
$ devel-su
# mkdir /nix
# chown nemo:nemo /nix
```

`/nix` is about to get _very_ big, so if you have a btrfs or ext4-formatted SD card it's better to use it

```
$ mkdir /media/sdcard/<your SD card name>/nix
$ devel-su
# mount -o bind /media/sdcard/<your sdcard name>/nix /nix
# mount -o remount,exec /nix
```

You may want to set it to automatically mount at boot.

### Setting up a minimal binary cache

Compiling everything is tedious, so we'll use dezgeg's [minimal armv7 binary cache](https://nixos.wiki/wiki/NixOS_on_ARM#armv6l_and_armv7l)[^biggerpackages]:

```
$ devel-su
# echo 'binary-caches = http://nixos-arm.dezgeg.me/channel' >> /usr/local/etc/nix/nix.conf
# echo 'binary-cache-public-keys = nixos-arm.dezgeg.me-1:xBaUKS3n17BZPKeyxL4JfbTqECsT+ysbDJz29kLFRW0=%' >> /usr/local/etc/nix/nix.conf
```

### Enabling nix

```
$ source /usr/local/etc/profile.d/nix.sh # enable nix
$ echo 'source /usr/local/etc/profile.d/nix.sh' >> ~/.bash_profile # automatically enable nix for future sessions too
```

### Updating the channels

```
$ nix-channel --update
```

## Now let's try it

If you followed all the steps you should now have a working nix installation!

Let's try it:

```
$ nix-shell -p neofetch
[nix will automatically download neofetch's deps (and compile some of them)]
[nix-shell:~]$ neofetch
```

![neofetch on Sailfish OS](/public/assets/nix-on-sailfish.png)

Perfect!

[^sfosx]: So if you have eg. an xperia x you can just `curl https://nixos.org/nix/install | sh` and it will all work (with a full binary cache too!).

[^biggerpackages]: If someone wants to help me setup a hydra for armv7 / help compile some bigger packages (like GHC) just [contact me](/about)!

