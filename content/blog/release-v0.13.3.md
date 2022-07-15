+++
title = "SILE v0.13.3 Is Released"
date = "2022-07-15"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.13.3 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The upcoming v0.14.0 is chock full of changes (hopefully all for the better!) and but several small issues have cropped up and there isn't any point in inconveniencing existing users with bugs we're fixed while we work on new features.
This should fix up some issues with includes including activating exported functions and not getting blocked when both directories and files of the same name exist.
The Nix Flake will now work with the new Nix 2.10.x releases.

Additionally [Didier Willis](http://github.com/Omikhleia) contributed some fixups and features to the Bibtex package to make it much more usable.


### Features

* **packages:** Add minimal support for usual BibTeX types (bibtex) ([292a2f2](https://github.com/sile-typesetter/sile/commit/292a2f2b2367a93a97add70fa42191b5b5bb800c))


### Bug Fixes

* **build:** Update Flake to work with Nix >= 2.10 ([3d5a18c](https://github.com/sile-typesetter/sile/commit/3d5a18cf8b202060e6c884fa3d73150f0aec9e58))
* **core:** Avoid duplicate paths blocking directory searches ([7a7209f](https://github.com/sile-typesetter/sile/commit/7a7209fff9fb0b2ca8a59816dae55e201b0c1208))
* **core:** Avoid error when outputting overflow warnings with specific measurements ([cb51ed5](https://github.com/sile-typesetter/sile/commit/cb51ed525684fab85c99e29474e0ba58806ba1ac)), closes [#945](https://github.com/sile-typesetter/sile/issues/945)
* **outputter:** Non-RGB colors shall work with the debug outputter ([#1469](https://github.com/sile-typesetter/sile/issues/1469)) ([41fbdf4](https://github.com/sile-typesetter/sile/commit/41fbdf44659385171f813576373be36556023a73))
* **packages:** BibTeX types/tags are case-insensitive, etc ([61c1fc6](https://github.com/sile-typesetter/sile/commit/61c1fc6209bfbfffa38a05f9d3986bfb50c8a840))
* **packages:** Make \script command properly initialize packages ([9ded7e1](https://github.com/sile-typesetter/sile/commit/9ded7e1c2aaa03cb4da25ff2ef49c15d40497f9a))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.13.3
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.13.2...v0.13.3

