+++
title = "SILE v0.15.12 Is Released"
date = "2025-04-11"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.12 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The last release went out with really obnoxious inverted logic for a deprecation message that spammed the terminal warning users when their usage of various modules was correct and up to date and *not* when they were using a deprecated interface.
This just puts the noise to rest.


### Bug Fixes

* **utilities:** Correct reversed deprecation warning condition ([a97c679](https://github.com/sile-typesetter/sile/commit/a97c6795426f12066ef8fbeb489fd936fe8b6daa)), closes [#2265](https://github.com/sile-typesetter/sile/issues/2265)

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.12
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.11...v0.15.12


