---
layout: post
comments: true
language: english
title: GSoC 2018 weekly statuses
tags: [haskell,gsoc,2018,google summer of code,status,cabal,multiple libraries]
image: /public/assets/gsoc-logo-square.png
---

**I will update this post every week or two with my current status.
See also [github.com/haskell/cabal/projects/5](https://github.com/haskell/cabal/projects/5)**

<del>
I'm pushing the code on the [multiple-libraries](https://github.com/fgaz/cabal/tree/multiple-libraries) branch on my fork of the cabal repo.

## Updates

### Community bonding period

* Some initial planning
* Reading [#3022](https://github.com/haskell/cabal/pull/3022) and experimenting
  with the code

### Coding period

#### First week

This was the first time I really dwelt into the `Cabal` code,
as I previously mostly worked on `cabal`-the-tool.
`Cabal` (the capital "C" one) is the foundation on which most haskell build
tools are based on (yes, `stack` included), so every little change has a ripple
effect.

* Added a `public :: Bool` field to the library stanza
* Working on modifying the `Dependency` datatype
  from `Dependency PackageName VersionRange`
  to ~~`Dependency PackageName VersionRange [UnqualComponentName]`~~
  `Dependency PackageName VersionRange (Set UnqualComponentName)`
  * Added a temporary syntax for named library selection
    (see [#4206](https://github.com/haskell/cabal/issues/4206)
    for syntax discussion)
    `build-depends: pkgname versionRange {library1,library2}`
* Testing for regressions in `Cabal`

---

Check back for more!
</del>

EDIT: sorry, I couldn't keep it updated. Check back when the results are announced

