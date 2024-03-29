+++
aliases = ["2020/02/sile-0-10-3-is-released"]
title = "SILE v0.10.3 Is Released"
date = "2020-02-04"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.3 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release is essentially the same as v0.10.2, but with all the Lua module dependencies bundled again.
The previous release would only build either with system provided Lua dependencies or with internet access to download them via luarocks; it was not fully self contained and hence could not be built on some systems.

### Notable Bug Fixes

* **tooling:** Make sure Lua modules get included in source tarball ([ef5bb53](https://github.com/sile-typesetter/sile/commit/ef5bb53e73204bed18edf89aa3aac67ef15846a2))
* **tooling:** Unblock standard-version release number bumping ([7b18cd5](https://github.com/sile-typesetter/sile/commit/7b18cd5decbc94879fd752c601cc73e25e41e8d6)), closes [#816](https://github.com/sile-typesetter/sile/issues/816)

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.3
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.2...v0.10.3
  [wiki]: https://github.com/sile-typesetter/sile/wiki
