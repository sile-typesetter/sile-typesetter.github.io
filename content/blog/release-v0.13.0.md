+++
aliases = ["2022/06/sile-0-13-0-is-released"]
title = "SILE v0.13.0 Is Released"
date = "2022-06-09"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.13.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

In the last patch release I hinted we had bigger things coming.
This release finally surfaces major internal changes I’ve been working on since 2019.
If our releases had code names this one might be "class wars".
The SILE code base has two distinct usages for 'class'.
One usage is our *document* classes, cohesive bundles of features and styles used to render a document.
The second usage is the object-oriented programming paradigm of class *inheritance*.
In serendipitous naming ripe for conflation, the document class feature is itself written using programming classes, enabling document classes to inherit from each-other.

This release refactors the implementation of both types of classes.
Since nearly its inception, SILE has depended on the [stdlib][std] project for many of its Lua abstractions.
Unfortunately this library is not as standard as its name suggests, has not been developed or even well maintained, and has been a constant source of problems.
It even tinkers with core Lua functionality making it very difficult to keep SILE working across interpreter versions and to debug problems.
For some time we’ve been gradually replacing it with abstractions from the [Penlight][pl] library (loosely based on Python’s standard library).
While not perfect, that library of functions is much more robust and predictable.
This release finally removes the last of SILE’s usage of stdlib.
For this release cycle the core program will still *provide* the stdlib library to ease transition for downstream projects that currently assume it is present, but it is no longer *used* internally.
Beginning with the next major release cycle, v0.14.0, it will not be provided at all.
(You will of course be free to include it as a direct Lua dependency in your own projects.)

We’ve attempted to shim most of the API changes so that most old SILE documents (and in particular, custom classes) continue to work out of the box.
Most simple projects should still render without intervention, but you may see many warnings about deprecated functions.
A few more advanced projects may run into trouble and fail to render at all, especially if they messed around with classes (of either sort) very much.
As far as possible we’ve tried to add warning notices with hints about how to use the new class models correctly.
Please don’t hesitate to open issues if you are having trouble getting anything to work.

For package authors, a new hook system should make it a lot easier to write packages that do more without also having to write a dedicated class to use them.

Additionally the localization system for all language specific strings that may be rendered by SILE has been changed from the home-grown system of nested SILE commands to a more flexible i10n system based on [Fluent][fluent].
The [Lua implementation][fluent-lua] is not at 100% feature parity with Project Fluent reference implementation, but it is 100% interopperable with other implementations for features implemented and is a much more robust localization system than just substituting strings.
Besides using it to easily customize the limited set of embedded localizations (such as the Table of Contents header or chapter titles), the tooling for localizing messages and rendering them in context aware functions is exposed for package developers and document authors to use at will.

A small collection of bug fixes to the typesetter rounds out this release.
Justification of lines with ligatured characters is much improved.
Rules with a depth property no longer throw off baseline calculations.
Empty documents now generate blank PDFs.
Adding a new master frameset layout no longer destroys the current page’s frameset.

### ⚠ BREAKING CHANGES

* **settings:** All the functions under `SILE.settings.*()` should now be
	called using the instance notation `SILE.settings:*()`. Usage should be
	shimmed with a warning for now.

	Changing this in your code is relatively easy with a search and replace.
	As an example with a project in Git, you could use perl like this:

    ```bash
	funcs="pushState|popState|declare|reset|toplevelState|get|set|temporarily|wrap"
	git ls-files | xargs -n1 perl -i -pne "s#(SILE\.settings)\.($funcs)#\1:\2#g"
    ```

* **typesetter:** Making a new instance of the typesetter should now be
	done by *calling* `SILE.defaultTypesetter()` instead of copying the
	object. It has been changed from a std.object to a Penlight class. As
	such the correct initialization function is also now `_init()` instead
	of `init()`. A shim is in place to catch legacy usage, but this will be
	removed in the future.

* **deps:** All calls to the Lua default string library have been
	using a version monkey-patched by stdlib. This has created all sorts of
	issues including not being able to properly use some of Lua's default
	features and conflicts with out explicit meta methods. Also we're busy
	dropping dependency stdlib altogether.

	If you were relying on it for any of your string operations, replace
	`string.func()` with `std.string.func()`. For now `std` is being
	provided by SILE, but if you use it in your projects please add it as
	a direct dependency yourself since that will eventually be removed as
	well.

	By the way in case anything ever `git bisect`s back to here, one way to
	test if your problem is related to this change or not (especially if you
	have downstream code that might have built on the assumption SILE's Lua
	strings were monkey patched) is to load it manually yourself:

    ```bash
	sile -e 'require("std.string").monkey_patch()' your_file.sil
    ```

* **classes:** This changes the way classes are represented as Lua
	objects and the mechanism used for inheritance. While shims will be in
	place to catch most cases that use old syntax it is not possible to
	grantee 100% API compatibility. If you have classes that do anything
	remotely fancy (i.e. not just copy/paste from SILE examples) they may or
	may not work at all; and even if they do they should be updated to
	explicitly use the new API.

### Features

* **classes:** Add hook system for more versatile packages ([9287721](https://github.com/sile-typesetter/sile/commit/9287721217970a6262a25f5fe697ac211d1ebaca))
* **languages:** Add \ftl command to make adding fluent localizations easy ([b331456](https://github.com/sile-typesetter/sile/commit/b3314564afa5d4e38dc5f28277b13aa9dbe8668b))
* **languages:** Add fluent() command to output translations ([ad87995](https://github.com/sile-typesetter/sile/commit/ad87995ebbbce464b3a7075961db29e681607823))
* **languages:** Validate languages against CLDR database ([f96a331](https://github.com/sile-typesetter/sile/commit/f96a33133ecefa641e06139f90bc6b1931be5656))


### Bug Fixes

* **backends:** Add Pango shaper when selecting Cairo backend ([bbc2817](https://github.com/sile-typesetter/sile/commit/bbc2817c01e20ba04c5fe7d4c40de4c9b5155ffc))
* **backends:** Always output pdf on finish() even if no content ([3af7a94](https://github.com/sile-typesetter/sile/commit/3af7a94d39b11555cf2159f5f4a9c416259f7fa3))
* **backends:** Correct image sizing in Cairo and Podofo backends ([f2785ad](https://github.com/sile-typesetter/sile/commit/f2785ade39842caf40519239ee58e3db3e17cc9d))
* **core:** Avoid throwing deprecation errors when just inspecting SILE's internals ([b303059](https://github.com/sile-typesetter/sile/commit/b303059fe85d323d8a459e8025340464f4bdd0dd))
* **core:** Justify lines with ligatures (workaround) ([cf2cb3a](https://github.com/sile-typesetter/sile/commit/cf2cb3a34e72132705bda3e9fbe4bb97ac37e1f8))
* **core:** Patch Penlight 1.9.0 compatibility issue ([092fbd3](https://github.com/sile-typesetter/sile/commit/092fbd38c60677a92029a8504d5baa8c9e25c37b))
* **languages:** Correct bogus usage of resource loading / error catching ([fb1fd7f](https://github.com/sile-typesetter/sile/commit/fb1fd7f1cb39ee7d36b6d5253da94f906afba8f2))
* **packages:** An hrule with depth shall not affect current baseline ([c759892](https://github.com/sile-typesetter/sile/commit/c759892d09b9ffa1c3c2d25d69d0324b34884b13))
* **packages:** Don't destroy frames when defining masters, only when switching to one ([b7de7ca](https://github.com/sile-typesetter/sile/commit/b7de7caadf5b07f819f3e483f0f1712d06d9facc))
* **packages:** Fix autodoc parsing, typeset string not series of bytes ([14f6126](https://github.com/sile-typesetter/sile/commit/14f61266b6b19835d1019d94015d2e0bfa2612b1))


### Miscellaneous Chores

* **deps:** Drop std.string.monkey_patch() ([e8b2bdf](https://github.com/sile-typesetter/sile/commit/e8b2bdf96b50646698c75961fddff2da26ce57ec))


### Code Refactoring

* **classes:** Convert class inheritance from stdlib to Penlight ([f7dafe0](https://github.com/sile-typesetter/sile/commit/f7dafe0623a981e9532fbb0108876517786bd1d8))
* **settings:** Change settings object to be self referential ([dd97d05](https://github.com/sile-typesetter/sile/commit/dd97d05cf02e89213492d1308544177a482de7ea))
* **typesetter:** Change typesetter instancing to Penlight model ([a9400ad](https://github.com/sile-typesetter/sile/commit/a9400ad0e759b6b8787b4307c10984ce91e354dc))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.13.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.5...v0.13.0
  [pl]: https://lunarmodules.github.io/Penlight
  [std]: https://lua-stdlib.github.io/lua-stdlib
  [fluent]: https://projectfluent.org
  [fluent-lua]: https://github.com/alerque/fluent-lua
