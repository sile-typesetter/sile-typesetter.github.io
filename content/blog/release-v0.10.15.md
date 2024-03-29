+++
aliases = ["2021/03/sile-0-10-15-is-released"]
title = "SILE v0.10.15 Is Released"
date = "2021-03-02"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.15 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release fixes a couple of regressions and adds a couple small features. On the regression front, access to the interactive prompt has been restored and the table of contents metadata in PDFs is properly encoded again. For new features, COLR fonts are now automatically detected and the necessary support package is loaded when they are used, a new package allows spaces to be drawn using font-provided glyphs rather than assuming empty space, and another new package allows access to OpenType font features through more verbose fontspec names rather than their OpenType feature code names.

### Features

* **fonts:** Allow for code to be run when a font is first loaded ([bdf05ab](https://github.com/sile-typesetter/sile/commit/bdf05ab8bfef72da4f251d471646d1387aedd905))
* **packages:** Add \font-feature command ([e2cf008](https://github.com/sile-typesetter/sile/commit/e2cf00842a71b090080a101613f5d6d4a70d4c37))
* **packages:** Add complex-spaces package ([#1148](https://github.com/sile-typesetter/sile/issues/1148)) ([b7451ae](https://github.com/sile-typesetter/sile/commit/b7451ae513b003b76531f24bebb35204488b6b0b))

### Bug Fixes

* **cli:** Re-enable access to repl, input argument not required ([a6434ee](https://github.com/sile-typesetter/sile/commit/a6434ee414fc870efd22f50f5da239f902cd5b94))
* **core:** Allow builtin Lua bitwise operators on Lua 5.4 ([5f0c2c7](https://github.com/sile-typesetter/sile/commit/5f0c2c7e929bc9c040b28019e3be648feddbd846))
* **docker:** Switch to BuildKit and make Docker Hub cooperate ([783b104](https://github.com/sile-typesetter/sile/commit/783b104df99a99ef3271322ba8086f995abab945))
* **docker:** Use patched glibc to work around outdated hosts ([fa2532c](https://github.com/sile-typesetter/sile/commit/fa2532c140383ea414867340f047c9e8cc05ec7f))
* **docker:** Use patched glibc to work around outdated hosts ([#1141](https://github.com/sile-typesetter/sile/issues/1141)) ([bf74417](https://github.com/sile-typesetter/sile/commit/bf74417aee5f9cc671f8a53b6802a5d242076875))
* **docker:** Work around libtexpdf build having side effects ([33510d9](https://github.com/sile-typesetter/sile/commit/33510d90b5b74396eac8c9e46f6bbbb952010415))
* **packages:** Add CharacterVariant to features ([929eca2](https://github.com/sile-typesetter/sile/commit/929eca2ea45cc3adeab8c3780d94980a7012541a))
* **utilities:** Correct UTF-8/UTF-16 conversions ([4863ed6](https://github.com/sile-typesetter/sile/commit/4863ed679f25fd7f1761879098ffb80e4e4e55ea))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.15
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.14...v0.10.15
