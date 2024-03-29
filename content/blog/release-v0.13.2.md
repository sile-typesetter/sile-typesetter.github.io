+++
aliases = ["2022/06/sile-0-13-2-is-released"]
title = "SILE v0.13.2 Is Released"
date = "2022-06-29"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.13.2 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This patch release brings both bug fixes and new goodies.

[Didier Willis](http://github.com/Omikhleia) contributed a new package for formatting lists.
Features include bullet, numbered, and mixed list types with many styling options.

[Fredrick Brennan](http://github.com/ctrlcctrlv) fixed zenkaku unit handling and helped refactor the jplain/jbook classes so we now have tate-capable but language-agnostic tplain/tbook classes in addition to the Japanese specific variants.
He also contributed full support for Esperanto including hyphenation, number formatting, and localized output strings.
Even if you don’t have a use case for Esperanto directly the issues that rooted out with language and class handling should benefit everyone.

The `papersize` option provided by the base class is now case insensitive and allows dashes.
If you prefer `A4` to `a4` or `ANSI-A` to `ansia` feel free to use them.
A couple new paper size presets were added in the process.

Additionally the font fallback system got an overhaul.
A change from previous behavior is that TOFU handed out by the last available fallback font will be rendered instead of skipping the characters completely.
Switching back and forth between the color fonts package and the font fallback package is now possible.
Finally it should stop throwing bogus warnings when it successfully shapes a segment via the last available fallback.

Other minor fixes include interactions with color plus dropcaps, some bibtex errors, and errors in the pecha class.

### Features

* **core:** Add presets for some ANSI paper sizes and ArchE variants ([0f26756](https://github.com/sile-typesetter/sile/commit/0f267563c6f674d61c91485f771e825e83489590))
* **languages:** Add full Esperanto language support ([b740709](https://github.com/sile-typesetter/sile/commit/b7407090ab4feac9107454db0f328c3d886a0631))
* **packages:** Add 'lists' package (bullets and enumerations) ([6af3c62](https://github.com/sile-typesetter/sile/commit/6af3c62822ac334c64e2c46d8def11c51a017093))
* **packages:** Add more options for custom 'lists"' styling ([3167410](https://github.com/sile-typesetter/sile/commit/316741033da7edff44cb933a311f3b5080b763c7))
* **packages:** Handle font fallback when glyph named null returned on shape falure ([09c0a86](https://github.com/sile-typesetter/sile/commit/09c0a8647105bbddac155f3414cda2bc481a86ca))
* **packages:** Pass through font-specific options to fallback fonts ([fb29442](https://github.com/sile-typesetter/sile/commit/fb2944233ea13e10729ada47aa8b72db44ea8a30))

### Bug Fixes

* **classes:** Clarify the scopes of `tate` and `jplain` ([db83e9e](https://github.com/sile-typesetter/sile/commit/db83e9ede06dedf89112a7d9d76e185df90f6dba))
* **classes:** Fix circular reference in pecha class ([4501ec0](https://github.com/sile-typesetter/sile/commit/4501ec07cb0ec5183485fb39b965d8267cf176e0))
* **classes:** Fix diglot and triglot class instantiation ([71af1a9](https://github.com/sile-typesetter/sile/commit/71af1a94b41e3d86715a369092d1ea6ffeeb6a5b))
* **core:** Make paper size parser case insensitive, e.g. 'a4' or 'A4' ([af441c8](https://github.com/sile-typesetter/sile/commit/af441c8b381cae3ea18169105e951d60fcb5255f))
* **measurements:** Move the zenkaku width (zw) unit into core ([cfe5060](https://github.com/sile-typesetter/sile/commit/cfe506001387a81f37dd9612444b066e138ba179))
* **packages:** Correct fall-back font processing ([d3cc59b](https://github.com/sile-typesetter/sile/commit/d3cc59b9f32eefd06780f4984d066007283434dc))
* **packages:** Correct package load path for colored dropcaps ([41a0c17](https://github.com/sile-typesetter/sile/commit/41a0c17bee08f1e127b3d1cd4f3ee9cc4283aeac))
* **packages:** Fix coding errors in untested corners of bibtex package ([804b1a5](https://github.com/sile-typesetter/sile/commit/804b1a548615054cf810850d1c5cd01ad20c47fb))
* **packages:** Fix loading TOC twice resetting pdf links ([97797b8](https://github.com/sile-typesetter/sile/commit/97797b89b7cc195f1011495ec87ad1b94121464e))
* **shaper:** Handle switching between color & fallback shapers in single document ([04f2d5d](https://github.com/sile-typesetter/sile/commit/04f2d5df94373cc75e02b51f5847d7247a2025e7))
* **utilities:** Raise Lua error instead of manually aborting if inside pcall() ([6e70a17](https://github.com/sile-typesetter/sile/commit/6e70a17562f298234e85862df30d12dfdc963f48))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.13.2
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.13.1...v0.13.2
