---
title: SILE v0.12.0 Is Released
post_author: Caleb Maclennan
post_gravatar: 11cdaff4c6f9b290db40f69d3b20caf1
---
Version v0.12.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Please welcome *MATH* typesetting!

While this release follows close on the heels of previous releases it represents over 2 years of work from community contributors.
Rui Xia started work on a native math feature in April of 2019.
While this initial phase was never completed, it did get as far as a working prototype.
In November of 2020, Oliver Nicole picked up on the work and transformed the prototype into the shape as found in this release.
Additional thanks to Mateusz Czapliński for input throughout the process.

On a conceptual level the math support is based on [MathML][] and relies on OpenType math fonts.
The input notation may be MathML (either directly using the native XML syntax or using an 1-to-1 equivalent SILE syntax) or an alternative math shorthand similar to the math notation used by TeX.
See section 5.29.5 in the [v0.12.0 manual][manual] for detailed documentation on the new math package.
Examples are given for various formulas and syntax options.
A math example has also been added to the [packages example gallery](/examples/packages.html) on this website.

Additionally Didier Willis contributed several new features and fixes including much more control over Table of Contents, styling options for PDF links, correct French punctuation treatment, and more.

Thanks to the contributions of Doron Behar, as of this release SILE is usable as a [Nix Flake][flake] (in addition to the usual Nix package).
This is an easy way to test run the latest Git HEAD version at any time from almost any OS.
One you have flake support enabled, just run `nix run github:sile-typesetter/sile -- <sile orguments>`.
This website uses this to regenerate some of the examples in the gallery.

Even though the math package is a major new feature, ultimately the major version bump was caused by a breaking change elsewhere.
Previous to this release, the font used for footnotes was the SILE default unless specifically set.
Setting changes were relative to the SILE default rather than the document default.
This behavior was workable, but usually came as a surprise to most users.
With this release, footnote and folio frame font settings default to being relative to the current document font.
The font family, size, leading, and all other aspects of footnotes and folios are still configurable with the same tools as before.
But this is a breaking change because those settings are now relative to a different base which might cause many documents to need updating.

### ⚠ BREAKING CHANGES

* **packages:** Previous to this release footnote and folio frames took
their font settings from a new typesetter with default settings. With
this release the settings are now derived from the typesetter in the
default frame, hence inheriting font family, size, leading, and other
settings. Values can still be set using the same functions, but relative
values such as font sizes are based on a different base.

### Features

* **core:** Add MATH variants table parser ([b6c554e](https://github.com/sile-typesetter/sile/commit/b6c554e0d309302c69402263217a59e0e129ca09))
* **core:** Add OpenType MATH table parser ([835da21](https://github.com/sile-typesetter/sile/commit/835da217b2aeaf53d7a172d18a887d77cc13f666))
* **math:** Add ‘debug’ option to math command ([58cc9dc](https://github.com/sile-typesetter/sile/commit/58cc9dc8a96dde36bc77e385faa72014b348408f))
* **math:** Add “big operator” support ([5b9a150](https://github.com/sile-typesetter/sile/commit/5b9a1509f9ca0fa55068fcd1da64714c7ce84dfa))
* **math:** Add fixes to support less complete fonts ([1c22af3](https://github.com/sile-typesetter/sile/commit/1c22af373bf08badfd9b09b01974f255ee738054))
* **math:** Add italic correction to superscript; correct subscript size ([d81fdee](https://github.com/sile-typesetter/sile/commit/d81fdee7321107507e92def15a60b289abc6e1be))
* **math:** Add math.font.filename setting ([522d70b](https://github.com/sile-typesetter/sile/commit/522d70bb518e978da3ba60f0ff5689063f589638))
* **math:** Add math.font.size setting ([5077d1c](https://github.com/sile-typesetter/sile/commit/5077d1c06405dc25316600a680d922d4ab87b204))
* **math:** Add operator defaults ([14bdf1a](https://github.com/sile-typesetter/sile/commit/14bdf1a0dd1e6c3db1c281a1e0c4b2f540d2b91a))
* **math:** Add parameter to draw debug boxes around math components ([2458d18](https://github.com/sile-typesetter/sile/commit/2458d188af912171101f9af456f2ab19b7184a20))
* **math:** Add parameters and support mathvariant param for mi tag ([869dca8](https://github.com/sile-typesetter/sile/commit/869dca86f0c0979145260d1d9a8a22d9dab6e47d))
* **math:** Add plain text support ([3a09e9d](https://github.com/sile-typesetter/sile/commit/3a09e9d1d9c05dfec3f9433541ed5b8512dda373))
* **math:** Add subscript and superscript; add math constants ([0489c04](https://github.com/sile-typesetter/sile/commit/0489c04d944df52a1396cd5c902344ef8c53db2d))
* **math:** Add support for “symbol macros”, expanding to strings ([27658f5](https://github.com/sile-typesetter/sile/commit/27658f517c59567842839776589e76b7cc062b74))
* **math:** Add support for fractions ([6f4fc24](https://github.com/sile-typesetter/sile/commit/6f4fc24d69c38beb9c623aeb12e3362d4489c884))
* **math:** Add tags for some mathematical symbols ([b9fd771](https://github.com/sile-typesetter/sile/commit/b9fd771007418566939d716a9a413d959c9bda2f))
* **math:** Add tex-like math parser ([edceaf7](https://github.com/sile-typesetter/sile/commit/edceaf7dfb5c644daec27915f2106195a7a08c5a))
* **math:** Allow vertical stacking of top-level �mrow’s ([56b553c](https://github.com/sile-typesetter/sile/commit/56b553c1821104eda2fdd2e34ac1b2f06882ee81))
* **math:** Center display math neatly ([8951378](https://github.com/sile-typesetter/sile/commit/8951378c1b9ad076699256d116314fae98705c7f))
* **math:** Implement and use munder and mover ([61eac7a](https://github.com/sile-typesetter/sile/commit/61eac7a95c8a05e255e61285fcc7776ac4123d35))
* **math:** Implement generic bbox shaper ([9c86aff](https://github.com/sile-typesetter/sile/commit/9c86aff63ab072fe0a54fe06d8fbb3e27250a8cb))
* **math:** Output error if rending with non-math font ([c79617b](https://github.com/sile-typesetter/sile/commit/c79617bad7f4aba8c8ecd6b3dc50b5676b6cbf47))
* **math:** Replace leading `-` with `−` in numbers ([f8d490c](https://github.com/sile-typesetter/sile/commit/f8d490ccb298f730176d300100ebc0fec6c6128e))
* **math:** Support double-struck identifiers ([29674bf](https://github.com/sile-typesetter/sile/commit/29674bf069d46a0e6694ac6e7ef11b4c4864f43d))
* **math:** Support for simple macros ([5b4ecf7](https://github.com/sile-typesetter/sile/commit/5b4ecf72ca5718d73c24c97c8aa0806e5a12d519))
* **math:** Support italic ([c9b2884](https://github.com/sile-typesetter/sile/commit/c9b2884ad98cc4102f04ae6e158e0b4821a61ef8))
* **math:** Support more integral-like operators ([90a6c44](https://github.com/sile-typesetter/sile/commit/90a6c44e931e24f3696e8adec905a318f9134062))
* **math:** Support of UTF-8 in texmath, support of mo, mi and mn in-grammar ([959d1cc](https://github.com/sile-typesetter/sile/commit/959d1cce7b3d01f2e4d8182726b5c20f97194f4b))
* **math:** Turn "-" (hyphen) into "−" (minus) in math ([fbed523](https://github.com/sile-typesetter/sile/commit/fbed523f4792af569c2548c25d0d941f0b464b60))
* **packages:** Add border style and color to hyperlinks ([bb880be](https://github.com/sile-typesetter/sile/commit/bb880bed7b8564591d2600a98786d05a24086d2b))
* **packages:** Add function to remove last added fallback font ([acf987b](https://github.com/sile-typesetter/sile/commit/acf987b23b8ebf8446d9e65fa42fcb1c1fa34528))
* **packages:** Add linking support to toc entries ([e589cb9](https://github.com/sile-typesetter/sile/commit/e589cb96ba24ef06c0bda1297729f8925f8d1550))
* **packages:** Add toc depth option and hooks for showing section numbers ([c48fcde](https://github.com/sile-typesetter/sile/commit/c48fcdeebe4bf0a1b75f5f722fad1268e797831d))
* **packages:** Allow URLs to have many breakpoints ([#1233](https://github.com/sile-typesetter/sile/issues/1233)) ([b145605](https://github.com/sile-typesetter/sile/commit/b145605f5326e54fbf3cbf88bc2d334c403ba685))
* **packages:** Warn if toc contents have changed ([5b6eed8](https://github.com/sile-typesetter/sile/commit/5b6eed8c39670a58a4c3d9e1fcb07504ade96df1))
* **tooling:** Enable use as a Nix flake ([8b503bb](https://github.com/sile-typesetter/sile/commit/8b503bb74bb51b388d0140cac5848902858b8e58))

### Bug Fixes

* **classes:** Don't increment counters on unnumbered book sections ([6cfca4d](https://github.com/sile-typesetter/sile/commit/6cfca4d86885a5df4ca6f0d46153d5b3e925f4ee))
* **core:** Correct --help output to reflect required values ([da487ec](https://github.com/sile-typesetter/sile/commit/da487ec0c1295d3a54ff50f22dd63fd28e2b80b1))
* **languages:** Add test 704 for French punctuations, fix expected 621 and 702 results ([8e9b056](https://github.com/sile-typesetter/sile/commit/8e9b056664214f59326b2b7d1cc5c9af1d74522e))
* **languages:** Correct Armenian support to use ISO 639 code ‘hy’ ([ffafbe6](https://github.com/sile-typesetter/sile/commit/ffafbe617743ad43a781edce08836d0d88f5da2b))
* **languages:** Correct punctuation rules for French ([95c2398](https://github.com/sile-typesetter/sile/commit/95c23982f407299cd57e7b41c162a10f0e992f77))
* **languages:** Don't initialize Japanese unless actually called for ([3aba931](https://github.com/sile-typesetter/sile/commit/3aba931ecf773a4dc7d881912f21bd952b9760a1))
* **languages:** Shortcut ICU soft breaks in French ([ed8734c](https://github.com/sile-typesetter/sile/commit/ed8734cb19020554f951ebb970c999a9592f41b7))
* **packages:** Don't replace shaper unless actually initializing color-fonts package ([269ca59](https://github.com/sile-typesetter/sile/commit/269ca5923c5588303dc8fcf2d33e32cdd072419c))
* **packages:** Fix deprecation warning command in package docs ([a69d774](https://github.com/sile-typesetter/sile/commit/a69d7747bb5e6643add953c458739aafcfee105b))
* **packages:** Reset footnote and folio settings top level state ([3795a4e](https://github.com/sile-typesetter/sile/commit/3795a4e83823642a69e481cecd15a4966053fd71))
* **shaper:** Fix memory leak in Harfbuzz library ([#1243](https://github.com/sile-typesetter/sile/issues/1243)) ([035dcc8](https://github.com/sile-typesetter/sile/commit/035dcc8d46bba8bb2ec3a2df634c6c747d4a2526))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.11.1...v0.12.0
  [flake]: https://nixos.wiki/wiki/Flakes
  [MathML]: https://www.w3.org/Math/
  [manual]: https://sile-typesetter.org/manual/sile-0.12.0.pdf
