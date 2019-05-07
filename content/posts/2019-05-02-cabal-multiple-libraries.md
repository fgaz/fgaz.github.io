+++
title = "Multiple public libraries in a single Cabal package (GSoC 2018)"
slug = "2019-05-02-cabal-multiple-libraries"

[extra]
comments = true
language = "english"
tags = ["haskell", "cabal", "gsoc", "multiple public libraries", "multilibs"]
image = "https://www.haskell.org/cabal/images/Cabal-dark.png"
+++

TODO a summary

<!-- more -->

## Why

Large scale haskell projects tend to have a problem with lockstep distribution
of packages (especially backpack projects, being extremely granular). The unit
of distribution (package) coincides with the buildable unit of code (library),
and consequently each library of such an ecosystem (ex. amazonka) requires
duplicate package metadata (and tests, benchmarks…).

Having multiple libraries in a single package allows the separation of these
two concerns, and prevents redundant work and potential inconsistencies.

## How

### Exposing a sublibrary

To expose a sublibrary to other packages, simply add a `visibility: public`
field to your library stanza:

```cabal
library sublibname
    visibility: public
```

{% warn(title="for library authors") %}
  `cabal-install`'s solver isn't public-library-aware yet, and will happily
  choose to depend on a private library if it falls within the specified
  version range, so remember that making a library private is a **breaking**
  change, much like removing a function or module, and thus requires a
  **major version bump**, as per [the PVP](https://pvp.haskell.org/).
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
  `cabal-install`'s solver isn't public-library-aware yet, and will happily
  choose to depend on a private library if it falls within the specified
  version range, so remember to specify
  [correct version bounds](https://pvp.haskell.org/)
  when depending on sublibraries.

  Ensure that the lower bound is strict enough that older versions of the
  dependency where the sublibrary wasn't public / didn't exist are correctly
  excluded, and that the upper bound is strict enough to exclude breaking
  changes.
{% end %}

