+++
aliases = ["2020/07/sile-0-10-5-is-released"]
title = "SILE v0.10.5 Is Released"
date = "2020-07-03"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.5 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This maintenance release fixes a number of small bugs that have cropped up in production use of the v0.10 series.
Using the *frametricks* package no longer causes crashes, your table of contents justification won't be wonky, and passing functions as content is working as expected again.
As an added bonus it is possible to process the content passed to functions / macros more than once if desired.

One minor new feature slipped in as well. In addition to the letter-space system that added glue nodes between every glyph there is now a setting for true tracking (that won't break hyphenation or other features).
Packages might also appreciate the improved dependency detection and quick self-check that verifies everything is in working order without running the whole test suite.

Note that while Lua 5.4.0 was released a couple days ago, this release officially only supports Lua through the latest 5.3 release.
It may or may not work on Lua 5.4 yet, we haven't tested.


### Features

* **build:** Add `make check` fast self-check target, fixes [#835](https://github.com/sile-typesetter/sile/issues/835) ([89cefef](https://github.com/sile-typesetter/sile/commit/89cefefe758a00b9b310ba4df53320f9c74ce696))
* **shaper:** Add tracking setting and implement for harfbuzz ([9e1dec7](https://github.com/sile-typesetter/sile/commit/9e1dec7a0a71db6c17dded2fce8b61867bb0a523))


### Bug Fixes

* **build:** Check for luarocks if not configured --with-system-luarocks ([e8770ce](https://github.com/sile-typesetter/sile/commit/e8770ce2d1085752e2383adcb11acf8222225cd7))
* **core:** Account for possibility that there are no working fallbacks ([391f44e](https://github.com/sile-typesetter/sile/commit/391f44eb7cd93351404bbbe89167d5acca466bff))
* **core:** Gracefully do nothing when SILE.process() passed nothing ([1085049](https://github.com/sile-typesetter/sile/commit/1085049310cce11728f74dd7d46571bc579d7afb))
* **core:** Revamp macro system to fix [#535](https://github.com/sile-typesetter/sile/issues/535) ([47a0af8](https://github.com/sile-typesetter/sile/commit/47a0af8e922f5122f6af41d3809b2f1248c2ac2d))
* **frames:** Avoid possible infinite loop when looking for a frame ([157dfc8](https://github.com/sile-typesetter/sile/commit/157dfc815e0888c604581ac38766d5858450bcf8))
* **frames:** Rely on __tostring() meta method, toString() is no more ([77b8956](https://github.com/sile-typesetter/sile/commit/77b8956b890d85763e87ecab742bbfad970a528f))
* **nodes:** Fix calling non-existent nodefactory function ([#864](https://github.com/sile-typesetter/sile/issues/864)) ([9580a15](https://github.com/sile-typesetter/sile/commit/9580a15e8efddbae9c91116beac2210e6ce893cf))
* **packages:** Center dotfill in the event only one dot fits ([95181d2](https://github.com/sile-typesetter/sile/commit/95181d2b1827f56d4f3de3775f8aa2d4b16c0735))
* **packages:** Don't let dotfill content be stretchy ([079ff97](https://github.com/sile-typesetter/sile/commit/079ff971462515edbebddd04f6572b91c4c80904))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.5
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.4...v0.10.5
  [wiki]: https://github.com/sile-typesetter/sile/wiki
