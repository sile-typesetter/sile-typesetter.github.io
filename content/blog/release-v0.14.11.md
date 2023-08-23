+++
title = "SILE v0.14.11 Is Released"
date = "2023-08-22"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.11 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Today we only fix the things we broke yesterday.
This is a very minor release with only a couple of touch-ups to actual code.
The biggest motivation for the release is actually the documentation.
Our documentation changes don't show up in the automatic change logs, but we fixed a number of problems with the layout of the manual.
Over the last couple releases we introduced several mistakes in the documentation code causing a bit of mess.
The manual still isn't perfect, but at least no bits are drawn over other bits any more!


### Bug Fixes

* **core:** Leave legacy masterFilename alone but use first input filename internally ([29667a7](https://github.com/sile-typesetter/sile/commit/29667a752181dd40abe18672f6175fe10a9c5546))
* **core:** Make masterFilename actually a filename ([759131e](https://github.com/sile-typesetter/sile/commit/759131e6c87517b56a433dccde29658dbe6df023))
* **packages:** Avoid mix-and-matching indents in fixed-width specimin blocks ([de41cac](https://github.com/sile-typesetter/sile/commit/de41cac06a911e7c56f0ba4d1248a6da5999e6f3))
* **utilities:** Use real semver parser for deprecation warnings ([5f0fed5](https://github.com/sile-typesetter/sile/commit/5f0fed51b2a9597272da62f00c15f8836f8c7bd1))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.11
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.10...v0.14.11
