+++
aliases = ["2020/01/sile-0-10-1-is-released"]
title = "SILE v0.10.1 Is Released"
date = "2020-01-24"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.1 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This is a small follow up to the [v0.10.0](@/blog/release-v0.10.0.md) release last week to fix a regression that cropped up and add deprecation warning messages. The last release went out with several major changes, particularly to the node and length APIs. Compatibility shims are in place so that old code still works for now, but this adds warning messages to make it easier to find and track down things that need updating.

Additionally since the last release cycle Docker images have been made available, and now support mapping system fonts into the Docker image.

### Notable Bug Fixes

* **backends:** Implement cursor tracking to roughly simulate glues ([26afcec](https://github.com/sile-typesetter/sile/commit/26afcec76912f88cc25bbeb70a6cc8850d999516))
* **core:** Actually deprecate old nodefactory instantiators ([774f0fc](https://github.com/sile-typesetter/sile/commit/774f0fce2c3ac6519f9fb98d91f71daa5aa88d8e))
* **measurements:** Actually deprecate old constructors ([bfdb1b8](https://github.com/sile-typesetter/sile/commit/bfdb1b86986968e3f9d132fae1e4cb01b9623d9d))
* **nodes:** Fix pushHbox() regression, recognize zerohoxes ([#789](https://github.com/sile-typesetter/sile/issues/789)) ([dae51f1](https://github.com/sile-typesetter/sile/commit/dae51f1d8d993647220a61dbdde59caa670d10ba))

### New Features

* **backends:** Approximate space and break in text output to PDF ([9577ae4](https://github.com/sile-typesetter/sile/commit/9577ae4610a2a70f50078b7f0789bf842ab8ef1d))
* **docker:** Add dockerfile and setup to build an image ([4424d44](https://github.com/sile-typesetter/sile/commit/4424d4469905edf43815464d74229184b4710aad))
* **docker:** Add method to inject fonts into Docker container ([104124a](https://github.com/sile-typesetter/sile/commit/104124a1d9019399561c7c64e9590a3175de6ce3))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.1
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.0...v0.10.1
  [wiki]: https://github.com/sile-typesetter/sile/wiki
