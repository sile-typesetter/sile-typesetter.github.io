+++
aliases = ["2020/04/sile-0-10-4-is-released"]
title = "SILE v0.10.4 Is Released"
date = "2020-04-21"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.4 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Most of the changes in this release are either related to the tooling to build and package it smoothly or minor. Some English users might appreciate that their Table of Contents headers for otherwise English books aren’t localized in Turkish, and Japanese users will have an easier time with their Tate layouts because they cooperate with the new measurement systems introduced in v0.10.

Not properly mentioned in the ChangeLog is a tweak that allows *Glues* to be cast to *Lengths*. This makes it much easier to create measurements based on existing nodes as references.

### Notable Bug Fixes

* **build:** Fix version detection in sparse git checkouts ([#803](https://github.com/sile-typesetter/sile/issues/803)) ([#818](https://github.com/sile-typesetter/sile/issues/818)) ([dcd0023](https://github.com/sile-typesetter/sile/commit/dcd00236f20a70e2610319441b4bb4c10b96cc02))
* **core:** Return correct length from icu.bidi_runs with surrogate pairs ([000515f](https://github.com/sile-typesetter/sile/commit/000515fccd68f7467ee199c064634d4ce25bfc18)), closes [#839](https://github.com/sile-typesetter/sile/issues/839)
* **docker:** Work around fresh GNU coreutils bombing Docker Hub ([#851](https://github.com/sile-typesetter/sile/issues/851)) ([ed49fbb](https://github.com/sile-typesetter/sile/commit/ed49fbbf1128c03f3e4358d89086f16cbd786be6))
* **languages:** Localize TOC title functions ([#849](https://github.com/sile-typesetter/sile/issues/849)) ([1ab4345](https://github.com/sile-typesetter/sile/commit/1ab434582aa3f555212f021cc47ad5d354a570b8))
* **packages:** Update PDF package to use correct measurement types ([79e24ca](https://github.com/sile-typesetter/sile/commit/79e24ca71bef1f3d5b2f9e978bbef1bb8a5a5b03))
* **packages:** Update Tate package to use correct measurement types ([180024f](https://github.com/sile-typesetter/sile/commit/180024f29c3002317a27df042139ae97b79907ad))
* **tooling:** Add missing lua-cosmo dependency for Markdown class ([#822](https://github.com/sile-typesetter/sile/issues/822)) ([ea81598](https://github.com/sile-typesetter/sile/commit/ea815984d27d15770613a57f019284136fbf3bbd))
* **typesetter:** Make `typesetter.breakwidth` a measurement ([721280d](https://github.com/sile-typesetter/sile/commit/721280dde51d834ab170efb75eba73771f5cda59))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.4
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.3...v0.10.4
  [wiki]: https://github.com/sile-typesetter/sile/wiki
