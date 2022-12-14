+++
title = "SILE v0.14.6 Is Released"
date = "2022-12-14"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.6 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release has tons of fixes and even a few features, but perhaps the most interesting bit to end users might just be the documentation.
Thanks to [Jonny Heggheim](https://github.com/hegjon), official SILE packages are in the works for Fedora.
The procedure for installing them via COPR is documented and will be updated when they land in default repositories.
Also [Fredrick Brennan](https://github.com/ctrlcctrlv) added some useful notes about installing 3rd-party packages.
This is really important because very useful actions like typesetting Markdown are best accomplished with external packages.

Anyone working with the source code for SILE itself should note the build system has been split so only run time dependencies are checked at configure time by default.
This means no-change is needed for distro packagers and end users that are just wishing to install and move on.
However checking for dependencies needed in order to develop SILE itself (including running tests) now requires different configuration.
Using `--enable-developer` should be added as a go-to configure option for anyone hacking or wishing to contribute the to SILE sources.
Also of interest to developers, using `nix develop` should now be a lot more seamless as far as providing a ready-to-use environment.

[Didier Willis](https://github.com/Omikhleia) has rebuilt the `formatNumber()` utility function using ICU.
This increases language support from a handful of manually implemented ones to almost complete CLDR coverage.
In the process a new utility function `collatedSort()` was added to sort Lua data with locale aware collation.
He also fixed a number of little typsetter bugs and overhauled some more documentation.

First-time contributer [raphCode](https://github.com/raphCode) submitted a fix for calling citation keys in the bibtex package.

Debug output is now both faster and more robust since it can't crass the typesetter.
When errors are encountered, location reports for where in the document an error was triggered are more accurate.
Bundled in this release are also a batch of other small bug fixes to the typesetter, page builder, and shaper.

### Features

* **build:** Add ./configure --enable-developer to ease setup for SILE developers ([e8a56ae](https://github.com/sile-typesetter/sile/commit/e8a56aef39eff4601490a8ccfc6bffba107b18ca))
* **core:** Add SU.collatedSort for language-dependent table sorting with collation ([ea7446d](https://github.com/sile-typesetter/sile/commit/ea7446d29117884b89eaaba96f19a7687161857e))
* **core:** SU.formatNumber has more options and language support ([ed0db29](https://github.com/sile-typesetter/sile/commit/ed0db293fd17bffec95db931150ac3bb2df3903c))
* **packages:** Add package loaded that can later be used to track package dependencies ([d48633a](https://github.com/sile-typesetter/sile/commit/d48633af4b2f7957af420676e5fac0fe126558da))
* **packages:** Code block environment and raw handler for autodoc ([7661330](https://github.com/sile-typesetter/sile/commit/7661330372654978a41139c7da1974efb7aa6107))


### Bug Fixes

* **classes:** Apply page/framebreak in hmode but warn the user ([809cbba](https://github.com/sile-typesetter/sile/commit/809cbba95c7b4a4577981efb749ecff844a01d8d))
* **cli:** Deduplicate Lua module loading paths when adding segments ([e0f75b1](https://github.com/sile-typesetter/sile/commit/e0f75b11be7ef40fcaed06002407d061a411b257))
* **cli:** Escape possible path character in replacement ([0161f9a](https://github.com/sile-typesetter/sile/commit/0161f9afea6329a14fd511038c6d42c6c948fcb9))
* **cli:** Make user system root not added to resource search path ([4305850](https://github.com/sile-typesetter/sile/commit/43058502c206babc330cf5efe1f22540d3529b69))
* **debug:** Correct filename in debug info after includes ([#1652](https://github.com/sile-typesetter/sile/issues/1652)) ([4990ecc](https://github.com/sile-typesetter/sile/commit/4990ecc42eae8b6fb981cfa7facc0c3c9300da68))
* **debug:** Fix pagebuilder debug functions in absence of luastd ([ab46bf7](https://github.com/sile-typesetter/sile/commit/ab46bf7c435cdfe8eada1d80363df04a3e148f45))
* **debug:** Fix typesetter:debugState() in absence of luastd ([42f6b0b](https://github.com/sile-typesetter/sile/commit/42f6b0b7cf5d1b3d94020d0bcf851b4dd0265b39))
* **inputters:** Correct Lua inputter AST expectations to match others ([6177b0b](https://github.com/sile-typesetter/sile/commit/6177b0b10fafdaca2dd605f17049b70ac09ee39d))
* **inputters:** Work around SIL parser returning tags as part of content ([ef4efb7](https://github.com/sile-typesetter/sile/commit/ef4efb7a4ec007cfb4e72de1b47633a42a228f4e))
* **languages:** Replace custom EN/TR ordinals with ICU ([82b6709](https://github.com/sile-typesetter/sile/commit/82b67094f329ca2e57d88d992e200a9502fd2b91))
* **nodes:** Ignore empty node properties when debugging breaks ([f034e05](https://github.com/sile-typesetter/sile/commit/f034e05c2a37206c78e29f31fd9a6dab000d9e9a))
* **packages:** Correct content position reporting in inputfilter ([bb53d77](https://github.com/sile-typesetter/sile/commit/bb53d77709fc94b798c70d2d0bf268d02ce4536d))
* **packages:** Don't discard grid makup vboxes at top of new pages ([22b899c](https://github.com/sile-typesetter/sile/commit/22b899c389dbd94a446f4600a8cb8c225d8afa5f))
* **packages:** Fix \cite{key} in bibtex package ([#1655](https://github.com/sile-typesetter/sile/issues/1655)) ([648bb5d](https://github.com/sile-typesetter/sile/commit/648bb5d2702f5b19e0d71903808ffe0ecceae020))
* **packages:** Use casting to restore shaper state after fallbacks ([351fc68](https://github.com/sile-typesetter/sile/commit/351fc681a19cd30d397e7b10cdcfeb9fe5edb243))
* **shapers:** Apply tracking settings even in font-fallback shaper ([55f0c9c](https://github.com/sile-typesetter/sile/commit/55f0c9cd94b2ed624146b7b9da64c351ad0f7a98))
* **tooling:** Exempt LuaJIT from external bit32 library requirement ([#1654](https://github.com/sile-typesetter/sile/issues/1654)) ([d094f1b](https://github.com/sile-typesetter/sile/commit/d094f1b3529d25481205eb90326a9d53da44e820))
* **typesetter:** Ensure being in horizontal mode after pushback ([a82b604](https://github.com/sile-typesetter/sile/commit/a82b60448f639dafeb03bd8faf99584c32e56aad))
* **utilities:** Correct logic in AST debugging output, also protect ([97c82f0](https://github.com/sile-typesetter/sile/commit/97c82f0c22c4f5bc77aa5d381ab7afd2e8dd2952))
* **utilities:** Protect debug functions so they can't crash SILE ([319b96a](https://github.com/sile-typesetter/sile/commit/319b96a43c976fb1a50dad03baada2052fade67c))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.6
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.5...v0.14.6
