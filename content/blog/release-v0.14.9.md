+++
title = "SILE v0.14.9 Is Released"
date = "2023-04-12"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.9 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Today we have a substantial rollup of small fixes.
No one thing here is going to knock your socks off, but lots of things are just *better*.

On the documentation front a new contributor, [John Labovitz](https://github.com/jslabovitz), stepped in with a huge copy-edit of the entire manual.

For shiny new features, [Didier Willis](http://github.com/Omikhleia) added a new `scalebox` package for reshaping other output.
He also taught some existing packages new tricks, such as adding style hooks to the `url` package and allowing the infinitely stretchy fill glue nodes to be initialized with a starting length.
The CLI gained a new `--quiet` flag to suppress info and warning messages for those times when you just don't want to know what the engine is telling you.

In bug extermination news, the list of squashed ones is long, and some of them had been around for a long time.
Didier did a lot of work under the hood with hboxes and discretionary node handling.
The upshot for end users is that a lot of weirdness with `parindent` settings and they way content that didn't fit on one page is pushed to the next has been smoothed over.
Your indents shouldn't ever get applied twice, underlines won't apply to the indentation space, unnumbered chapters won't sometimes disappear from your ToC, and so forth.


### Features

* **classes:** Add Picas unit to cover all units speced in Docbook ([88f03fa](https://github.com/sile-typesetter/sile/commit/88f03fa9cbc4595d62d9545f15c17aa9b2eaea2e))
* **classes:** Implement the`\code` command in the plain class ([0d371ba](https://github.com/sile-typesetter/sile/commit/0d371ba816ca3976c7a6df23dc7136aa2406c01c))
* **cli:** Add -q / --quiet flag to reduce output to essential errors ([#1759](https://github.com/sile-typesetter/sile/issues/1759)) ([f69ed20](https://github.com/sile-typesetter/sile/commit/f69ed2092c352513db699e7247db77f4f766d8d1))
* **core:** Support initializing fill glues with a width ([#1765](https://github.com/sile-typesetter/sile/issues/1765)) ([5bc372a](https://github.com/sile-typesetter/sile/commit/5bc372ac66174a0cd3c15930a73e20825621e250))
* **packages:** Introduce urlstyle hook in the url package ([8f6235d](https://github.com/sile-typesetter/sile/commit/8f6235d0e995b3f684fc5ba9f4646494800fb37a))
* **packages:** New scalebox package for arbitrary box re-scaling ([a11f61e](https://github.com/sile-typesetter/sile/commit/a11f61e6aeaa306652a506a652edd94a0a319c23))
* **packages:** Support migrating content in re-wrapped hboxes ([da3ab6d](https://github.com/sile-typesetter/sile/commit/da3ab6d73e267c448fac7f17e650a4feaeb1c577))
* **typesetters:** Implement hbox building logic in the typesetter ([0f5bc69](https://github.com/sile-typesetter/sile/commit/0f5bc69981140553374ae2c5cc30f0fff913cf61))


### Bug Fixes

* **build:** Distribute SVG and FTL source files in packages ([7cef0ea](https://github.com/sile-typesetter/sile/commit/7cef0ea5f9303b32d4f54783498ada68f79b010c))
* **classes:** Avoid justification issues with relative parindent ([3ffd272](https://github.com/sile-typesetter/sile/commit/3ffd27220afa78e061fb0cc23663a9a9b82e0ac8))
* **classes:** Make sure un-numbered chapters make it in the ToC ([e5af292](https://github.com/sile-typesetter/sile/commit/e5af2922c99bd7458dba786fd6ecea4b82f69bb2))
* **classes:** Parse bare number and percentage units in docbook images ([8b965b9](https://github.com/sile-typesetter/sile/commit/8b965b9a8f95da2bdc22e20ba33aa4d3c4b7043b))
* **classes:** Setting current.hangIndent is a measurement ([e213d6e](https://github.com/sile-typesetter/sile/commit/e213d6e3d9a2b6e231743a03def660cfcc16a193))
* **cli:** Return success if --help explicitly requested ([#1737](https://github.com/sile-typesetter/sile/issues/1737)) ([35a229d](https://github.com/sile-typesetter/sile/commit/35a229d22b0c527b288c04a27379beab67ee8f9a))
* **core,typesetter:** Discretionary nodes are incorrectly handled ([dd7d05c](https://github.com/sile-typesetter/sile/commit/dd7d05c86c9eea2da17421fe09f9ae1261f0c23e))
* **core:** Ensure restoring settings top-level state does not error ([fce8447](https://github.com/sile-typesetter/sile/commit/fce84479a00a402f80d2f16ec71a1dc3e49a047e))
* **outputters:** Update Cairo/Podofo hbox debug API to match libtexpdf ([#1703](https://github.com/sile-typesetter/sile/issues/1703)) ([607dcf7](https://github.com/sile-typesetter/sile/commit/607dcf7b3d8a83547779758cb70f6285a07c4848))
* **packages:** Correct image aspect preservation logic ([6ace5b1](https://github.com/sile-typesetter/sile/commit/6ace5b19d4b88ba406c353fd86b3edc70d4952c1))
* **packages:** Fix output of debug breaks in infonode package ([#1725](https://github.com/sile-typesetter/sile/issues/1725)) ([c8a1467](https://github.com/sile-typesetter/sile/commit/c8a1467494b6cbcf3582c56598cb68f55c11df83))
* **packages:** Make sure pullquotes start in block mode ([#1774](https://github.com/sile-typesetter/sile/issues/1774)) ([00151bc](https://github.com/sile-typesetter/sile/commit/00151bc13b85dcc5a43dae0737599de8c32de25f))
* **packages:** Strip content position in ToC entries ([#1739](https://github.com/sile-typesetter/sile/issues/1739)) ([23345ea](https://github.com/sile-typesetter/sile/commit/23345ea0f7740a3779adeb3dad6c9ce7cdd82c3b))
* **packages:** Text conversion in bookmarks has spacing issues ([7ef2bb4](https://github.com/sile-typesetter/sile/commit/7ef2bb42cde4f752ecaabc29cf85e362691a3c02))
* **typesetter:** Account for discretionary dimensions in hbox building ([91cb950](https://github.com/sile-typesetter/sile/commit/91cb950c3b603f3154dc0aac1585f6cf2c1df127))
* **typesetter:** Avoid initializing new line during hbox creation ([ae455a1](https://github.com/sile-typesetter/sile/commit/ae455a1b17eae5d1dd22b0ee4bca4f19f383af14))
* **typesetter:** New typesetter instances shall not reset settings ([16d8a6a](https://github.com/sile-typesetter/sile/commit/16d8a6a028bbfbbd808d255182e5ca3aa327b193))
* **typesetter:** Skip lines containing only discardables without ignoring next lines ([9c3dc65](https://github.com/sile-typesetter/sile/commit/9c3dc6510ba36a356c95b8c4354ecd41234e645e))
* **typesetter:** Top glues shall be skipped when streching/shrinking a page ([8818a24](https://github.com/sile-typesetter/sile/commit/8818a24b6f69e0835b23ca813b69a9576309582a))
* **typsetter:** Hack around scoping issues for parindent setting ([fc85298](https://github.com/sile-typesetter/sile/commit/fc852981396426eec0e76dfea9187939856fa8ed))
* **utilities:** Enforce stricter type casts (SU.cast, SU.boolean) ([a325eb7](https://github.com/sile-typesetter/sile/commit/a325eb7adee72b6700e9405415747e6be9671aef))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.9
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.8...v0.14.9
  [mfekf]: https://mfek.org/foundation/
  [hbversions]: https://repology.org/project/harfbuzz/versions
