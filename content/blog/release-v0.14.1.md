+++
title = "SILE v0.14.1 Is Released"
date = "2022-08-06"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

These few quick touch-ups smooth over last minute bugs and ease the transition process from v0.13.x.
Besides squashing a pointless warning messages and some bug fixes, this changes the order deprecated includes are processed to facilitate the transition of old projects to new APIs by making it easier to update them one bit at a time.

### Features

* **inputters:** Expand postamble functionality for parity with preambles ([#1518](https://github.com/sile-typesetter/sile/issues/1518)) ([eb09eb3](https://github.com/sile-typesetter/sile/commit/eb09eb34581ae68b4153d3725cefb34fa46643c2))

### Bug Fixes

* **cli:** Suppress deprecation message for internal shims ([b339e27](https://github.com/sile-typesetter/sile/commit/b339e27ab71dcba57e275e6ec8b8daa799324f36))
* **cli:** Swap order of new --uses and legacy --include ([ef0087e](https://github.com/sile-typesetter/sile/commit/ef0087e7e1f9b7eef623597e9c82e87ca8f5a3d5))
* **packages:** Correct (and improve scope of) exported testcase functions ([fd438e9](https://github.com/sile-typesetter/sile/commit/fd438e983afbae2192a4f109eef748d9329abf30))
* **tooling:** Make sure Git version detection only picks up semver tags ([25d669a](https://github.com/sile-typesetter/sile/commit/25d669a2be5ef1d8a1b4c08b3173ec199e0bedcc))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.0...v0.14.1
