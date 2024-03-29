+++
aliases = ["2021/02/sile-0-10-14-is-released"]
title = "SILE v0.10.14 Is Released"
date = "2021-02-03"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.14 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release introduces a new dependency on an external Lua UTF-8 string handling [library][luautf8]. By introducing proper string handling instead of our home grown functions we knocked out several bugs including invalid encoding in the output when error tracing was turned on. We also added some (ironically, home grown) UTF-16 string handling to sanitize output of Font meta data.

### Features

* **core:** Make luautf8 library available in global scope ([ab7e745](https://github.com/sile-typesetter/sile/commit/ab7e74574c8c624f2a54d6d9e07bf7e6b98e0c98))

### Bug Fixes

* **build:** Run autoupdate to fix autoconf issues ([ab8307b](https://github.com/sile-typesetter/sile/commit/ab8307b407a7e23f336628ece6c9adb50391bdb3))
* **core:** Decode UTF-16BE strings in Windows platform name entries ([e7662f8](https://github.com/sile-typesetter/sile/commit/e7662f84064ef4c96261373e66a8d2268bbcd0d3))
* **debug:** Use UTF8 safe substring function in trace stack ([495a5bf](https://github.com/sile-typesetter/sile/commit/495a5bf7c4dd8a5d2de18c71f873ce1852fe0d7f))
* **manual:** Small error ([d738b62](https://github.com/sile-typesetter/sile/commit/d738b62e95a54acf69459f805009ff90a45653a5))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.14
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.13...v0.10.14
  [luautf8]: https://luarocks.org/modules/xavier-wang/luautf8
