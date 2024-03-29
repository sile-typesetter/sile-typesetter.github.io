+++
aliases = ["2022/04/sile-0-12-5-is-released"]
title = "SILE v0.12.5 Is Released"
date = "2022-04-18"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.12.5 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Today we have a fairly small release motivated primarily by wanting to patch a few small issues before some bigger things in the pipeline land.
We cleaned up a few small scripting issues with the configure and install process that should make it easier to install from sources on BSD platforms or Linux distros such as Alpine that do not default to bash and GNU tooling.

Besides the minor tooling fixes, Didier Willis has continued to pour in contributions.
This release features his feature overhaul to the leaders package so that dot fills align vertically.
It also includes his fixes to whitespace handling around punctuation in French and better extraction of strings such as chapter titles to PDF bookmarks.


### Features

* **packages:** Align leaders vertically ([#875](https://github.com/sile-typesetter/sile/issues/875)) ([8b5d418](https://github.com/sile-typesetter/sile/commit/8b5d4189222f4221592dbb93cb7a65c4838262a6))


### Bug Fixes

* **build:** Catch and complete unfinished library builds ([91ff438](https://github.com/sile-typesetter/sile/commit/91ff43859cfa645f6ea43d2485e5df69e793b306))
* **build:** Use BSD compatible scripting in `make selfcheck` ([319e0c5](https://github.com/sile-typesetter/sile/commit/319e0c5752415cd3c7fea4541e9a5ab8cfcb1358))
* **build:** Use POSIX compatible shell syntax in configure ([55e64ab](https://github.com/sile-typesetter/sile/commit/55e64ab984fa3ec02de36b0ebe478462f490993d))
* **deps:** Correct include to work with current LuaRocks packages ([#1357](https://github.com/sile-typesetter/sile/issues/1357)) ([b584be5](https://github.com/sile-typesetter/sile/commit/b584be5253b1d97d6fc742e7b0b19a3ffd71c384))
* **languages:** French punctuation spacing must honor current font options ([724daf4](https://github.com/sile-typesetter/sile/commit/724daf43b5a2d5a8e501c14f858592fa4763454f))
* **packages:** Better TOC title extraction for PDF bookmark ([#1029](https://github.com/sile-typesetter/sile/issues/1029)) ([5a65701](https://github.com/sile-typesetter/sile/commit/5a657012a4d8fae78a4fa07b3059d319b2b396fa))
* **packages:** The dotfill must stretch as an hfill ([#1343](https://github.com/sile-typesetter/sile/issues/1343)) ([c94a4b5](https://github.com/sile-typesetter/sile/commit/c94a4b5adfe44f89c36d59370e69b67fe2630e21))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.5
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.4...v0.12.5
