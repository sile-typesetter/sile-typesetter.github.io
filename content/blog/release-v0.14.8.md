+++
title = "SILE v0.14.8 Is Released"
date = "2023-01-26"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.8 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

If you have extra cake in storage just waiting for something worth celebrating, this might be a good release to bust it out for.
[Khaled Hosny](https://github.com/khaledhosny) has contributed a major new feature: support for [variable fonts][variations]!
This contribution was supported by a bounty grant from the [MFEK Foundation][mfekf].
Many thanks to both Khaled and [Fredrick Brennan](https://github.com/ctrlcctrlv) for making this possible.

Enabling this significant step forward requires the font instancing support introduced in HarfBuzz 6 (part of the `harfbuzz-subset` library).
This is a new default minimum requirement for SILE.
At the time of writing this is relatively new, although many platforms [already have updates available][hbversions].
It is possible to build against older HarfBuzz versions by using the configuration option `--disable-font-variations`.
When built this way SILE will continue to run on platforms with old HarfBuzz releases but will throw an error if you attempt to render a document using variable font features.


### Features

* **build:** Pass build time configuration into Lua environment ([c5d8789](https://github.com/sile-typesetter/sile/commit/c5d8789cb1096a3d597da49475c7e4ceaa94f603))
* **core:** Add variations support to font command ([a37e7bc](https://github.com/sile-typesetter/sile/commit/a37e7bc61c44e85a678e3b5d40b29eedbc151368))
* **shapers:** Instanciate variable fonts ([d50881f](https://github.com/sile-typesetter/sile/commit/d50881fd1709ba0d5db52107d5e15d1db8da032b))
* **shapers:** Support named instances with FontConfig ([29119b9](https://github.com/sile-typesetter/sile/commit/29119b9da844825e78dabd0edebb9d9ef7b642a6))
* **shapers:** Support named instances with macfonts ([39a3242](https://github.com/sile-typesetter/sile/commit/39a324250e0b058585411ab8c91aec6e34e2545b))


### Bug Fixes

* **build:** Package license file for vendored lunamark fork ([#1686](https://github.com/sile-typesetter/sile/issues/1686)) ([13df3c1](https://github.com/sile-typesetter/sile/commit/13df3c1f56ea5e68067b4ce00efc198b07de857c))
* **classes:** Coerce option values to booleans ([#1696](https://github.com/sile-typesetter/sile/issues/1696)) ([8368cb4](https://github.com/sile-typesetter/sile/commit/8368cb4186d4743256daa0bc80e43688f7aa9a67))
* **packages:** Absolutize parskip heights on use ([1ac793f](https://github.com/sile-typesetter/sile/commit/1ac793fba01c07e7a5225503f34307358015e7a8))
* **packages:** Pass style & weight values to the math font loader ([c92712f](https://github.com/sile-typesetter/sile/commit/c92712f13536a964056338384d4fb2dabb9dd0ac))
* **packages:** Quote option values in documentation when necessary ([41e47bb](https://github.com/sile-typesetter/sile/commit/41e47bb88c56b0a52e3e3301a29d97fd48707bd9))
* **tooling:** Use `luaEnv` properly ([#1679](https://github.com/sile-typesetter/sile/issues/1679)) ([a34e1c1](https://github.com/sile-typesetter/sile/commit/a34e1c15fe1a5a592ad338281cbdc30f99ec68a0))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.8
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.7...v0.14.8
  [variations]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts
  [mfekf]: https://mfek.org/foundation/
  [hbversions]: https://repology.org/project/harfbuzz/versions
