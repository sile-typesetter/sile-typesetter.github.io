+++
title = "SILE v0.15.9 Is Released"
date = "2025-01-04"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.9 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release *actually* fixes build issues for macOS (Darwin) we tried to fix in v0.15.8 but were more involved than first suspected.
It also packages some CSL files that were missing from previous source distributions and touches up a few other odds and ends.

In non-build related changes, [Didier Willis](http://github.com/Omikhleia) patched up some bibliography behaviour.
As a cherry on top I patched up the ability to generate a completely blank PDF without throwing an error and changed the outputter API to include an official way to throw an error without also generating a blank PDF.

### New Features

* **outputters:** Add a method to handle empty PDFs vs. cleanup after error ([5a7694d](https://github.com/sile-typesetter/sile/commit/5a7694dfff369c820e1c5ef79336776efc6cf645))

### Bug Fixes

* **build:** Bundle XML and CSL resources with bibtex package ([#2201](https://github.com/sile-typesetter/sile/issues/2201)) ([73ffcd5](https://github.com/sile-typesetter/sile/commit/73ffcd537954175d30d0e0114389bbbc70db9482))
* **build:** Correct dependencies in non-embedded mode ([5805cd4](https://github.com/sile-typesetter/sile/commit/5805cd47abb89eef1b27b411341b4599b7622813))
* **build:** Re-organize rules so sources don't have platform detection artifacts ([15a20e0](https://github.com/sile-typesetter/sile/commit/15a20e034c10f31af8316aec75829a0febe0ffc0))
* **build:** Set correct final permissions on intermediary shell completion artifacts ([a3de042](https://github.com/sile-typesetter/sile/commit/a3de0423417101e204bd584c4e7865b4568e9bdd))
* **classes:** Avoid assuming legacy script tags will return a table ([d596d53](https://github.com/sile-typesetter/sile/commit/d596d5312dd9300dc9eb21c4b19d9827553cb633))
* **deps:** Bump luautf8 dependency to restore building against latest LuaJIT ([206f4b7](https://github.com/sile-typesetter/sile/commit/206f4b72e839b799c4f6f901dc47a8ddf117a14e))
* **docker:** Package bootstrap script so Docker images can be built from source tarballs ([15a18c0](https://github.com/sile-typesetter/sile/commit/15a18c0a4749d76190d0ecf4818f1221b4bba220))
* **packages:** CSL subsequent-author-substitute is optional ([680df8c](https://github.com/sile-typesetter/sile/commit/680df8cf4cb8038b034a564269687b13efae9cbb))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.9
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.8...v0.15.9
