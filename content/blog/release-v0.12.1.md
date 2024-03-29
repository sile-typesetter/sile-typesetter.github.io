+++
aliases = ["2022/01/sile-0-12-1-is-released"]
title = "SILE v0.12.1 Is Released"
date = "2022-01-12"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.12.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The first minor release in the v0.12.x series brings several new features relevant to paragraph shaping.
Didier Willis has fleshed out the linebreak mechanism with full parity of LaTeX's settings including `hangingIndent` and `parShape`.
Having fully featured paragraph-wise hanging indent settings enabled a new package, dropcaps, to provide much more robust dropcap functionality than the previous floating frame mechanism we used for this.
(Note the dropcap package documentation did not make it in the manual at release time, see the example on the website or the manual from a newer release for usage.)
Additionally the paragraph shape callback function can now be used to create fancy paragraph shapes using any geometry you can specify or calculate.

{{ example(fn="dropcaps") }}
{{ example(fn="parshape") }}

Bugfixes in this release cover several issues with French language, PDF metadata encoding, color fonts, book class headers, and more.

### Features

* **build:** Accommodate SOURCE_DATE_EPOCH for reproducible builds ([16c81a8](https://github.com/sile-typesetter/sile/commit/16c81a8dfb191238d65610380d648437a6492f2e))
* **classes:** Add \noop function for versatile SILE.call() use ([2b04507](https://github.com/sile-typesetter/sile/commit/2b045078120c52ccc948cc663936504153285132))
* **core:** Add OpenType post (v1) table parser ([a985aed](https://github.com/sile-typesetter/sile/commit/a985aedbd5553987f63be04f9b74d1a6b2299952))
* **core:** Implement Knuth's hangAfter and hangIndent ([5417189](https://github.com/sile-typesetter/sile/commit/54171894f3f1415f33891192631f54af47db9c28))
* **core:** Implement paragraph duration hanging indent settings ([18ee23b](https://github.com/sile-typesetter/sile/commit/18ee23bc1271ba1be7aee98c8346b3f9c225d9dc))
* **core:** Implement paragraph shaping (parshape) ([c2c0235](https://github.com/sile-typesetter/sile/commit/c2c0235717202c811673379dd6b54118468b327e))
* **packages:** Add dropcaps package ([cb9105a](https://github.com/sile-typesetter/sile/commit/cb9105a676e8e0efad29bb62d135fd0d02ef6d1d))
* **packages:** Add shift, raise, and size options to dropcaps ([0a88948](https://github.com/sile-typesetter/sile/commit/0a88948e5028e4f3b82ad7ee689d5f53e0358ddd))
* **packages:** Implement color option for dropcaps ([d042bcf](https://github.com/sile-typesetter/sile/commit/d042bcf31dcd52d1a51dad527f727834ca8e22d9))
* **packages:** Use font's post table to determine underline position ([ae1b929](https://github.com/sile-typesetter/sile/commit/ae1b929cfe3bd1784bd2962a5ccb8b53b47377d7))


### Bug Fixes

* **backends:** Move Lua 5.1 macro so covers whole file ([9b40772](https://github.com/sile-typesetter/sile/commit/9b40772920602bd1a9543d38bf9cf5e51d1f4b24))
* **classes:** Reset state when calling running headers ([ec0a7b8](https://github.com/sile-typesetter/sile/commit/ec0a7b8d0494f83cbfd546bee3896af2a944c6a0))
* **classes:** Unnumbered book sections shall not display a number in running headers ([4afde42](https://github.com/sile-typesetter/sile/commit/4afde429179b5bcff2f5f713ed0bb4cc103475a5))
* Fixes name of accented math symbol, eliminates duplicate newStandardHspace assignment ([4c38f1a](https://github.com/sile-typesetter/sile/commit/4c38f1a50ee3ce4a661bbd04b3382d57362e952f)), closes [#1274](https://github.com/sile-typesetter/sile/issues/1274)
* **languages:** Correct hyphenation after apostrophe in French and Catalan ([4c93891](https://github.com/sile-typesetter/sile/commit/4c93891f3bbc2b95e5dca99eee46ab72d2248b9e))
* **languages:** Correct synchronisation between indexes in French word breaking ([94ca931](https://github.com/sile-typesetter/sile/commit/94ca931e968b682c81a30dce7deace629b97afa2))
* **languages:** Repair broken French hyphenation patterns ([c25d9d7](https://github.com/sile-typesetter/sile/commit/c25d9d7d7ff1ed2d1a291de1396795f4c9a72700))
* **packages:** Add \pdf:metadata support for dates ([1b87305](https://github.com/sile-typesetter/sile/commit/1b87305b7503c1c7deb88793b428d5278b42f14c))
* **packages:** Apply OpenType x and y offsets to color fonts ([d66dc5f](https://github.com/sile-typesetter/sile/commit/d66dc5fadaaa4992f6d33101023541c6b0ab93f2)), closes [#1147](https://github.com/sile-typesetter/sile/issues/1147)
* **packages:** Correct rebox to not output duplicate content ([2802d9b](https://github.com/sile-typesetter/sile/commit/2802d9b14318a514da5fa56bfb60f67b698db51b))
* **packages:** Don't over-isolate functions run in Pandoc imports ([#1254](https://github.com/sile-typesetter/sile/issues/1254)) ([84507a5](https://github.com/sile-typesetter/sile/commit/84507a546ac63f7f40e65abbfe6831ff4c19f046))
* **utilities:** Fix UTF-16 encode/decode utility functions ([7180081](https://github.com/sile-typesetter/sile/commit/71800815daf6275a35aa6578de56a84f043e5317)), closes [#1280](https://github.com/sile-typesetter/sile/issues/1280)
* **utilities:** Set language of roman numerals to Latin to avoid casing issues ([#1253](https://github.com/sile-typesetter/sile/issues/1253)) ([95c4e2c](https://github.com/sile-typesetter/sile/commit/95c4e2c0e1b1291849edf7ac8e456a954097286c))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.0...v0.12.1
