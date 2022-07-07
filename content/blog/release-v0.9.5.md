+++
aliases = ["2019/01/sile-0-9-5-is-released"]
title = "SILE v0.9.5 Is Released"
date = "2019-01-07"

[extra]
post_author = "Simon Cozens"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.9.5 of SILE has been released and is [available for download][1]! New in in this release:

* Experimental package manager.

* The "smart" bare percent unit (where SILE guessed whether you meant height or width) has now moved from deprecated to error. Replace with `%pw` etc.

* Language support: variable spaces in Amharic (and other languages if enabled with the `shaper.variablespaces` setting), improvements to Japanese Ruby processing, Uyghur hyphenation revisited and improved, Armenian hyphenation added.

* You can now set the stretch and shrink values of a space using the `shaper.spaceenlargementfactor`, `shaper.spaceshrinkfactor` and `shaper.spacestretchfactor` settings.

* You can use `-` as input filename to pipe in from standard input, and `-` as output filename to pipe generated PDF to standard output.

* New `letter` class.

* New commands: `\neverindent` and `\cr`

* New units: `ps` (parskip) and `bs` (baselineskip)

* Links generated via the `url` package are hyperlinked in the PDF.

* You can now style folios (page numbers) by overriding the `\foliostyle` macro.

* Languages may define their own counting functions by providing a `counter` function; you may also lean on ICU’s number formatting to format numbers.

* ICU is now required for correct Unicode processing.

* Experimental support for SVG graphics and fonts. (see `tests/simplesvg.sil`)

* Users may select the Harfbuzz subshaping system used (`coretext`, `graphite`, `fallback` etc.) by setting the `harfbuzz.subshapers` setting.

* Fix typos in documentation (Thanks to Sean Leather, David Rowe).

Most other changes in this release are internal and non-user-visible, including:

* Introduced vertical kern nodes.

* Various fixes to pushback (end of page) logic, bidi implementation. ICU is now used for bidi.

* Updated various examples to work with current internals.

* Many and varied internal fixes and speedups, and improved coding style.


[1]: https://github.com/sile-typesetter/sile/releases/tag/v0.9.5
