+++
title = "SILE v0.15.8 Is Released"
date = "2024-12-12"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.8 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release fixes build issues for macOS (Darwin) we introduced back in v0.15.6 that have been holding back releases on Homebrew and Nix's Darwin support.
In addition to the build support, the `macfonts` font loader has been tweaked to support fallback to `fontconfig` when a font is not found so it will behave more similarly to Linux builds.

On all platforms, CLI output is a bit cleaner.
Many runtime errors now output cleaner message formatting instead of a jumble of joined lines.
Also some error chains where one error would trigger another have been resolved.

The math support continues to be refined by [Didier Willis](http://github.com/Omikhleia), this release bringing a few new commands and features, better behavior parity with MathML, and a couple bug fixes.

### New Features

* **build:** Add rockspec and build tooling for rusile module ([d1ed71e](https://github.com/sile-typesetter/sile/commit/d1ed71e548a858631b083c7da3985f157f0ce809))
* **cli:** Output runtime errors pretty-printed for readability ([fb45160](https://github.com/sile-typesetter/sile/commit/fb451604befa196f5e591f8de251455d9af96b08))
* **fonts:** Configure macOS to fallback from macfonts to fontconfig ([4b6aa5e](https://github.com/sile-typesetter/sile/commit/4b6aa5ed00747ea22932547770aca62c8add28a4))
* **math:** Add (AMS)LaTeX-like stackrel, overset and underset ([bfd41c0](https://github.com/sile-typesetter/sile/commit/bfd41c0786ffd994b4ae2237c378eee1fabd4eae))
* **math:** Minimal support for accents in MathML and TeX-like commands ([dd0b1b5](https://github.com/sile-typesetter/sile/commit/dd0b1b5f77b498589e4d490466fa8b3d14ee93f1))
* **packages:** Add handler for passing raw content to verbatim ([46b0164](https://github.com/sile-typesetter/sile/commit/46b01644e72f80a3b1820b7b157f995ade5a3c29))

### Bug Fixes

* **build:** Fix Lua module detection to *fail* if not found ([18f707b](https://github.com/sile-typesetter/sile/commit/18f707b09301d635da15118b0e03382a817dfa45))
* **build:** Remove obsolete workaround for macOS dependency paths ([3fb891a](https://github.com/sile-typesetter/sile/commit/3fb891a12079a79a330fefdc1cbd9960e78c6ea4))
* **build:** Set module build flags needed for darwin shared libraries ([625ea69](https://github.com/sile-typesetter/sile/commit/625ea694f3f209704ae3b75096de894e2e33d4bf))
* **cli:** Correctly pass through font manager preference from Rust CLI ([d2fb48a](https://github.com/sile-typesetter/sile/commit/d2fb48a063753fc7621d785236e154bf22812865))
* **core:** Avoid internal error when also erroring due to user provided content errors ([d83e63c](https://github.com/sile-typesetter/sile/commit/d83e63cdbfdcfd8439212b9261f2dc5fbd24620a))
* **inputters:** Discard duplicate values being parsed without keys in XML ([4bb31f0](https://github.com/sile-typesetter/sile/commit/4bb31f0aefaf9da500f417a73302ef148ec36a65))
* **math:** Change under/over constructs' inheritance of the base atom type ([70d4f69](https://github.com/sile-typesetter/sile/commit/70d4f69f1990ba7d774309be47595815b0ee23ed))
* **math:** Erroneous capital H and I in fraktur variant ([#2183](https://github.com/sile-typesetter/sile/issues/2183)) ([3263be3](https://github.com/sile-typesetter/sile/commit/3263be3743563688c08b9e9a6b848568bf7b360b))
* **outputters:** Don't attempt to create output if we error before processing even starts ([d38ff03](https://github.com/sile-typesetter/sile/commit/d38ff03f134062a4ab8237da67f9a68bfb6c7fcc))
* **rusile:** Adjust module loader to Darwin's shared module extension ([2c5ea3e](https://github.com/sile-typesetter/sile/commit/2c5ea3e8ab62c81808c6a73bc83f39f4ced3cbd7))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.8
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.7...v0.15.8
  [bibliography]: https://github.com/orgs/sile-typesetter/projects/12
