+++
aliases = ["2014/10/sile-0-9-1-is-released"]
title = "SILE v0.9.1 Is Released"
date = "2014-10-30"

[extra]
post_author = "Simon Cozens"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.9.1 of SILE has been released and is [available for download][1].

* The main change in this release is a new shaper based on [Harfbuzz][] and a new PDF creation engine. This has greatly improved the output quality on Linux, as well as bringing support for multilingual typesetting and allowing future support of interesting PDF features. (It’s also much faster.)

* The new PDF library also allows images to be embedded in many different formats, rather than just PNG.

* Documents can now be written in right-to-left languages such as Hebrew or Arabic, and it’s possible to mix left-to-right and right-to-left text arbitrarily. (Using the Unicode Bidirectional Algorithm.) Please see the examples to the left.

* Initial support for languages such as Japanese which have different word/line breaking rules.

* Frames can be grouped into a set called a "master", and masters can be used to set the frame layout of a given page.

* Hopefully a much easier installation process, by bundling some of the required Lua modules and using the standard autoconf `./configure; make` strategy.

* Support for Lua 5.2.

[Harfbuzz]: https://www.freedesktop.org/wiki/Software/HarfBuzz/
[1]: https://github.com/sile-typesetter/sile/releases/tag/v0.9.1
