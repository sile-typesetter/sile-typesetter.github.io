+++
aliases = ["2016/08/sile-0-9-4-is-released"]
title = "SILE v0.9.4 Is Released"
date = "2016-08-31"

[extra]
post_author = "Simon Cozens"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

After a year of development and many, many fixes, version v0.9.4 of SILE has been released and is [available for download][1]! It includes nearly 600 changes, including:

* New packages include: letter spacing, multiple line spacing methods, Japanese Ruby, font specimen generator, crop marks, font fallback, set PDF background color.

* Fixed handling of font weight and style.

* Hyphenation: Correct hyphenation of Indic scripts, words with non-alphabetic characters in them, and allow setting hyphen character and defining hyphenation exceptions.

* Relative dimensions ("1.2em") are converted to absolute dimensions at point of use, not point of declaration. So you can set linespacing to 1.2em, change font size, and it’ll still work.

* Default paper size to A4.

* Changes to semantics of percent-of-page and percent-of-frame length specifications. (`width=50%` etc.)

* Much improved handling of footnotes, especially in multicolumn layouts.

* Support for: the libthai line breaking library, color fonts, querying the system font library on OS X, multiple Amharic justification conventions.

* Added explicit kern nodes.

* Changed to using Harfbuzz for the text processing pipeline; much faster, and much more accurate text shaping.

* Rewritten and more accurate bidirectional handling.

* Removed dependency on FreeType; use Harfbuzz for font metrics.

* Fixed the definition of an em. (It’s not the width of a letter "m".)

and much more besides.

[1]: https://github.com/sile-typesetter/sile/releases/tag/v0.9.4
