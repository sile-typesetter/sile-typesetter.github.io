+++
title = "SILE v0.14.15 Is Released"
date = "2024-01-27"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.15 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

In today's minor release we tinker with language support.

[Didier Willis](http://github.com/Omikhleia) contributed improvements to non-breaking space handling in French.
He also setup handling of Catalan hyphenation at ela geminada and Polish hyphenation at existing hyphens.
Turkish gained a new setting (on by default per the current Turkish Language Association guidelines) for handling hyphenation at apostrophes.
The previous behaviour (used by some publisher style guides) is available by toggling off the new setting.

All languages gained an (on by default) setting that makes spaces after em-dashes at the start of paragraphs be fixed width.
This is used in at least French and Turkish typography to typeset dialogue and the fixed spacing keeps everything lining up per expectations.
Other languages may benefit as well, but also the feature can be disabled if flexible spacing is actually desired.

Details for each of these languages and their related settings are in the SILE manual.


### Features

* **languages:** Accomodate alternate Turkish hyphenation guidelines at apostrophes ([92904fc](https://github.com/sile-typesetter/sile/commit/92904fcaf119cb95633c2865c2cdef89106803a1))
* **typesetters:** Support for speaker change introduced by em-dash ([2afa4cb](https://github.com/sile-typesetter/sile/commit/2afa4cbf7eafcc9efef4ea5219c9508fff7989a8))


### Bug Fixes

* **languages:** Break at ela geminada in Catalan cancels the punt vola ([f8c4c1e](https://github.com/sile-typesetter/sile/commit/f8c4c1e46fecfb4f3bb7000ae0e87d04eb5d2738))
* **languages:** Break at explicit hyphen in Polish repeats the hyphen ([0f8c7aa](https://github.com/sile-typesetter/sile/commit/0f8c7aa087c6fe447fc0a5d96944e9ca1b7f141e))
* **languages:** Remove multiple repetitions of U+00A0 nbsp in French ([0356a49](https://github.com/sile-typesetter/sile/commit/0356a4977722c77e11ada667efb106d9ad70219a))
* **languages:** U+00A0 nbsp in French causes unexpected word breaks ([b93975c](https://github.com/sile-typesetter/sile/commit/b93975c2d572d64afbc89c47cab8cc3ad4735445))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.15
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.14...v0.14.15
