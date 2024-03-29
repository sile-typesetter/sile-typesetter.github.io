+++
aliases = ["2020/10/sile-0-10-12-is-released"]
title = "SILE v0.10.12 Is Released"
date = "2020-10-10"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.12 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release fixes just two bugs.
The simpler of the stops custom styles in verbatim blocks.
Much more urgently, a backend fix correctly accounts for offsets calculated during the shaping process and stops resetting the PDF cursor position.
This issue primarily broke Arabic, but typesetting any fonts with cursive positioning or mark placement rules were affected.

### Bug Fixes

* **backends:** _drawString should take an offset ([#1079](https://github.com/sile-typesetter/sile/issues/1079)) ([594ae03](https://github.com/sile-typesetter/sile/commit/594ae03676680f6caa63a016ab72e3341774ba35)), closes [#1078](https://github.com/sile-typesetter/sile/issues/1078)
* **packages:** \verbatim:font can process text ([#1076](https://github.com/sile-typesetter/sile/issues/1076)) ([eb4fb1a](https://github.com/sile-typesetter/sile/commit/eb4fb1a37f060bb34dcb3c7f34e9d95b6e07613c))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.12
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.11...v0.10.12
  [wiki]: https://github.com/sile-typesetter/sile/wiki
