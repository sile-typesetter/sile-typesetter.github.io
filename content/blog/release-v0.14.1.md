+++
title = "SILE v0.14.2 Is Released"
date = "2022-08-06 22:54:45"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.2 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

It’s a slow news day, but these few little fixes touchup glitches introduced in the v0.14.0 release and generally improve the robustness of the new API interfaces.
Writing (and porting) classes should go just a bit smoother and behave more as expected now.

### Bug Fixes

* **classes:** Allow package option declarations to be reset ([215e83a](https://github.com/sile-typesetter/sile/commit/215e83a31f81a16e18eea8010512a44844f689c8))
* **classes:** Bring back space after subsection numbering ([70a3304](https://github.com/sile-typesetter/sile/commit/70a330424d17d4dc74ad0443e7b2064ddceaeb2b))
* **packages:** Check for user supplied commands before setting noops ([54b5071](https://github.com/sile-typesetter/sile/commit/54b5071df907b8c9d35a0ec356c673701a3c6025))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.2
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.1...v0.14.2
