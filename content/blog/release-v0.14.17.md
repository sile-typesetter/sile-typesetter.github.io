+++
title = "SILE v0.14.17 Is Released"
date = "2024-02-07"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.17 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The "big v0.15" is still brewing, but we keep coming up with little improvements that easily fit in the v0.14 series.
It turns out the special hyphenation handling we added to Polish (for explicitly hyphenated words) is used by quite a few languages.
At this time we've applied it by default to Croatian, Czech, Portuguese, Slovak. and Spanish.
Thanks to [Didier Willis](http://github.com/Omikhleia) for much of the research on this as well as [João Quinaglia](https://github.com/jodros), [David Rowe](https://github.com/DavidLRowe), [Jakub Kaczor](https://github.com/jakubkaczor), and [Thomas Vl](https://github.com/tomas-vl) for domain expertise.

Additionally João contributed an option for columns command to more easily set up column frames with balancing turned on or off.

### Features

* **languages:** Enable explicit hyphen repetition handling in Croatian ([c29545d](https://github.com/sile-typesetter/sile/commit/c29545dd6f60bc01dc71de82f88274feff3b0fdf))
* **languages:** Enable explicit hyphen repetition handling in Czech ([b05d621](https://github.com/sile-typesetter/sile/commit/b05d6211b2c3daf9d8a69d7c4db75f430a86eea6))
* **languages:** Enable explicit hyphen repetition handling in Portuguese ([2a58d96](https://github.com/sile-typesetter/sile/commit/2a58d9684848ad7475e879191058d0c59de8e3c5))
* **languages:** Enable explicit hyphen repetition handling in Slovak ([82640b0](https://github.com/sile-typesetter/sile/commit/82640b03cdc82356a1ea9bbffbb4f5fd2471e3a2))
* **languages:** Enable explicit hyphen repetition handling in Spanish ([8db7f23](https://github.com/sile-typesetter/sile/commit/8db7f238fb63c86ee0d49bd34afd6a35a03f8eb8))
* **packages:** Add balancing option to makecolums command ([#1950](https://github.com/sile-typesetter/sile/issues/1950)) ([b5ce8e6](https://github.com/sile-typesetter/sile/commit/b5ce8e615c5e22c087ea8c8c6f7e30266e0f8634))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.17
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.16...v0.14.17
