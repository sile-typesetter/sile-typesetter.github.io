+++
aliases = ["2020/07/sile-0-10-6-is-released"]
title = "SILE v0.10.6 Is Released"
date = "2020-07-16"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.6 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Most of the changes in this maintenance release are related to the build and packaging system, with a notable exception of the manual. Many more packages have been documented and the manual has seen quite a bit of copy-editing. For users of the *docbook* class, the default monospace font has changed from Dejavu Sans to Hack.

One new feature added to the TeXlike input language now allows single quotes to be escaped (`\"`) to appear in the value of options passed to a command.

In the installation department, two new option flags for `./configure` have been added, `--with-manual` and `--with-examples`. Both are off by default. Enabling these flags will cause a copy of the manual and examples respectively to be installed to your system’s `$docsdir`. These PDFs are included pre-built in the source package, but not installed anywhere by default.


### Features

* **build:** Add --with-examples option to configure & make ([245e8a6](https://github.com/sile-typesetter/sile/commit/245e8a6bff0b012bfa12a5a6f9bc7609a6b42af3))
* **build:** Add --with-manual option to configure & make ([3415b3a](https://github.com/sile-typesetter/sile/commit/3415b3a7a6557871698b0fe9d9f512a6adc2854e))
* **inputs:** Allow (escaped) quote mark in quoted command options ([2e9d1b5](https://github.com/sile-typesetter/sile/commit/2e9d1b5fe599e1c445a70ca2f4d957dfff37e9c0))


### Bug Fixes

* **build:** Always distribute Lua_modules even if build uses system ([e75ece7](https://github.com/sile-typesetter/sile/commit/e75ece7fb88703ab39e1ac97e6c5385a59950aed))
* **build:** Correct typo in test dependencies causing no font downloads ([ad49a85](https://github.com/sile-typesetter/sile/commit/ad49a85dafbb5cf4e12326f0ffd1da755791c715))
* **build:** Correct typo in test dependencies causing no font downloads ([09a653a](https://github.com/sile-typesetter/sile/commit/09a653a7768e5e8006614fc7d4703c82996d17b6))
* **build:** Explicitly filter packaging *.lua and *.sil to avoid cruft ([a89773d](https://github.com/sile-typesetter/sile/commit/a89773d48dbd9a54f6939c8722a18dcd2d67755e))
* **build:** Fix conflations between Lua source types ([163959f](https://github.com/sile-typesetter/sile/commit/163959f267966507f2627afdca48d01db0a3a3ae))
* **build:** Handle any combo of --with-manual and --with-examples flags ([145a86e](https://github.com/sile-typesetter/sile/commit/145a86edd99b9bae054e0e68245f90b512695ab0))
* **build:** Mark `make busted` as PHONY so it always runs ([23b81ac](https://github.com/sile-typesetter/sile/commit/23b81ac1ac79fb6f3c9c9be0fd38a50b972b7dde))
* **build:** Move dynamically generated file lists out of automake ([f626867](https://github.com/sile-typesetter/sile/commit/f626867221fa57af3a3d90ad87e0bc0c80581d71))
* **classes:** Use Hack as default monospace font ([0e61067](https://github.com/sile-typesetter/sile/commit/0e610675c173c177c444f8212668bbb5dd6a36d0))
* **core:** Handle empty content in macros using \process ([2dc6d66](https://github.com/sile-typesetter/sile/commit/2dc6d66b9002ae46de5e764cfffb88c4a4b16c9f))
* **frames:** Reset font to Gentium to output frame IDs ([102dd09](https://github.com/sile-typesetter/sile/commit/102dd09d548eb48ba752994d59c9237d63a42143)), closes [#915](https://github.com/sile-typesetter/sile/issues/915)
* **inputs:** Disallow 'begin' and 'end' as environment names ([b13b99a](https://github.com/sile-typesetter/sile/commit/b13b99a7ad3e7acddf7e66b920f2bf553ef4682a))
* **inputs:** Only allow reserved characters as 1-char commands ([2a4c095](https://github.com/sile-typesetter/sile/commit/2a4c095826fc0fb16831aac35b400b64a564acc3))
* **packages:** Assure PDF initialization first-output can be rotated ([0613ab1](https://github.com/sile-typesetter/sile/commit/0613ab16c14faf046c164d09e89e987df28c5371))
* **packages:** Cast measurements to numbers before use in PDF functions ([5f2d2e3](https://github.com/sile-typesetter/sile/commit/5f2d2e3c356c379acdbfc8da7bf36384421aad79))
* **packages:** Fix measurement-to-number issue in SVG ([168dffc](https://github.com/sile-typesetter/sile/commit/168dffc6bd6aa21ef8ac32ea6987c9dd64a98101))
* **packages:** Improve multi-paragraph pullquotes ([7d3f355](https://github.com/sile-typesetter/sile/commit/7d3f355c8e06f6411943ed32d9d51c55c0567a19)), closes [#865](https://github.com/sile-typesetter/sile/issues/865)
* **packages:** Ruby class should not affect document language ([#926](https://github.com/sile-typesetter/sile/issues/926)) ([8034aa1](https://github.com/sile-typesetter/sile/commit/8034aa1fa74ac254e8dff4ea4ca8bf57b7a9b01c))
* **packages:** Tate should not affect document language ([#932](https://github.com/sile-typesetter/sile/issues/932)) ([193fded](https://github.com/sile-typesetter/sile/commit/193fded67edb7d33f65e3ebeb7b571285da5a8cd))
* **tooling:** Allow `make dist` on systems without native lua packages ([5758085](https://github.com/sile-typesetter/sile/commit/57580853ada84c5af9c821646d01a07329f3e1fc))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.6
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.5...v0.10.6
  [wiki]: https://github.com/sile-typesetter/sile/wiki
