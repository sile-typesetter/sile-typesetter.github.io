+++
title = "SILE v0.14.7 Is Released"
date = "2022-12-30"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.7 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Some of the changes that came out in v0.14.6 were … less than optimal.
The build system changes were for a good purpose, but made life a bit difficult for some distro packagers.
I also managed to introduce a parsing regression.
It also came to light that a previous API deprecation didn't come with the usual warning and shim for transitional support.

This release is notable for distribution packagers for two reasons.
First, there is now an easier way to skip the font dependency check at build time.
Second, this release is the first time using LuaJIT is at 100% parity with regular Lua.
If your distro has LuaJIT available there is now little reason not to make the switch.¹
The speed increase is substantial, especially for large documents.²

While I was tinkering with smoothing out the build and fixing regressions a couple other fixes landed.
[Khaled Hosny](https://github.com/khaledhosny) tackled a long standing issue with the font loader.
The `opsz` axis can now be used as expected so fonts with OpentType FeatureVariations are usable in SILE.
[raphCode](https://github.com/raphCode) also spotted and fixed some outdated code in the manual.

<sub>¹:
As far as SILE core and all its Lua dependencies are concerned there is no downside.
Previously some of the debug and tracing features did not give as much useful information when using LuaJIT.
Now the only caveat is related to end users and their documents.
If people write custom Lua code in their projects and/or use other 3rd party Lua libraries they will need to consider interpreter support.
</sub>

<sub>²:
As a rough comparison on my desktop machine, rendering the 115 page SILE manual takes about 48 seconds with Lua 5.4, 22 seconds with LuaJIT, and 17 seconds with OpenResty.
</sub>


### Features

* **build:** Allow easy skip of font checks with FCMATCH=true ([5c0cef6](https://github.com/sile-typesetter/sile/commit/5c0cef6bc11d0ac353e92557212aa16842f3de68))


### Bug Fixes

* **build:** Only check tooling to bulid manual if really needed ([e166e00](https://github.com/sile-typesetter/sile/commit/e166e0063b0b6c49040cc5c3759cd0a68162ef15))
* **inputters:** Rework SIL input to handle both junk outside of document tag and fragments ([4c51c55](https://github.com/sile-typesetter/sile/commit/4c51c557034dd618ad1e68799f9de1db76c4f262))
* **outputters:** Patch up error message when failing to load font ([#1671](https://github.com/sile-typesetter/sile/issues/1671)) ([771d87f](https://github.com/sile-typesetter/sile/commit/771d87f24fa0f4599655fba23bcade15a7a5e7cb))
* **shaper:** Correct font-variants using opsz axis ([#1666](https://github.com/sile-typesetter/sile/issues/1666)) ([a929583](https://github.com/sile-typesetter/sile/commit/a9295838e2639dee9fde71d29717957deaf650d5))
* **shaper:** Respect variations when shaping ([#1265](https://github.com/sile-typesetter/sile/issues/1265)) ([#1662](https://github.com/sile-typesetter/sile/issues/1662)) ([f50ae77](https://github.com/sile-typesetter/sile/commit/f50ae77d37003349936b3236de95c410155f6209))
* **tooling:** Keep all Lua packages in same env for Nix ([8fc8670](https://github.com/sile-typesetter/sile/commit/8fc867013db91cfbe591ab6815cf4ee5768c8982))
* **utilities:** Tweak breadcrumbs to work under LuaJIT limitations ([32f744c](https://github.com/sile-typesetter/sile/commit/32f744c5c493fa258498458e46e54c549ac61da8))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.7
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.6...v0.14.7
  [mfekf]: https://mfek.org/foundation/
