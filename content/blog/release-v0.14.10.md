+++
title = "SILE v0.14.10 Is Released"
date = "2023-07-11"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.10 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Not all releases bring groundbreaking changes.
This one is a roll-up of bits and bops.
A few small quality of live improvements, some localizations, some bug fixes, some conveniences for 3rd party package developers, and so forth.
Enjoy.


### Notes about the Future

If you're looking for messy fun, check out the [riir][riir] branch and [PR#1762][rustypr].
As the name suggests, this is a major project overhaul based in Rust.
Have no fear!
Everything is still fully customizable in Lua.
We have no plans of taking away that flexibility.
The current proof of concept is a CLI binary is Rust that provides it's own Lua interpreter (optionally linked to the system one or completely vendored).
This normalizes the environment, allows targeting environments where Lua is hard to get running, allows parts of the system to be selectively coded in Rust for speed benefits, etc.
The PoC already passes 100% of the existing tests, loads 3rd party packages as usual, and is a full drop in replacement for the current Lua based CLI.
As of this writing the plan is to land this new CLI in v0.15.0, potentially enabling easy(er) installation on Windows in follow up releases.

If you are a 3rd party developer, by sure to keep an eye on your Lua support.
SILE already supports Lua versions 5.1.x through 5.4.x and well as LuaJIT.
The same range of support is already achievable at build time in the Rust CLI.
The LuaJIT provides the usual massive improvement in speed.
We plan to push for this to be the default option in distro packages in the future even on platforms where the default Lua interpreter is 5.4.
Making sure your packages run under the existing LuaJIT support should future proof them to easily transition to the Rust based SILE builds.


### Features

* **cli:** Allow more than one input document ([d20cbd8](https://github.com/sile-typesetter/sile/commit/d20cbd8a0b7a197ca87ca1dd1a39640fa746e301))
* **i18n:** Add localized strings for Cantonese and Chinese ([cb67d36](https://github.com/sile-typesetter/sile/commit/cb67d3686117258adaca546298063d23c66135f9))
* **packages:** Add document class styling in autodoc ([e70fa50](https://github.com/sile-typesetter/sile/commit/e70fa509673c32977a1e1f0545373229198c8aa8))
* **packages:** Provide API for registering raw handlers linked to packages ([45cd3ac](https://github.com/sile-typesetter/sile/commit/45cd3ac96acbe3f2dd572ce0c3c72c7599090e6b))


### Bug Fixes

* **build:** Avoid build artifacts being listed for installation ([29c2ccd](https://github.com/sile-typesetter/sile/commit/29c2ccd227774caa4accb90bb0d23825aafccfd1))
* **core:** Avoid stack overflow in Harfbuzz module ([#1793](https://github.com/sile-typesetter/sile/issues/1793)) ([5001efe](https://github.com/sile-typesetter/sile/commit/5001efe0cfeb421ce5796f8303bf046bb68c8326))
* **outputters:** Setup --makedeps to play along without explicit --output ([6ff2e16](https://github.com/sile-typesetter/sile/commit/6ff2e16f24224bc2781edc38be8cb9e1418fb30e))
* **packages:** Converters package no longer worked after 0.13.0 ([433795c](https://github.com/sile-typesetter/sile/commit/433795c3979688469a098a9966a595a4b0d34818))
* **packages:** Correct chord line height and chord font use ([65961c6](https://github.com/sile-typesetter/sile/commit/65961c6629244817220bac8a6f386a9a738b7f0b)), closes [#1351](https://github.com/sile-typesetter/sile/issues/1351)

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.10
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.9...v0.14.10
  [riir]: https://github.com/alerque/sile/tree/riir
  [rustypr]: https://github.com/sile-typesetter/sile/pull/1762
