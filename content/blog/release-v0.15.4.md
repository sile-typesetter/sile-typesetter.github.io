+++
title = "SILE v0.15.4 Is Released"
date = "2024-06-28"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.4 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The dust finally settled on the big [v0.15.0][] release.
This patch does include a few more build system touch ups affecting the source tarball that made in require automake when it didn't really need it.
But the impetus for this release is actually new features and typesetter bug fixes.

On the language front, [João Quinaglia](https://github.com/jodros) has jumped in with some more domain expertise and Portuguese should now fully support hyphenation of Brazilian locale specific patterns.
Additionally we fixed two bugs in the localization system.
The locale set for Fluent localizations now properly tracks the document language at any given moment whether set by a font or even a Latin interjection in a bibliography.

Speaking of bibliographies, [Didier Willis](http://github.com/Omikhleia) is in the middle of a deep overhaul of our bibliography handling.
This release has a number of features and bug fixes that lay some groundwork for better parsing and handling bibtex files.
More fixes and features are also in progress and even ready for testing.
If you have any interest in bibliographies feel free to review ongoing issues and PRs in the [bibliography cleanup project][bibliography].

### New Features

* **build:** Add a developer target to test build dist without automake ([7bdaf16](https://github.com/sile-typesetter/sile/commit/7bdaf16564d96a0755ce112f448ee9eaeeaf7059))
* **languages:** Add Brazilian Portuguese specific hyphenation points ([895c575](https://github.com/sile-typesetter/sile/commit/895c575e55974e4485701e04256516d130cc66f8))
* **packages:** Biblatex data inheritance and field mapping ([646e3a4](https://github.com/sile-typesetter/sile/commit/646e3a4ef613d13db9491b87127f01d28f549b23))
* **packages:** Support `[@string](https://github.com/string)` syntax in bibTeX bibliography ([63083ad](https://github.com/sile-typesetter/sile/commit/63083addace0925eb5d83803a1a86465d84cf797)), closes [#2051](https://github.com/sile-typesetter/sile/issues/2051)
* **packages:** Support `[@xdata](https://github.com/xdata)` entry type and xdata field in bibTeX bibliography ([ca906f0](https://github.com/sile-typesetter/sile/commit/ca906f0cfc882c5ad4ecb410f6aec001018b64a8))
* **packages:** Support crossref field in bibTeX bibliography ([c4ae919](https://github.com/sile-typesetter/sile/commit/c4ae919ed72bce5740cb59809be8557dfe9b9321)), closes [#2021](https://github.com/sile-typesetter/sile/issues/2021)
* **tooling:** Add developer target to build Rust API docs ([384fa46](https://github.com/sile-typesetter/sile/commit/384fa463d71c6a7ecd24befd5670376874ce465f))

### Bug Fixes

* **build:** Avoid building sile binaries if not using them ([bbde8e6](https://github.com/sile-typesetter/sile/commit/bbde8e663dcd65262104c9bc32a10e28c3166e43))
* **build:** Avoid the perceived need for an extra automake cycle in dist tarball ([f634a60](https://github.com/sile-typesetter/sile/commit/f634a606b8d6973e2815d7f769b0205d27ba0e3b))
* **build:** Do not distribute main man page, requires Rust tooling ([26a6346](https://github.com/sile-typesetter/sile/commit/26a63463346a73eec38062984a8fec75761238b7))
* **build:** Don't distribute distfiles list with configure option specific output ([b9d95fd](https://github.com/sile-typesetter/sile/commit/b9d95fdac11ed3e783520dd2b66690db52bad299))
* **build:** Flag transitive dependency on Git if *not* using system LuaRocks ([ea2d501](https://github.com/sile-typesetter/sile/commit/ea2d501b65f1980c8b88b47dc9eedf6358f24453))
* **languages:** Always set Fluent locale when setting `document.language` ([283fdc3](https://github.com/sile-typesetter/sile/commit/283fdc3062313394850cf5067c846db82f264c2e))
* **packages:** Correct handling of ampersands and tildes in bibtex ([aaa613f](https://github.com/sile-typesetter/sile/commit/aaa613f636e6c892c70ea560a0815999ee617b2e)), closes [#2050](https://github.com/sile-typesetter/sile/issues/2050) [#1860](https://github.com/sile-typesetter/sile/issues/1860)
* **packages:** Ignore `@preamble)` in bibTeX bibliography ([742a0c4](https://github.com/sile-typesetter/sile/commit/742a0c425787819c2cd14b950d5b7959669c86a6)), closes [#2051](https://github.com/sile-typesetter/sile/issues/2051)

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.4
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.3...v0.15.4
  [v0.15.0]: @/blog/release-v0.15.0.md
  [bibliography]: https://github.com/orgs/sile-typesetter/projects/12
