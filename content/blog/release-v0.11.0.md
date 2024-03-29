+++
aliases = ["2021/09/sile-0-11-0-is-released"]
title = "SILE v0.11.0 Is Released"
date = "2021-09-02"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.11.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release brings a significant fix to the vertical grid typesetting system that was causing extra full grid spaces between paragraphs where they didn’t belong. The new behavior is objectively more correct, but it does break previous workarounds. If you previous used a workaround to get the right output in spite of the bug, those documents may not render incorrectly. They can be fixed by removing whatever other workaround was in place or adding a shim that makes the paragraph spacing emulate the old behavior. Some utility functions also received bug fixes. Thanks to contributor Fredrick Brennan, color fonts now behave themselves much better in TTB layouts and the counter display style *Alpha* works as documented.

Not much has been added on the feature front, just a few conveniences such as traditional units of (small) measurement and handling more attributes in documents converted [via the Pandoc writer][pandoc] (as-yet unreleased).

Beginning with [this release][v11docker] Docker images will now be available from [GitHub Packages][ghp] (also known as the GitHub Container Registry). This is an alternative to Docker Hub which has recently started limiting the features available to open source projects.


### ⚠ BREAKING CHANGES

* **packages:** Previous to this release any and all leading between
paragraphs (as set with document.parskip) –even a 0 height skip– would
result in the skip of one full empty grid space — as if parskip had been
set to something approximating a full line height.  This change corrects
the calculation so if a 0 height skip is added and everything fits, the
next line or paragraph will continue uninterrupted in the next grid
slot.  To get the previous layout behavior back, document.parskip must
be explicitly set to be something larger than 0.  Even a minimal 1pt
skip will result in paragraph spacing that includes one full grid height
left blank as before:

        \set[parameter=document.parskip,value=1lh]

* **utilities:** Previous return value for breadcrumbs:contains() was
just an depth index with -1 indicating no match. This made sense when
I wrote it, but coming back to it for a new project I expected a boolean
return value. Returning two values seems like the best option, but given
the function naming it seemed to make sense to return the boolean first,
hence the API breakage.

### Features

* **actions:** Use tagged images for faster CI job spin up ([6a00388](https://github.com/sile-typesetter/sile/commit/6a003888153d76a1951d396296109afd074e44be))
* **build:** Add configure flag --disable-dependency-checks ([5caf413](https://github.com/sile-typesetter/sile/commit/5caf41335e51c8656962b6800b9a9be0a94a897e))
* **docker:** Build, tag, and push images to GHCR ([3988339](https://github.com/sile-typesetter/sile/commit/398833939b240a595bb97e75aef04249a8e6dbe8))
* **measurements:** Add ‘hm’ (himetric) unit ([f4b6b62](https://github.com/sile-typesetter/sile/commit/f4b6b626bef5851da1ec010b742d5cd8949996eb))
* **measurements:** Add ‘twip’ unit ([cf9d5a7](https://github.com/sile-typesetter/sile/commit/cf9d5a79660f9ffb625e6ea4753f06d7f62bbd38))
* **packages:** Map unnumbered class to legacy opts in Pandoc package ([#1167](https://github.com/sile-typesetter/sile/issues/1167)) ([2868da2](https://github.com/sile-typesetter/sile/commit/2868da2d93475331a9cdef49abd68b538d3e0783))


### Bug Fixes

* **core:** Avoid crash on warn by using correct function ([b403ad9](https://github.com/sile-typesetter/sile/commit/b403ad93cbe820b78635de176c150ffe6153eff1))
* **packages:** Avoid crash on warn by using correct function ([5d05be1](https://github.com/sile-typesetter/sile/commit/5d05be1520b9818db706259afccd25dd5dec5002))
* **packages:** Avoid unnecessary skips to next grid space ([6424369](https://github.com/sile-typesetter/sile/commit/6424369ae8da4df34737ca413767008450bf5d2c))
* **packages:** Correctly handle color fonts on TTB pages ([9b35d6a](https://github.com/sile-typesetter/sile/commit/9b35d6ace8284d29439ed56617efb5e07e61145b)), closes [#1171](https://github.com/sile-typesetter/sile/issues/1171)


### Code Refactoring

* **utilities:** Change breadcrumbs:contains() to return <bool, index> ([a987394](https://github.com/sile-typesetter/sile/commit/a9873946883f215bfb97dddbc6b8fe06233c4b6f))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.11.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.15...v0.11.0
  [pandoc]: https://github.com/jgm/pandoc/pull/6088
  [v11docker]: https://github.com/orgs/sile-typesetter/packages/container/sile/7194160?tag=v0.11.0
  [ghp]: https://github.com/orgs/sile-typesetter/packages/container/package/sile
