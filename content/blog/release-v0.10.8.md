+++
aliases = ["2020/07/sile-0-10-8-is-released"]
title = "SILE v0.10.8 Is Released"
date = "2020-07-19"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.8 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release addresses the Docker builds which came out broken in the previous release.
Some Lua modules shuffled to make way for Lua 5.4 support (which is almost ready, just waiting on one more upstream dependency).
Additionally some build issues on BSD have been smoothed over.

Note I accidentally pushed this release tag along with a bad commit that was never supposed to be released.
Hence the v0.10.8 tag was briefly attached to a different commit (but with no packages attached).
I apologize for any inconvenience for any inconvenience this caused.

### Features

* **build:** Output hints about how to compile from repo snapshots ([596cd9f](https://github.com/sile-typesetter/sile/commit/596cd9f27cd24237d863ffde7725e95186da04fb))


### Bug Fixes

* **build:** Avoid possible race condition on first bulid ([b937c95](https://github.com/sile-typesetter/sile/commit/b937c9509e86aeec25ee1db9c0726151e3214d82))
* **build:** Use BSD compatible find syntax ([c96683e](https://github.com/sile-typesetter/sile/commit/c96683ef5d015ccc540214acb8b20a86f8e0ae78))
* **build:** Use BSD compatible touch syntax ([25eb6fd](https://github.com/sile-typesetter/sile/commit/25eb6fda81eb6ad9c0afc4e656eca0a31620ed00))
* **docker:** Make sure Lua modules installation works on the first pass ([f0c3e26](https://github.com/sile-typesetter/sile/commit/f0c3e2683d78de82d2395dcd0a6c5ca5d1d4081b))


### Performance Improvements

* **build:** Save a ./configure cycle by bootstraping the version ([2997d05](https://github.com/sile-typesetter/sile/commit/2997d05d433492633dc6db68032ded1ef91edd1c))


### Reverts

* Revert "chore(build): Save a double-configure on first download/build" ([ef56de4](https://github.com/sile-typesetter/sile/commit/ef56de4114faf8c95e9da7c7c1d258b6221a086c))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.8
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.7...v0.10.8
  [wiki]: https://github.com/sile-typesetter/sile/wiki
