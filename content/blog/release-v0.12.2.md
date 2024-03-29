+++
aliases = ["2022/01/sile-0-12-2-is-released"]
title = "SILE v0.12.2 Is Released"
date = "2022-01-28"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.12.2 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This patch release is to fix a regression in handling negative width spaces — something that turn up when typesetting [Nastaliq](https://en.wikipedia.org/wiki/Nastaliq).
Thanks to first-time contributor Michael Brown for both the report and fix.
Also the documentation for the dropcap package added in the last release is now in the manual.
The only other thing possibly worth noting is that the prebuilt Docker images now run on the recently released Lua 5.4.4.


### Bug Fixes

* **shaper:** Fix line length calcs with negative width word spacing ([685d12d](https://github.com/sile-typesetter/sile/commit/685d12dc71797d69c7f24a6c6ced0d47dc404704)), closes [#579](https://github.com/sile-typesetter/sile/issues/579)


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.2
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.1...v0.12.2
