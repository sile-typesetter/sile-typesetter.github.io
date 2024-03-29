+++
aliases = ["2022/06/sile-0-13-1-is-released"]
title = "SILE v0.13.1 Is Released"
date = "2022-06-18"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.13.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Hot on the heals of a major release we have small one to patch up some odds and ends.
Thanks to [Fredrick Brennan](http://github.com/ctrlcctrlv) for correcting my oversight in not distributing some of the new localization files.
If by chance you’ve on a new fangled hardware platform like RISC-V things should build out of the box now.
The documentation for installation on various systems has also been cleaned up.
Thanks to [Didier Willis](http://github.com/Omikhleia) for some new rule functions and fixes to old ones plus leader alignment corrections.

### Features

* **build:** Update libtexpdf to support new hardware platforms ([da1182e](https://github.com/sile-typesetter/sile/commit/da1182ec3601d9a4ea5b2529c6d0de4108bbf211))
* **packages:** Add hrulefill command to the "rules" package ([ccd3371](https://github.com/sile-typesetter/sile/commit/ccd3371aafa4f314c9d2a967106e03c373cf1a35))
* **packages:** Add strikethrough command to the rules package ([#1422](https://github.com/sile-typesetter/sile/issues/1422)) ([f230a3a](https://github.com/sile-typesetter/sile/commit/f230a3aae72cf84075623165ce6ded0c9aa2bdd0))
* **packages:** Use new strikethrough when rendering Panndoc's SILE writer ([20d19eb](https://github.com/sile-typesetter/sile/commit/20d19eb849307a1067006a595b2e4f2b92e53112))


### Bug Fixes

* **build:** Make sure i18n/ dir is actually distributed ([#1445](https://github.com/sile-typesetter/sile/issues/1445)) ([61ed8e1](https://github.com/sile-typesetter/sile/commit/61ed8e13eee3c2f5f802605a9da5f25ad0040164))
* **packages:** Add more props to keep CJK from tipping over, per [#1245](https://github.com/sile-typesetter/sile/issues/1245) ([381b9f1](https://github.com/sile-typesetter/sile/commit/381b9f14d10e1bbcf0b117642c4c13e3dcd4c620))
* **packages:** Leaders shall be an explicit (non-discardable) glue ([631ba21](https://github.com/sile-typesetter/sile/commit/631ba21c182389dd5a68241a36d1eb4fb13c895b))
* **packages:** The fullrule now extends over a full standalone line ([8fe57c8](https://github.com/sile-typesetter/sile/commit/8fe57c844f2a093d7abe35dfe6c63d5df5ab7115))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.13.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.13.0...v0.13.1
