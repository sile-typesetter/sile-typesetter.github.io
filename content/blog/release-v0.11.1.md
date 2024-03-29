+++
aliases = ["2021/09/sile-0-11-1-is-released"]
title = "SILE v0.11.1 Is Released"
date = "2021-09-03"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.11.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Today’s small patch release is mostly to help out downstream packagers with some small issues that cropped up.
First it’s a stab in the dark hoping we made things easier to get Homebrew packaging working on ARM based macOS.
Secondly we added a build time check for `git`, which is required in order to use SILE’s internal package manager.
This dependency may change in the future, but since we use it now it’s helpful that system compatibility is checked at build time.
Lastly we fixed up some internal usage of an API we deprecated 6 releases ago and documented as going away in v0.11.0, but forgot to stop using ourselves.
Notably the French language support module was affected.

### Bug Fixes

* **build:** Avoid implied line continuation in makefile ([f2af48f](https://github.com/sile-typesetter/sile/commit/f2af48f2157f5727369f1ad4e049c84ae10af5ea))
* **build:** Require Git even building tarballs, used by package manager ([aba8662](https://github.com/sile-typesetter/sile/commit/aba86623034ff2a6eee2b8883865e1985f8152e3))
* **languages:** Update deprecated syntax in language options ([3fb1719](https://github.com/sile-typesetter/sile/commit/3fb1719ddab00f4aded435213393b09b98e83342))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.11.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.11.0...v0.11.1
