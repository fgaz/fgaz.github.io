+++
title = "Multiple public libraries in a single Cabal package (GSoC 2018)"
slug = "2019-11-14-cabal-multiple-libraries"

[extra]
comments = true
language = "english"
tags = ["haskell", "cabal", "gsoc", "multiple public libraries", "multilibs"]
image = "https://www.haskell.org/cabal/images/Cabal-dark.png"
+++

In summer 2018, during my last GSoC, I developed
the "multiple public libraries in a single package" Cabal feature.
In this long overdue post I explain why and how to use the feature.

<!-- more -->

2022-08-11: The post was updated in light of the cabal 3.8.1.0 release.

## Why

Large scale Haskell projects tend to have a problem with lockstep distribution
of packages (especially backpack projects, being extremely granular). The unit
of distribution (package) coincides with the buildable unit of code (library),
and consequently each library of such an ecosystem (ex. amazonka) requires
duplicate package metadata (and tests, benchmarks…).

Having multiple libraries in a single package allows the separation of these
two concerns, and prevents redundant work and potential inconsistencies.

## How

To use the multiple public libraries feature you need at minimum
Cabal&gt;=3.0.0.0 **and** GHC&gt;=8.8[^old-ghc].

{% warn(title="Multiple public libraries in cabal<3.8 are buggy!") %}
Many of the bugs listed at
https://github.com/haskell/cabal/issues/5660
are not fixed in cabal&lt;3.8.
To avoid problems, if you are using an older version consider upgrading to
3.8.1.0 or later.
{% end %}

The feature was introduced with the `.cabal` spec version 3.0, so you'll have to
have at least `cabal-version: 3.0` in your `.cabal` file.
If you are starting a new project you can use `cabal init --cabal-version=3.0`
(or later).

### Exposing a sublibrary

To expose a sublibrary to other packages, simply add a `visibility: public`
field to your library stanza:

```cabal
library sublibname
    visibility: public
```

{% note(title="remember to signal breaking changes") %}
  While `cabal-install`'s solver is aware of public libraries, and `Setup.hs`
  will give proper errors when trying to depend on a private library, it's still
  a good idea to perform a
  [**major version bump**](https://pvp.haskell.org/)
  when changing the visibility
  of a library from `public` to `private`.
{% end %}

### Depending on a public sublibrary

To depend on a public sublibrary, add the package it belongs to to your
dependencies, followed by a `:`, followed by the name of the sublibrary:

```cabal
executable my-exe
    build-depends: packagename:sublibname >=1.0 && <1.1
```

If you omit the `:sublibname` part, you are specifying a dependency on the
main (unnamed) library, so you don't need to change existing dependencies.

You can explicitly depend on the main library by using the package name as
sublibrary name (this is mostly needed when depending on multiple sublibraries
in a single line, see next paragraph):

```cabal
executable my-exe
    build-depends: packagename:packagename >=1.0 && <1.1
```

When depending on multiple libraries belonging to a single package you can also
use this shorthand syntax:

```cabal
executable my-exe
    build-depends: packagename:{lib1, lib2} >=1.0 && <1.1
```

which is equivalent to

```cabal
executable my-exe
    build-depends: packagename:lib1 >=1.0 && <1.1
    build-depends: packagename:lib2 >=1.0 && <1.1
```

{% note(title="remember to specify correct version bounds") %}
  While `cabal-install`'s solver will rule out package versions that don't
  provide the required libraries, it's still a good idea to enforce that with
  [version bounds](https://pvp.haskell.org/).

  Ensure that the lower bound is strict enough that older versions of the
  dependency where the sublibrary wasn't public / didn't exist are correctly
  excluded, and that the upper bound is strict enough to exclude breaking
  changes.
{% end %}

## Known bugs

Known bugs and missing features are tracked at
[https://github.com/haskell/cabal/issues/5660](https://github.com/haskell/cabal/issues/5660).

## Acknowledgements

Of course this wouldn't have been possible without the help of my mentors,
Mikhail and Edward, and many other members of the Haskell community.
Thanks to all!

## Links

* [Ticket for the feature](https://github.com/haskell/cabal/issues/4206)
* [Pull request](https://github.com/haskell/cabal/pull/5526)
* [Final report](https://github.com/fgaz/gsoc/blob/master/2018/final-report.md)

## Footnotes

[^old-ghc]: Older GHCs are not able to properly store the visibility of
a library, so with GHC&lt;8.8 all sublibraries will be treated as private.
