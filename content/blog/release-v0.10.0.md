+++
aliases = ["2020/01/sile-0-10-0-is-released"]
title = "SILE v0.10.0 Is Released"
date = "2020-01-13"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Most of the many, many improvements in this release are under the hood.
The build and test systems have been significantly overhauled, the release process has been streamlined and partially automated, continuous integration now tests code quality and commit messages, and there has been an enormous amount of code refactoring.
All of these things make for a more readable code base and a more reliable and maintainable development environment, which we hope will facilitate SILE development in the future.
Creating installers should be easier for most platforms than in previous releases, and we hope future releases will come with more pre-built packages.

There are also some user-facing improvements:

* Installation is made easier, as SILE will now download and bundle the Lua modules that it requires.
  For those who have their own Lua installation and *wish* to make use of dependent modules installed with `luarocks` or their system’s package manager, use the `--with-system-luarocks` argument to `./configure`.
* Error and warning reporting has been improved; SILE will now tell you where in the document any errors occurred and (with the `--trace` option) the stack of commands it took to get there.
* Language support:
    * Fixes to hyphenation in Danish, Greek, Finnish, and Ukrainian.
    * French punctuation conventions are followed, with (optional) non-breaking spaces before high punctuation marks.
    * Numbers can now be formatted as ordinals (at least for English and Turkish), by using the counter display type `nth`, and as words using the `string` display type.
* A new `text` backend is available to dump a text-only version of the rendering process.
  This can much more accurate that extracting text versions from a PDF later for search indexing or similar purposes.
* Improvements to tracking & letter spacing.
* Dependency system: `sile -m` will output a Makefile snippet showing all the files required to build a SILE document.
* Adding the `toc=false` option to a book section or subsection will cause it not to be added to the table of contents.
* Added a man page for quick reference of CLI options.

### Notable Bug Fixes

* *Boustrophedon*, *grid*, and *simpletable* packages now work again.
* Temporarily switching away from fonts specified by filename into a verbatim environment won’t crash any more.

### ⚠ BREAKING CHANGE

This removes the auto-guessing file extension mechanism that allowed *.sil files to be loaded without specifying the full file name with extensions.

A command like `sile test` will no longer find and build sile.sil, you must run `sile test.sil`.
The mechanism that was doing this was a hack than only worked in some scenarios anyway, and dropping it instead of trying to cover all the edge cases will make it that much easier to use and document.
Importantly it avoids edge cases where both *.xml, *.sil, and/or *.lua files all have the same name and the loader really has so idea which one you mean.

Note that _packages_ may still be loaded with no file extension, this does not affect the `require()` mechanism that looks for *.lua and various other incantations by default.

### Scheduled Deprecations

This release renames and deprecates many internal functions and classes.
Most notably the default library used for class models has changed from `std` to `penlight`.
Old methods are still available for now, but those developing external Lua packages and classes will want to check the [wiki][wiki] for instructions on how to update their code.
The next release cycle will start throwing warnings when these deprecated functions are called, and the following cycle will remove them entirely.


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.9.5...v0.10.0
  [wiki]: https://github.com/sile-typesetter/sile/wiki
