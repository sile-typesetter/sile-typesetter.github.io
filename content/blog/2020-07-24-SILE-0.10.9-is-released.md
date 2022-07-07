+++
aliases = ["2020/07/sile-0-10-9-is-released"]
title = "SILE v0.10.9 Is Released"
date = "2020-07-24"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.9 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This is the first version of SILE to officially support [Lua 5.4](https://www.lua.org/versions.html#5.4)! If your OS or distro is migrating to the latest Lua, this release is for you. The changes in this Lua release are not very significant in relation to SILE, but it took a bit of time and effort for all the modules we use to be compatible. Additionally in this release how we handle bundling LuaRocks modules has changed. We no longer include the full source and prebuilt rocks in the source packages. For most platforms and installations this will not change anything at all, using `--with-system-luarocks` still skips anything to do with bundling and just requires the dependencies be available on the host system. This is used by all platforms to date that have SILE packages. For people building from source using the default configuration of `--without-system-luarocks` the bundling still happens using Luarocks to download and build all the required dependencies when you run `make`. Previously it copied the sources for your version of Lua out of the source package, but with 4 supported versions of Lua and many variation in how different platforms build them this was getting too cumbersome. LuaRocks does this job already, we just leverage it.

Still on the topic of packaging, a minor change is that `make install` will not install the PDF manual and examples by default, but if you add `--with-manual` and/or `--with-examples` it will not only install them, but it will install them to your platform’s default location for PDF documentation (previously they were just stuffed in alongside the SILE code, wherever that was). The PDF documentation directory is the same as for other documentation on most platforms, but it does go to the right place for those system that have special handling for PDF documentation.

As for the typesetter itself, if you ever used `inputfilter()` functions and your content randomly came out in the wrong order, we fixed that non-determinism. Additionally Unicode combining diacritic marks can be now be added with `\unichar{}`. If you’re trying to figure out what is what on a page, `--debug hboxes` also works again after being broken some time back.

For developers, adding multiple debug flags from the CLI is easier than ever, and fewer things need to be rebuilt from scratch every time you touch something in SILE’s source code.


### Features

* **build:** Install manual to $(pdfdir) if configure --with-manual ([ee33ff7](https://github.com/sile-typesetter/sile/commit/ee33ff71c2d978c637c01433663ccd7baf7e8fcc))
* **core:** Allow adding --debug flag multiple times ([9ac2838](https://github.com/sile-typesetter/sile/commit/9ac28382beb226785f574f89353f7acb720fb949))


### Bug Fixes

* **build:** Correct typo in dependencies for building docs ([ad548a5](https://github.com/sile-typesetter/sile/commit/ad548a5e0c32ef5bd99f951594a9e49161aa5941))
* **build:** Ship blank lua_modules install list in source packages ([7939970](https://github.com/sile-typesetter/sile/commit/7939970397414554c45dcfe486dc736b8fb2e4fe))
* **build:** Touch Makefile.in to avoid automake errors ([e7f4627](https://github.com/sile-typesetter/sile/commit/e7f4627a8cf8e6498b7c1c22b633579644a1d72a))
* **build:** Work around src/libtexpdf subdirs using side-effects ([26d6769](https://github.com/sile-typesetter/sile/commit/26d6769a32c3985d18d314cf0281663d5545e650))
* **core:** Iterate on sequential data with ipairs() or SU.sortedpairs() ([9db0a28](https://github.com/sile-typesetter/sile/commit/9db0a28d5c64caf9d64200d359f477bd375469eb))
* **debug:** Fix math in hbox debugging ([6c0029d](https://github.com/sile-typesetter/sile/commit/6c0029df469e89ce809ff833a3fa631eee14f77e))
* **packages:** Combine unichar output with existing unshaped node ([712bc92](https://github.com/sile-typesetter/sile/commit/712bc925dfc1601111922d4bd9089ad161867020))
* **packages:** Use sortedpairs to avoid non-determinism ([a28ef06](https://github.com/sile-typesetter/sile/commit/a28ef06b2aa1265018078e258280fc2f9a7dc348))
* **utilities:** Add sorted pairs function ([5aad397](https://github.com/sile-typesetter/sile/commit/5aad3975cc92b2641337bd65e2919ee198fe8669))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.9
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.8...v0.10.9
  [wiki]: https://github.com/sile-typesetter/sile/wiki
