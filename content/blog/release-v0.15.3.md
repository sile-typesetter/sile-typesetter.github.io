+++
title = "SILE v0.15.3 Is Released"
date = "2024-06-11"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.3 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release fixes a regression in [v0.15.0][] involving 3rd party modules.
We were not referencing the `LUA_PATH` (and `LUA_CPATH`) environment variables at run time, only at build thime.
This made it unreasonably difficult to install and use 3rd party modules to a user's `$HOME` directory and use them in SILE.
We were finding modules installed at the system level or locally to a project, but other trees were not being seen.

With this fix, installing modules via `luarocks --local install` should be a viable workflow again.
Before running SILE, make it aware of these modules with `eval $(luarocks --local path)`.
The same goes for any arbitrary `luarocks --tree` locations.

### Bug Fixes

* **core:** Allow LUA_PATH env var to take effect at runtime ([e573c2d](https://github.com/sile-typesetter/sile/commit/e573c2d2026f5d194bfb0f0ea67f21d3728fafcb))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.3
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.2...v0.15.3
  [v0.15.0]: @/blog/release-v0.15.0.md
