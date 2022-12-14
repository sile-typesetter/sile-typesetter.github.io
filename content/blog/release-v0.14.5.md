+++
title = "SILE v0.14.5 Is Released"
date = "2022-11-19"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.5 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

We're just squishing bugs today and making the manual a little neater.
Working with STDIN streams should be a bit more robust now as the content type detection isn't so picky about whitespace and isn't so prone to false positive detections.
Document file restrictions have been relaxed a little too allowing comments and whitespace before the leading document tag.
Package developers should have a little bit easier time with in the event their package is loaded twice.
Also a number of small typesetting issues in the user manual were cleaned up by [Didier Willis](https://github.com/Omikhleia).


### Bug Fixes

* **inputters:** Correct false positive detection of STDIN as Lua content ([d54946b](https://github.com/sile-typesetter/sile/commit/d54946bba643b9cf4fc68f21df4442c82238fedf))
* **inputters:** Don't duplicate passthrough content in AST ([07c8e87](https://github.com/sile-typesetter/sile/commit/07c8e874550a7ef5924bae2047f98c33fbda6453))
* **inputters:** Permit content outside of the document note, e.g. comments or blanks ([#1596](https://github.com/sile-typesetter/sile/issues/1596)) ([f1a508a](https://github.com/sile-typesetter/sile/commit/f1a508a6c61d64623f40d5274eee3bdbb6353d28))
* **inputters:** Relax SIL format sniffing to allow valid syntax ([43fc4bc](https://github.com/sile-typesetter/sile/commit/43fc4bca58da9288dda0dc001b647ed45e5267d5))
* **languages:** Remove superfluous line ([848b91f](https://github.com/sile-typesetter/sile/commit/848b91f5ab66f90e4c1d5ed2ca8f6e20acb9fcdf))
* **languages:** Tidy up variable scope in languages/unicode.lua ([78b453d](https://github.com/sile-typesetter/sile/commit/78b453d58a92c2ff34a80bf610d2c1c120eedc38)), closes [#699](https://github.com/sile-typesetter/sile/issues/699)
* **measurements:** Allow redefinition of existing units ([#1608](https://github.com/sile-typesetter/sile/issues/1608)) ([8d81018](https://github.com/sile-typesetter/sile/commit/8d810182c25799fd134133611f3c29e90a60f7c8))
* **packages:** Ensure a page switch does not break boustrophedon ([#1615](https://github.com/sile-typesetter/sile/issues/1615)) ([64abaf9](https://github.com/sile-typesetter/sile/commit/64abaf9c2511ea1241efc04722daf9f0ed7589b1))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.5
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.4...v0.14.5
