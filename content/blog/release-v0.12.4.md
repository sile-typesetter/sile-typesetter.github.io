+++
aliases = ["2022/03/sile-0-12-4-is-released"]
title = "SILE v0.12.4 Is Released"
date = "2022-03-03"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.12.4 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This patch release fixes a bug introduced while fixing other bugs.
While enabling BiDi by default for all typesetters was working, enabling it manually on typesetters would result in an infinite loop.
Given that many people worked around it not being enabled by default by turning it on manually, this meant a lot of documents started taking lots (∞) of time to render.
Apologies for the wasted cycles, whether CPU or brain wave.

### Bug Fixes

* **docker:** Fix GHCR → Docker Hub copy used when releasing ([e5d83d0](https://github.com/sile-typesetter/sile/commit/e5d83d01a68e83ad951e31033a865a922c01859b))
* **packages:** Avoid infinite loop when re-enabling BiDi ([b4d691b](https://github.com/sile-typesetter/sile/commit/b4d691b29ff4b28f80a93f6c0731164725f84055))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.4
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.3...v0.12.4
