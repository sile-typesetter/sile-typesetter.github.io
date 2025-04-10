+++
title = "SILE v0.15.11 Is Released"
date = "2025-04-10"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.11 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release isn't ground breaking, but it is line breaking.
A major bug in our hyphenation algorithm went undetected for a long time because (by a virtue of a bug canceling out a bug) it didn't happen to affect English or Turkish—far and away the most utilized languages in SILE's history.
But it did affect French, where [Didier Willis](http://github.com/Omikhleia) found and squashed it.
Hyphenation minima settings should be properly set for many other languages now and follow the current language.
Several languages also got hyphenation pattern updates.

In other minor details, length and measurement types no longer silently 'succeeds' when asked to parse non-compliant input.
Additionally disabling the (default on) `variablespaces` setting will actually take effect now and not continue to use any of the related settings in some contexts.

### New Features

* **cli:** Include deps file itself as output target so it gets remade ([696aafe](https://github.com/sile-typesetter/sile/commit/696aafe5fdd17eff296d869662126405d32373c2))
* **languages:** Update hyphenation patterns for Bulgarian ([e1bd96e](https://github.com/sile-typesetter/sile/commit/e1bd96e03ed30b94a0086f1ec986e4e86cc31798))
* **languages:** Update hyphenation patterns for el/grc ([e5e30d6](https://github.com/sile-typesetter/sile/commit/e5e30d60b60b9e92773e51ba39cccd912ed3245f))
* **languages:** Update hyphenation patterns for Portuguese ([1298af4](https://github.com/sile-typesetter/sile/commit/1298af4aaa46355479b1a04d78cd29eb89d1bca5))
* **languages:** Update hyphenation patterns for Spanish ([cf289b6](https://github.com/sile-typesetter/sile/commit/cf289b6cd13b3873e0aa7b8674cb3d1fa9fbcba2))
* **languages:** Update hyphenation patterns for Thai ([4abed66](https://github.com/sile-typesetter/sile/commit/4abed66a516b47952fbf51366b381b4fade10836))
* **packages:** Add revert for space handling bug fix to retrograde ([951e47e](https://github.com/sile-typesetter/sile/commit/951e47ea42db33cb24abf1d0633db028aaafd7e2))


### Bug Fixes

* **cli:** Correctly output makedeps files from the Rust CLI the same as from Lua ([42a879a](https://github.com/sile-typesetter/sile/commit/42a879a0b5f4a4615926cc224f1dc71380117356))
* **cli:** Pass current binary name of Rust wrapper through for errors and make-deps ([62820ce](https://github.com/sile-typesetter/sile/commit/62820cee998fd1538bb0365f3f1223b815975bb1))
* **core:** Error on excess unparsable input on measurements and lengths ([#2260](https://github.com/sile-typesetter/sile/issues/2260)) ([4d33389](https://github.com/sile-typesetter/sile/commit/4d333899f3c076d07a2863b56411026aa69ee0d5))
* **hyphenators:** Correctly apply hyphenation minima, isolate per language ([6143d54](https://github.com/sile-typesetter/sile/commit/6143d54652ad5cdf82e4ca5d528de1c78a52e69c))
* **languages:** Set proper hyphenation minima for Esperanto ([a014353](https://github.com/sile-typesetter/sile/commit/a01435353c59bf9e4a450988df52981194cf5c35))
* **outputters:** Update cairo backend to work with current API ([13bd9d4](https://github.com/sile-typesetter/sile/commit/13bd9d48c2ea62073a13e7df33dd3c70553f7474))
* **shapers:** Actually disable variablespaces if setting set to false ([a6628b5](https://github.com/sile-typesetter/sile/commit/a6628b5f4234ed4e11af2623afc05127727eae69))
* **shapers:** Update pango shaper to work with current API ([541cb8d](https://github.com/sile-typesetter/sile/commit/541cb8dae33f074a1e322c593303daeae91d9336))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.11
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.10...v0.15.11

