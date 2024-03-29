+++
aliases = ["2022/03/sile-0-12-3-is-released"]
title = "SILE v0.12.3 Is Released"
date = "2022-03-02"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.12.3 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This patch release changes the way new frames are generated to inherit settings differently.
These changes should qualify as "fixes", but could affect workarounds for anybody that had trouble before.
Loading the BiDi package (which happens by default) now changes the default typesetter in addition to the current one.
This affects some features such as the commands to typeset into a different frame than the current one when RTL languages are involved.
Additionally, the way frames are created has changed so that direction settings such RTL set on the class are inherited by default to default and new frames unless otherwise specified.
This affects folio, footnote, and other default frames as well as any created programmatically.

Both changes are likely the behavior most users would *expect* anyway –hence the minor patch release– but could cause unexpected results in documents that had other ways of dealing with the previous unexpected behavior.

### Bug Fixes

* **frames:** Inherit class direction setting in new frames ([35c8a25](https://github.com/sile-typesetter/sile/commit/35c8a255c2a19d4f25dc5f60e40d76a52d2ac601))
* **packages:** Make boxaround respect shrink/stretch (rules package) ([9d8f708](https://github.com/sile-typesetter/sile/commit/9d8f7086e1f469a24b032307b43dc801fe10fd92))
* **packages:** Make underline respect shrink/stretch (rules package) ([a5d99f0](https://github.com/sile-typesetter/sile/commit/a5d99f0619bb58309313ece1ba320a5e465681a2))
* **typesetter:** Enable bidi for default typesetter on package load ([6a8d7f4](https://github.com/sile-typesetter/sile/commit/6a8d7f400faca53d825f1fea000d51f5e967addb))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.3
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.12.2...v0.12.3
