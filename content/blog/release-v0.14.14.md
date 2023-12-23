+++
title = "SILE v0.14.14 Is Released"
date = "2023-12-23"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.14 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Merry Christmas!

Not this isn't the Rusty release you might want in your stocking.
That is coming along nicely though, we're just including an abitioun rollup of breaking changes and going slow to do it right.
You can [preview the release notes][v015blog] or follow issues in [the milestore][v015milestone] for teasers.
More notably there are already lots of ways to run the development release: Homebrew has `--HEAD` support, Docker images are available, the Nix flake works, Arch Linux has VCS packages, and more.
If you want to start putting it through the paces go ahead.

Until the cookies are fully baked, this minor release has a few goodies that are not breaking changes.
[Didier Willis](http://github.com/Omikhleia) contributed some updates to the `dropcaps` package to better handle fonts with descenders in their capitals.
He also contributed some improvements to Unicode handling: soft hyphen and non-breaking spaces work as expected.
SILE has perhaps more robust ways of defining custom hyphenation and glue nodes, but the Unicode handling is convenient is handy if you input content has such data anyway.
For bonus points some CLI error messages have been dramatically improved to be more informative and less repetative.


### Features

* **cli:** Change module load error to suggestion for how to install 3rd party modules ([c280050](https://github.com/sile-typesetter/sile/commit/c2800505eda2ee1630eea931f88efb07f6892d00))
* **languages:** U+00A0 non-breaking space must be stretchable by default ([b769a63](https://github.com/sile-typesetter/sile/commit/b769a633069db4f32746d920dc9696296c7ab7db))
* **typesetters:** Support U+00AD soft hyphen as discretionary break ([285507e](https://github.com/sile-typesetter/sile/commit/285507e5fddf3b0c752bb2b5bf81e8bf7f19144a))


### Bug Fixes

* **backends:** Fix plain text backend to work in LuaJIT/Lua 5.1 ([b185d49](https://github.com/sile-typesetter/sile/commit/b185d4972a5f29e7441f7af34e1ac49f49e6747f))
* **cli:** Stop outputting error messages twice on failure to process main file ([da5d609](https://github.com/sile-typesetter/sile/commit/da5d60902a4129deb79ae4658ba82757d7277b85))
* **core:** Use nil-safe and Lua-version-robust table utils ([2405b23](https://github.com/sile-typesetter/sile/commit/2405b23f0f448b217a066ecb34cae54f3e63aa64))
* **packages:** Adjust dropcap logic for letters with a depth ([fd6963d](https://github.com/sile-typesetter/sile/commit/fd6963d226cc6a3b325dd796414936d200ae1ed2))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.14
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.13...v0.14.14
  [v015blog]: https://github.com/alerque/sile-typesetter.github.io/blob/v015/content/blog/release-v0.15.0.md
  [v015milestone]: https://github.com/sile-typesetter/sile/milestone/34
