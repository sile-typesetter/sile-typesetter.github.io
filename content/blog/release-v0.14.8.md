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

Enabling this significant step forward requires the font subsetter support introduced in HarfBuzz 6.
This is a new default minimum requirement for SILE.
At the time of writing this is relatively new, although many platforms [already have updates available][hbversions].
It is possible to build against older HarfBuzz versions by using the configuration option `--disable-font-variations`.
When built this way SILE will continue to run on platforms with old HarfBuzz releases but will throw an error if you attempt to render a document using variable font features.

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.8
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.7...v0.14.8
  [variations]: https://fonts.google.com/knowledge/introducing_type/introducing_variable_fonts
  [mfekf]: https://mfek.org/foundation/
  [hbversions]: https://repology.org/project/harfbuzz/versions
