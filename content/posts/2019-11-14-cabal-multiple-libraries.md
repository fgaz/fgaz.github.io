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

## Why

Large scale Haskell projects tend to have a problem with lockstep distribution
of packages (especially backpack projects, being extremely granular). The unit
of distribution (package) coincides with the buildable unit of code (library),
and consequently each library of such an ecosystem (ex. amazonka) requires
duplicate package metadata (and tests, benchmarks…).

Having multiple libraries in a single package allows the separation of these
two concerns, and prevents redundant work and potential inconsistencies.

## How

To use the multiple public libraries feature you need Cabal&gt;=3.0.0.0
**and** GHC&gt;=8.8[^old-ghc].

The feature was introduced with the `.cabal` spec version 3.0, so you'll have to
have at least `cabal-version: 3.0` in your `.cabal` file.
If you are starting a new project you can use `cabal init --cabal-version=3.0`.

### Exposing a sublibrary

To expose a sublibrary to other packages, simply add a `visibility: public`
field to your library stanza:

```cabal
library sublibname
    visibility: public
```

{% warn(title="for library authors") %}
  `cabal-install`'s solver isn't public-library-aware yet, and until
  [#6047](https://github.com/haskell/cabal/pull/6047) is merged it will happily
  choose to depend on a private library if it falls within the
  specified version range, and then it will fail at the configure step.
  To keep things working smoothly,
  remember that making a library private is a **breaking** change,
  much like removing a function or module,
  and thus requires a **major version bump**,
  as per [the PVP](https://pvp.haskell.org/).
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
sublibrary name (this is mostly needed when depending on multiple sublibraries,
see next paragraph):

```cabal
executable my-exe
    build-depends: packagename:packagename >=1.0 && <1.1
```

When depending on multiple libraries from a single package you can also use this
syntax:

```cabal
executable my-exe
    build-depends: packagename:{lib1, lib2} >=1.0 && <1.1
```

{% warn(title="for all developers when depending on an external sublibrary") %}
  `cabal-install`'s solver isn't public-library-aware yet, and until
  [#6047](https://github.com/haskell/cabal/pull/6047) is merged it will happily
  choose to depend on a private library if it falls within the specified
  version range, and then fail at the configure step.
  To keep things working smoothly,
  remember to specify [correct version bounds](https://pvp.haskell.org/)
  when depending on sublibraries.

  Ensure that the lower bound is strict enough that older versions of the
  dependency where the sublibrary wasn't public / didn't exist are correctly
  excluded, and that the upper bound is strict enough to exclude breaking
  changes.
{% end %}

## Known bugs

There are a few minor bugs in the implementation. They are mostly edge cases,
but it's good to know about them:

* [#6038](https://github.com/haskell/cabal/issues/6038):
  To have sublibraries, a package must also have
  a main (nameless) library.
  The main library can be empty:
  ```
  […other attributes/stanzas…]

  library

  […other attributes/stanzas…]
  ```
* [#6083](https://github.com/haskell/cabal/issues/6083):
  Due to a bug in the handling of qualified and unqualified
  dependency syntaxes, internal libraries (sublibraries of the same package)
  will take priority over external packages with the same name.
  So, if you have an internal library `somelib`,
  you won't be able to depend on a package named `somelib`,
  even if you use the `somelib:somelib` syntax.
* [#5846](https://github.com/haskell/cabal/issues/5846):
  In some cases, omitting the version bounds causes a parsing failure.

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

