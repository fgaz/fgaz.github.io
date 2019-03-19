+++
title = "Haskell Summer of Code 2017: Last Mile for `cabal new-build`: first and last status update"
slug = "2017-09-13-hsoc-cabal-new-build-status-update-1"
aliases = [ "2017-9-13-hsoc-cabal-new-build-status-update-1" ]

[extra]
comments = true
language = "english"
tags = ["haskell", "cabal", "hsoc", "new-build"]
image = "https://www.haskell.org/cabal/images/Cabal-dark.png"
+++

Time flies! The Haskell Summer of Code is over, and this is my first and last
status update. Last in the HSoC, but not in the project, as you'll see.

My goal was to bring `cabal-install`'s `new-build` to a usable state, to eventually replace
the old commands.

<!-- more -->

## What has been done

My original proposal was _way_ too optimistic.
Of the many secondary and optional goals I planned, I've reached zero of them.

Fortunately they were, as I wrote, secondary.
`new-build` was and is a work in progress, but now it's close to completion.

Here's a summary of what I did:

### [#3638](https://github.com/haskell/cabal/issues/3638): `new-run`, `new-test`, `new-bench`, `new-exec`

The most important goal of the project was to reach feature parity with old-build.

* [`new-run`](https://github.com/haskell/cabal/issues/4586) is now fully functional
* `new-test` and [`new-bench`](https://github.com/haskell/cabal/issues/4614)
   work, except from some rough edges (like the ability to pass arguments to tests)
* [`new-exec`](https://github.com/haskell/cabal/issues/4722)
  has always been kind of an hack and we discussed a lot about it.
  Environment files helped a lot, and you should [check them out](https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/packages.html#package-environments)!

With these commands, `new-build` only lacks `new-install`.

### Data-files

Data-files are additional files to be included in a package distribution
(be it a sdist, a debian package or the store itself). They are used when including
the data in the executable itself (eg. with a literal string or even
a picture using [file-embed](https://hackage.haskell.org/package/file-embed))
is not feasible or not practical.

The path to the data-files is hardcoded at compile-time (the `--datadir` flag),
and by default it is set to the store (where the majority of packages will reside).
For this reason, when using an inplace-built package, `datadir` resolved to a
non-existing directory.

Fortunately, `datadir` can be overridden with an environment variable, which is
now properly set by `new-run`.

If your project includes data-files, now you can use `new-run` and it should work without problems.

### [`new-install`](https://github.com/haskell/cabal/issues/4558) ...almost

This is the biggest command, because it actually handles four cases:

* nonlocal exes (`cabal new-install pandoc; pandoc file.md`)
* nonlocal libs (`cabal new-install lens; ghci; import Control.Lens`)
* local exes (`cabal new-install` in a project)
* local libs (`cabal new-install` in a project, but for libraries,
  partially solved by environment files )

The first one, which allows the installation of programs from hackage,
and is probably the most used one (eg. `cabal new-install pandoc`),
is [almost complete (needs some cleanup but it works)](https://github.com/fgaz/cabal/tree/new-install/2).

The difference with old-install is that executables will be installed
in the store and symlinked to `~/.cabal/bin` or equivalent.

This raises the problem of garbage collection: deleting the symlink leaves
the executable and all of its dependencies in the store.
In the future, a [`cabal garbage-collect`](https://github.com/haskell/cabal/issues/3333) command will track the symlinks and automatically clean the store.

## How to try it

Cabal HEAD should always build and should be fairly stable.
If you want to try the new features just run:

        cabal get -s cabal-install
        cd cabal-install*

and then build/install it with `cabal install`
or `cabal sandbox init` + `cabal install`
or `cabal new-build`.

## What remains to do

90% of the work was done, now there's [the other 90%](https://en.wikipedia.org/wiki/Ninety-ninety_rule).

The HSoC is now complete, but `new-build` cannot replace the old interface yet:
a few essential features are missing, and --now that I'm more familiar with the
cabal codebase-- I plan to work on some of them even outside of the HSoC period.
[^bait]

<figure>
  <img src="/public/assets/simpson-murderhorn.jpg" alt="a small mountain, and a big mountain"/>
  <figcaption>`new-install` is the one <a href="https://www.youtube.com/watch?v=WPL1vf87dWY">just to the right</a></figcaption>
</figure>

### Finishing `new-install`

One point done, three to go.

There is a [design concept](https://github.com/haskell/cabal/issues/4558),
but there are a lot of details to figure out, for the libraries in particular.

### The aforementioned `garbage-collect`

The store can grow rapidly and reach several GB in size, so we need a way to
clean it up without influencing any built or installed package.

Again, there is a design concept on the [issue page](https://github.com/haskell/cabal/issues/3333).

### Flags for package maintainers

Before replacing old-build, we need to be sure that package maintainers
have still a way to control the location of binaries and data-files.

## Difficulties I encountered

### Big codebase

        > cloc cabal
        [...]
        Language          files      blank    comment       code
        --------------------------------------------------------
        Haskell            1273      24897      28127     120096


Cabal is big. Big project, big functions, big types, big everything.

My biggest Haskell project before HSoC was two orders of magnitude smaller,
and this was my first impact with a real-world project developed by a team
during an extended period of time.

<figure>
  <img src="/public/assets/interstellar-signature.png" alt="an Interstellar meme"/>
  <figcaption><a href="https://www.youtube.com/watch?v=Hwues9rwAIY"><em>[ORGAN INTENSIFIES]</em></a><!--[^pipes]--></figcaption>
</figure>

Haskell's strong types helped me a lot here. When I was working on `new-bench`,
I just "followed the types", and everything clicked on the first try,
[as the legends say](https://wiki.haskell.org/Why_Haskell_just_works).

### Lack of documentation

The cabal [bus factor](https://en.wikipedia.org/wiki/Bus_factor) is somewhat low.

Some parts of the codebase are completely devoid of comments, and we lack an
overview of the codebase, some document which describes how cabal works and
where to find certain parts.

Few mysterious entities, known as cabal devs,
are the precious holders of such arcane knowledge,
and to learn from them one must prove himself worthy of it by sheer
pinging-perseverance on #hackage

...fortunately they are always happy to give some pointers to newcomers :) .

<figure>
  <img src="/public/assets/dcoutts-sorcerer.jpg" alt="dcoutts as a sorcerer on cabal as a creature"/>
  <figcaption>
    In this rare photography we can see dcoutts (top) while he invokes
    a nix-style build on cabal (below)
  </figcaption>
</figure>

Moreover, the documentation is improving. The undocumented parts are mostly old
code, and there is an ongoing effort to cover that too.

And again, Haskell's types come to the rescue! The type always enhances and
often replaces the documentation in a more expressive way.

### Git

I now see that my git practices weren't the best...

<figure>
  <img src="/public/assets/xkcd-git_commit.png" alt="A messy git history"/>
  <figcaption>
    <p>well, not at <em>this</em> level, but...</p>
    <p><small>Credit: <a href="https://www.xkcd.com/1296/">xkcd</a> (CC BY-NC 2.5)</small></p>
  </figcaption>
</figure>

I had to learn git the _right_ way.

Coding alone is different than doing it in a team.
Until now I almost never had to deal with conflicts[^conflicts], and I almost
always worked only on master.

In the cabal repo, lots of features get merged very often
(well, more often than in a single user repo anyway),
so it's easy to get a conflict.
The history has to be kept clean, so I finally had to learn how to rebase
properly too.

This didn't always go well. In an attempt to rebase an old branch I accidentally
created a convoluted merge graph, almost impossible to disentangle.

<figure>
  <img src="/public/assets/merge-hell.png" alt="A very messy git history"/>
  <figcaption>
    Welp.
  </figcaption>
</figure>

Oh well, we learn from our errors.

I also had to exercise my multitasking skills by working on different branches.
While the tests for one branch were running, I could write the docs for another command. Or two.
The tests take a _long_ time.

Which takes us to...

### Continuous Integration

There's 4 hours worth of tests, from ghc 7.6 (cabal has a support window of
five years) to 8.2. And there are the FTP and the AMP in the middle.

<figure>
  <img src="/public/assets/xkcd-ci-is-running.png" alt="Two stick figures play with swords while ci runs"/>
  <figcaption><small>
    Credit: <a href="https://www.xkcd.com/303/">xkcd</a> (CC BY-NC 2.5)
  </small></figcaption>
</figure>

But this is a plus! Apart from the many sword fights, the tests helped me catch
a lot of bugs before even committing them. Now I use ci for many of my
personal projects too.

### Project planning and organization

I never had to do a fixed project on a strict schedule, and Daniel helped me
a lot here. If it wasn't for him I'll probably be trying to fix mostly
pointless bugs now. Planning time is not wasted time!

### Beware the paths!

One little thing: cabal now uses a slightly different path for built binaries.

My build command used the old one, and I wasted 1 hour or so trying to figure
out why my debug statements weren't printing anything.

This happened ~~two~~ three times.

You only need to worry about this if you use both pre- and post-2.0 new-build
in the same project though. While pre-2.0 puts the executables in
`dist-newstyle/build/package-id/build/exe/exe`,
post-2.0 puts them in
~~`dist-newstyle/build/os/compiler/package-id/build/exe/exe`~~
edit: this may change again before new-build becomes the default,
so just look it up in the docs or in your dist* folder.

## Good things

### Now I use new-build for all my Haskell projects!

Obviously I eat my own dog food now. And I like it.

In the next weeks I'll write a post about it,
specifically about how to integrate new-build and vim.

### HSoC itself

The Haskell Summer of Code has been a wonderful experience,
and I recommend it to every student who is reading this!

It taught me so much, and I loved being able to work on an open source project
as widely used as cabal (well, in the Haskell ecosystem at least :-P ).

### The Community

And last but absolutely not least, the #hackage community was always very
helpful and friendly, offering constructive criticism
and involving me in related projects.

## Acknowledgments

I'd like to thank the Haskell community, always friendly and striving for
knowledge; the organizers and sponsors, which made possible this HSoC;
and most of all the #hackage folks: 
[Daniel](http://dmwit.com/), my mentor, who helped me a lot
when I was lost in the code or when I needed to plan,
Duncan "dcoutts",
Herbert "hvr",
Mikhail "refold",
Edward "ezyang",
alanz, merijn, phadej, cocreature,
and any others who helped me along the way.

## Upcoming posts

* My new-build dev setup 
* The structure of cabal (I hope)
* Some more technical challenges I encountered


[^pipes]: This deserves a `pipes` pun
[^conflicts]: [Well, even when i did...](https://xkcd.com/1597/)
[^bait]: I'm beginning to suspect that the Haskell Summer of Code is just an evil scheme to lure some poor students to become permanent contributors to the Haskell ecosystem ;)
