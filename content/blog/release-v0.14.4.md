+++
title = "SILE v0.14.4 Is Released"
date = "2022-09-01"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.4 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Today we have a small rollup of fixes and improvements.
[Didier Willis](https://github.com/Omikhleia) overhauled the counters packages as well as fixed up bugs in several other packages.
The default center of rotation has been changed to give a more expected result.
Text casing functions are accessible again from the Lua side of things, changing masters during a page output doesn't break page breaking, and using the twoside package doesn't force the use of mirroring.
[Olivier Nicole](https://github.com/OlivierNicole) also stepped in to fixup some math bugs.
Also thanks to [Jeremy Steward](https://github.com/ThatGeoGuy) and [Sandra Snan](https://github.com/snan) for pointing out and fixing small issues in our documentation.


### Features

* **packages:** Add boolean noleadingzeros option to counter formatter ([e4f8133](https://github.com/sile-typesetter/sile/commit/e4f813333e935ce0e42727eba407db2f7273391d))
* **packages:** Add new command \set-multilevel-counter ([11578a8](https://github.com/sile-typesetter/sile/commit/11578a81b4abde4652baefe969e4e79905ff7639))


### Bug Fixes

* **classes:** Always break out of hmode before processing \chapter headings ([0c44d8e](https://github.com/sile-typesetter/sile/commit/0c44d8ea4b39998011bdfd08bb9106dbd993b347))
* **core:** A typo in a variable prevents using -u with a class ([b8f5c40](https://github.com/sile-typesetter/sile/commit/b8f5c407869bc338117acefe1e4fc5c0f484f803)), closes [#1569](https://github.com/sile-typesetter/sile/issues/1569)
* **languages:** Make 'und' an exception to language name canonicalization ([52e9b79](https://github.com/sile-typesetter/sile/commit/52e9b79ca89da98947afae82742c2648a52a1cfa))
* **math:** Fix insertion order of MathML children ([738e9e6](https://github.com/sile-typesetter/sile/commit/738e9e6fb40ea5e21f182c74af4f584d0190313d))
* **packages:** Account for depth when calculating rotation center ([289dd2a](https://github.com/sile-typesetter/sile/commit/289dd2a4e3c54502d68b06f5126d52f9e3098ca0))
* **packages:** Avoid forcing mirrored masters in twoside package ([#1562](https://github.com/sile-typesetter/sile/issues/1562)) ([8cdf6ed](https://github.com/sile-typesetter/sile/commit/8cdf6ede2361fae948723fbada7563d44d39901d))
* **packages:** Combine `\unichar`'ed chars with same font only ([91a8d40](https://github.com/sile-typesetter/sile/commit/91a8d4091cc320bed714f51f2e32824d80b2a2f7))
* **packages:** Correct rotation origin calculation back to pre v0.10.0 ([3521936](https://github.com/sile-typesetter/sile/commit/35219360e0e5ad54f3363624148181eb619715c7))
* **packages:** Don't inhibit page breaking after switching masters mid-page ([6b20f73](https://github.com/sile-typesetter/sile/commit/6b20f7310c9c482352a4e401462519c32092a04f))
* **packages:** Make sure PDF initialized before rotate package directly calls it ([449b2a6](https://github.com/sile-typesetter/sile/commit/449b2a6cf417ab36ceaa95ccc499557bd81a84c1))
* **packages:** Rework simple and multilevel counters ([1e6e91a](https://github.com/sile-typesetter/sile/commit/1e6e91ad0154c8f8399b9271dcc27c48f2fd1b78))
* **packages:** Textcase package name typo preventing using methods from code ([7f68766](https://github.com/sile-typesetter/sile/commit/7f68766b8a6aeb7111462a1557b4715b6c9b5855)), closes [#1568](https://github.com/sile-typesetter/sile/issues/1568)


### Reverts

* Revert "docs(packages): Fixup unichar documentation, work around known bug (#1549)" ([03d1b11](https://github.com/sile-typesetter/sile/commit/03d1b1168c7d55251fb631286394ade8c46104ae)), closes [#1549](https://github.com/sile-typesetter/sile/issues/1549)

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.4
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.3...v0.14.4
