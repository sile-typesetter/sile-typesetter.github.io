+++
title = "SILE v0.15.13 Is Released"
date = "2025-05-31"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.13 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Work on v0.16 is well underway including *finally* refactoring the internal module layout for languages, frames, fonts, font managers, and much more.
But in the meantime less dramatic (and less disruptive) improvements have accumulated.

[Didier Willis](http://github.com/Omikhleia) has touched up CSL support and added support for position tracking.
[Sunniva Løvstad](http://github.com/turtlegarden) sent in some updates to Norwegian localization.
I fixed up some handling of unset settings, kept reloading modules from re-registering commands, and sped up development cycles by enabling a debug mode that skips time consuming build time optimizations.


### New Features

* **packages:** Add position tracking for bibliography citations ([5930a0c](https://github.com/sile-typesetter/sile/commit/5930a0c3cd6126f0417dba4a7f15f076faaf1213))
* **packages:** Support the position condition in CSL engine ([0c732a2](https://github.com/sile-typesetter/sile/commit/0c732a273dfcf19a59fca7a9b87443434d8e326c))


### Bug Fixes

* **build:** Pass --enable-debug through to Cargo to actually get a debug-enabled binary ([443551a](https://github.com/sile-typesetter/sile/commit/443551a3ed25ca2cb1c5ea81c353462570fe20a3))
* **fonts:** Properly account for settings allowed to be nil ([792518e](https://github.com/sile-typesetter/sile/commit/792518eb8d238428fe7e5af4d933e21280ddada5))
* **languages:** Update Bokmål messages ([a10e0f4](https://github.com/sile-typesetter/sile/commit/a10e0f4604f107d71d53002a9caa9f6d3d141706))
* **languages:** Update Nynorsk messages ([4ec6654](https://github.com/sile-typesetter/sile/commit/4ec66548c6b12244da297686b7818b84f8130c74))
* **packages:** Add missing boolean coercion for strip-periods in CSL engine ([5af2842](https://github.com/sile-typesetter/sile/commit/5af284207fb3b1c50695a84cb08001df92f761b2))
* **packages:** Always apply punctuation-in-quotes in CSL citations ([689c8e2](https://github.com/sile-typesetter/sile/commit/689c8e23e8346d302b4352baab99510423aa51f3))
* **packages:** Fine-tune CSL post-rendered cleaning hacks ([487f3f0](https://github.com/sile-typesetter/sile/commit/487f3f0cc528048ced2a8e226ca51642b5fc6648))
* **packages:** Fix package reload to not call for command reregistration unless asked ([41846f7](https://github.com/sile-typesetter/sile/commit/41846f73eaa61fa4cf27127743ff6c9724f2a282))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.13
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.12...v0.15.13


