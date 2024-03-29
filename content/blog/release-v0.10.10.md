+++
aliases = ["2020/08/sile-0-10-10-is-released"]
title = "SILE v0.10.10 Is Released"
date = "2020-08-14"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.10 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release is the first to fully support LuaJIT.
For systems with a LuaJIT interpreter available this brings a full 2× speed improvement to rendering your documents over standard Lua interpreters.
This speed increase is not without downsides though.
Most available JIT versions do not have full Lua debugging functionality built in, limiting the usefulness of some of SILE’s warning messages and especially the trace functionality.
A LuaJIT build is probably what you want to use when working on content and re-rendering your documents over and over, but it may not be the best choice for doing development work, coding up your classes and functions, and so forth.
To make the switch, add the configuration flag `./configure --with-luajit`, then compile and install as usual.
In the event you want to keep both versions around, it is actually possible to install both.
SILE fully supports GNU Automake’s program name transformations, you can specify a prefix, suffix, or complete alternate name to install under.
See `./configure --help` for details, but `--program-suffix=-luajit` is one way to get a `sile-luajit` executable that could be used alongside `sile`.

A few functions have been renamed and their old versions deprecated.
If any of your code calls outputter functions directly these calls will need to be modified to be uniformly serf-referential method calls (i.e. `:method()` instead of `.method()`).
This makes the outputter API consistent between backends, but may be a breaking change for some.
Several other functions have been renamed and their old names deprecated.
For these warning messages will be thrown for now, and the next version series (0.11.x) will deprecate them entirely.
The most notable rename is `\include-svg-file` is now just `\svg`.
In addition to the rename you can now specify a desired size by width instead of only by height.

In smaller news a large number of small fixes now draw frame debugging lines in *exactly* the right place instead of *next to* the right place, mark PDF bookmark locations at the top of the current line instead of the bottom, draw rules in the correct writing and advance directions for RTL and BTT frames.
Other fixes include keeping Japanese language and tate functions from taking over documents.
The `\center` command now disables line indentation so content is centered as expected, and attempting to set indentation after the start of a paragraph will throw a useful warning.


### Features

* **build:** Detect and use luajit first ([601dfc4](https://github.com/sile-typesetter/sile/commit/601dfc42bcde4f8f8963c162e162db2a37dc8110))
* **build:** Detect LuaJIT if explicitly configured to want it ([c3e8089](https://github.com/sile-typesetter/sile/commit/c3e80897ddb2c51bc4a7b15bc0332a4bb304fec8))
* **classes:** Add warning to \noindent if called after input ([f29b9d9](https://github.com/sile-typesetter/sile/commit/f29b9d9daa56519717b09461ffb72fa53de2f75c))
* **packages:** Allow scaling SVGs by width or height ([44588b5](https://github.com/sile-typesetter/sile/commit/44588b56be70b35f73664223e4cf87e2a524e4c1))
* **settings:** Add a way to reset single setting to defaults ([f318cdf](https://github.com/sile-typesetter/sile/commit/f318cdfb2b24d896d582f75025093f5db0479f33))
* **settings:** Bring Lua settings.set to parity with \set ([d73b08c](https://github.com/sile-typesetter/sile/commit/d73b08c0419d14fde78df19761738dccefbd7efa))


### Bug Fixes

* **classes:** Reset parindent's inside \center command ([7b62f74](https://github.com/sile-typesetter/sile/commit/7b62f7426f57dd870631972529a9669680adfebe))
* **core:** Always compare like-types so LuaJIT can run ([c608090](https://github.com/sile-typesetter/sile/commit/c6080900b71de5e44ebb910d4b8aa1a6b4a7fe02))
* **core:** Don't read zero-length name table entries ([bcd9a9e](https://github.com/sile-typesetter/sile/commit/bcd9a9eb3d3d8b84d1ffa95c77224cf87079cdaa)), closes [#1015](https://github.com/sile-typesetter/sile/issues/1015)
* **examples:** Properly center title in showoff document ([55717fb](https://github.com/sile-typesetter/sile/commit/55717fb6eb682d2349c403c7f32e54ef042bb681))
* **frames:** Discard content (usually whitespace) inside \pagetemplate ([3b7085b](https://github.com/sile-typesetter/sile/commit/3b7085b150771ded2fa217b23f89935e6231d090))
* **frames:** Draw frame debug lines exactly on frame lines ([db92edc](https://github.com/sile-typesetter/sile/commit/db92edcd1056da29cede15202daea844444cb031))
* **languages:** Stop Japanese resetting global chapter post macro ([836f199](https://github.com/sile-typesetter/sile/commit/836f199737f8fc99b9377ab354bef36d9d542fd7))
* **packages:** Align pullquote ending mark with outside margin ([8b808db](https://github.com/sile-typesetter/sile/commit/8b808db61e712f62817e0a25590db4bb320f6e8b))
* **packages:** Draw rules in the writing direction ([18bca68](https://github.com/sile-typesetter/sile/commit/18bca68cfe9d5d061d5a86e485a28fbb712f8e28))
* **packages:** Error if asked to add bogus dependencies ([59e2b56](https://github.com/sile-typesetter/sile/commit/59e2b568535136f40bfa60e9dc36cfb7a9855d4b))
* **packages:** Fix indentation of second paragraph in pullquotes ([a8525e5](https://github.com/sile-typesetter/sile/commit/a8525e575bd56cce7a6a635cc3e0f827593f5e11))
* **packages:** List \include files in makedeps ([bf670ab](https://github.com/sile-typesetter/sile/commit/bf670ab5d323886cd62c7193ee0598472e0e40c1))
* **packages:** Orient rules for all 8 directions ([bc4a33a](https://github.com/sile-typesetter/sile/commit/bc4a33a73cd7f4550e6dc547a31505f6865e38fe))
* **packages:** Place PDF bookmarks at top of current line ([ce30d83](https://github.com/sile-typesetter/sile/commit/ce30d83347e8d3bae6c044112ec265695a0bb1c6))
* **utilities:** Use deterministic sort for sorted pairs ([99e2b59](https://github.com/sile-typesetter/sile/commit/99e2b593e06e4ee5a1162e8ce3da2bec8512e3b3))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.10
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.9...v0.10.10
  [wiki]: https://github.com/sile-typesetter/sile/wiki
