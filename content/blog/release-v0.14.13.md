+++
title = "SILE v0.14.13 Is Released"
date = "2023-10-30"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.13 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This minor release brings a couple improvements from a new contributor, [João Quinaglia](https://github.com/jodros).
We have one new feature, a boolean option flag on our base class that enables landscape mode.
Any paper orientation has been supported already, but the preset paper sizes only had the standard portrait orientation and landscape orientations required entering custom dimensions.
This flag makes it a bit easier to swap the X and Y dimensions of the standard (or custom) value parsed from the *papersize* option.
Additionally he fixed a bug in the *frametricks* package such that using the `\makecolumns` function doesn't break relative frame constraints used by, for example, footnote or folio frames.
This fix only works for TTB-LTR automatic column setups for now.

Finally, some build system fixes and features were backported from v0.15.0 development work.
Most significantly the handling of the `SILE_PATH` environment variable now allows multiple paths, which in turn allows a single project to utilize multiple external *collections* of 3rd party packages rather than having to collate them all into one location.


### Features

* **classes:** Add landscape option to base class ([#1892](https://github.com/sile-typesetter/sile/issues/1892)) ([0fb9ade](https://github.com/sile-typesetter/sile/commit/0fb9adefca3adf9ff8a56755e69474960792d85a))
* **cli:** Allow multiple runtime SILE_PATH segments (backport from develop branch) ([e7c8fe2](https://github.com/sile-typesetter/sile/commit/e7c8fe219686aa327032154484bf78be86c0baaa))


### Bug Fixes

* **frames:** Update frame constraints with new frame IDs after \makecolumns ([b2d6b4f](https://github.com/sile-typesetter/sile/commit/b2d6b4f7b095d74f3d39123904495a8e024c0f05))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.13
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.12...v0.14.13
