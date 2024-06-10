+++
title = "SILE v0.15.1 Is Released"
date = "2024-06-08"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The big [v0.15.0 release][v0.15.0] had some rough edges.
First the source tarball was missing a vendored source file needed to build against some Lua versions.
This did not affect building from Git sources, but made downstream distro packaging difficult.
Additionally the now completely removed legacy package manager was still asking for Git as a run time dependency, which is now obsolete.

Also the big changes to the way SIL sources are parsed revealed several order bugs in the book class.
These were visible even in the SILE manual as a regression in the way indentation was (not) suppressed after chapters and sections.
This was all cleaned up and hopefully paragraph handling is a bit more logical now.
Note that per the breaking changes in [v0.15.0][] custom implementations of these functions will need to be adapted the same way.

### Bug Fixes

* **build:** Distribute vendored compat-5.3.c source file ([3c469d6](https://github.com/sile-typesetter/sile/commit/3c469d680b1f0ac78c340c65bf2693431569ee39))
* **build:** Remove Git from configure dependencies ([352a125](https://github.com/sile-typesetter/sile/commit/352a125e7dd2d63abc854c456bee1ed1e97a5e38))
* **classes:** Correct order of operations when paragraphs are ended manually ([08f1a7b](https://github.com/sile-typesetter/sile/commit/08f1a7ba8284ec571ea47c537257f0a1a93c6704))
* **packages:** Change retrograde package so 'target' version works as expected ([6ad9b76](https://github.com/sile-typesetter/sile/commit/6ad9b762c6cdd2f164c7e343c8a5b3ebbf13d717))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.0...v0.15.1
  [v0.15.0]: @/blog/release-v0.15.0.md
