+++
aliases = ["2020/11/sile-0-10-13-is-released"]
title = "SILE v0.10.13 Is Released"
date = "2020-11-30"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.13 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release brings a few bug fixes, most notably unscrambling Arabic (and some other complex script) shaping. Since current work in process includes significant changes to the document class API and these fixes have been sitting around for a while I figured it was time to give them a release number before anything potentially more disruptive lands.

Feature-wise the only significant improvement is complete coverage for all element types in the Pandoc document AST, enabling *any* converted documents to compile without errors. They might not be pretty out of the box yet, but at least they render and can be styled by adding or modifying commands.

### Features

* **classes:** Allow footnotes in plain class if package loaded ([42c1ceb](https://github.com/sile-typesetter/sile/commit/42c1cebcac07d5bc52fcb027e3055012fefc7dd9))
* **classes:** Run deferred package init() on late load ([0224fe3](https://github.com/sile-typesetter/sile/commit/0224fe369b7abd788999e271b5dfacfb929270b2))

### Bug Fixes

* **backends:** Add complex shaping data to debug backend ([a1a6509](https://github.com/sile-typesetter/sile/commit/a1a65099dcb398ccf61a8ed53d15a9678ca8cb2b))
* **backends:** Don't crash if debug output precedes regular ([19c21f2](https://github.com/sile-typesetter/sile/commit/19c21f24c097bcdc5728b00f73bb710a8598c3c0))
* **build:** Don't abuse libtool internals (for NetBSD packaging) ([#1084](https://github.com/sile-typesetter/sile/issues/1084)) ([048c8b5](https://github.com/sile-typesetter/sile/commit/048c8b58b9c58de104f84e89c19c983d5a0f71df))
* **classes:** Define \strong weight=700, not 600 ([#1097](https://github.com/sile-typesetter/sile/issues/1097)) ([68abf91](https://github.com/sile-typesetter/sile/commit/68abf914608b0ba1dcc680499f52b9dc3d48566b))
* **packages:** Add default options to simpletable ([1f10c97](https://github.com/sile-typesetter/sile/commit/1f10c97f7ce3b71642bd9519109ac5ac56f5613e))
* **packages:** Correct math operations on grid spacing ([5286188](https://github.com/sile-typesetter/sile/commit/5286188dfa0e73e5fad3ac7aa79c791bb0dcd2fd))
* **packages:** Turn off complex flag for items in \latin-in-tate ([b20690f](https://github.com/sile-typesetter/sile/commit/b20690f5501ff1adf2459e13e942f3e570b177d7))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.13
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.12...v0.10.13
  [wiki]: https://github.com/sile-typesetter/sile/wiki
