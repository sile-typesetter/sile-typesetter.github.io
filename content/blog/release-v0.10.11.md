+++
aliases = ["2020/09/sile-0-10-11-is-released"]
title = "SILE v0.10.11 Is Released"
date = "2020-09-25"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.11 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release supports versions of Lua Penlight *newer* than 1.8.0.
Previous releases of Penlight have contained a long-standing bug in the class inheritance system that we were side-stepping with our own workaround.
In one case our workaround was actually relying on a side-effect of said Penlight bug and never should have worked.
With a proper fix finally implemented in Penlight, our workaround started to fail.
This release includes an emergency patch so that SILE can be made to work on systems with the latest Penlight release.
Future releases will likely remove our workarounds entirely and *require* a recent version of Penlight with the fixed class inheritance system.

Additionally, this is the first release that officially supports running SILE *as* a GitHub Action.
You can now call SILE directly in CI workflows on your own projects.

Other cleanup work now allows classes to specify their own framesets without inheriting the default ones.
This has no visible effect for most documents but it does make debugging framesets a lot easier because there aren’t a bunch of empty frames behind the scenes inherited from other classes.

With special thanks to contributions from [Fredrick Brennan](http://github.com/ctrlcctrlv),
SVG support is much improved in this release.
Specifically, shapes with holes now actually render as holes.
Also, thanks to [Johannes Maibaum](https://github.com/jmaibaum)’s contributions and careful eye,
many examples from the manual which had fallen behind or had typos now actually work as documented.

### Features

* **actions:** Add configuration file to run as GitHub Action ([ee2d509](https://github.com/sile-typesetter/sile/commit/ee2d50992f2209f7c871acf4983d4267f5c5cc87))
* **backends:** Modify setCursor() to handle relative movements ([7caa9c8](https://github.com/sile-typesetter/sile/commit/7caa9c82bbf0bd021e316893ffb2b2693ceeac55))
* **classes:** Make it possible to not use parent class framesets ([99b9f50](https://github.com/sile-typesetter/sile/commit/99b9f506954298dbc4ceabe4197609a7c5ac70f2))
* **cli:** Add Lua interpreter info to --version ([bf5210d](https://github.com/sile-typesetter/sile/commit/bf5210d17259591d95042109dedafc693b60d199))


### Bug Fixes

* **backends:** Properly switch between normal and debug fonts ([b53896e](https://github.com/sile-typesetter/sile/commit/b53896e1fea42f639074f0bba40504ba85eda19c))
* **classes:** Identify triglot class as triglot not diglot ([495654a](https://github.com/sile-typesetter/sile/commit/495654ac5d180af09ba9e71461ab78a6af43a1dc))
* **classes:** Make declareFrames() workable by passing ids ([27b6b4a](https://github.com/sile-typesetter/sile/commit/27b6b4abfe8f54d2b6360b51b2de1ca7d152608e))
* **classes:** Move class setup code into deferred class:init() ([6f470d7](https://github.com/sile-typesetter/sile/commit/6f470d70e2774c98971a78a581439361f98891e6))
* **core:** Patch Penlight 1.9.0 compatibility issue ([1eb4290](https://github.com/sile-typesetter/sile/commit/1eb42909dee1e9946316b7acf357b38677f34b2a))
* **packages:** Allow Hanmen frame creation to use optional ID arg ([7853d5a](https://github.com/sile-typesetter/sile/commit/7853d5a398d6ce18a9dbec67873091af110b596a))
* **packages:** Fix hole drawing from svg in PDF ([6521fd0](https://github.com/sile-typesetter/sile/commit/6521fd0323d03eea1437a11876f1d4c10f8c17d5))
* **packages:** Remove extra space in \code in url ([b90cd37](https://github.com/sile-typesetter/sile/commit/b90cd376c81615fec9d9c076b399c94951dc1f60)), closes [#1056](https://github.com/sile-typesetter/sile/issues/1056)
* **tooling:** Expand variables so fonts are known dependencies of tests ([88ac888](https://github.com/sile-typesetter/sile/commit/88ac88805c138397d7cf94f8b7864d65956a7e13))


### Performance Improvements

* **backends:** Reuse variables instead of recalculating values ([02cce40](https://github.com/sile-typesetter/sile/commit/02cce408c209fd59fbd531d2e8bdd4625964c4ee))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.11
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.10...v0.10.11
  [wiki]: https://github.com/sile-typesetter/sile/wiki
