+++
title = "SILE v0.14.3 Is Released"
date = "2022-09-01"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.3 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release addresses a few pain points discovered using the v0.14 series in production.

For 3rd party package developers, it's now easier to *find* non-Lua resources you installed along with your package.
Among several contributions from [Didier Willis](http://github.com/Omikhleia), the output backend now returns useful information about images it embeds directly.
The same work also allows specific pages of PDFs to to be emdeded as images, not just the first page.
He also helped refactor existing interfaces to make them easier to extend, such as the table of contents package.
A long standing issue with Turkish hyphenation has been addressed, eliminating the need for preprocessing or other workarounds.
More long standing issues with the book class and chapter opening spreads have been addressed.
Some priority and interactions between new CLI flags has been worked out.
A few more misc bugs were also squished and relevant tests added.


### Features

* **languages:** Handle hyphenation of inter-word apostrophes in Turkish ([50ae936](https://github.com/sile-typesetter/sile/commit/50ae9368b29bfcb9f7d2274235c0398500d7665e))
* **packages:** Add \open-spread function with more features than \open-double-page ([c2ba579](https://github.com/sile-typesetter/sile/commit/c2ba579a56a79fea82e8ec83b95321af438793e4))
* **packages:** Add ability to select a page in PDF images ([a477d94](https://github.com/sile-typesetter/sile/commit/a477d94f9831bdd31d4925bd44660f1f24d4e290))
* **packages:** Allow for customized content on otherwise blank filler pages ([5ae97bf](https://github.com/sile-typesetter/sile/commit/5ae97bffba3192df8e1c8bf7c74c459ac137af56))
* **packages:** Provide base directory to packages ([#1529](https://github.com/sile-typesetter/sile/issues/1529)) ([f9ae994](https://github.com/sile-typesetter/sile/commit/f9ae99499ea8fada36abd849c95e2afd7f1e4030))
* **utilities:** Return image resolution with libtexpdf backend ([a9c11d3](https://github.com/sile-typesetter/sile/commit/a9c11d319cf83d38b72d09430a65cfb62e013494))


### Bug Fixes

* **cli:** Actually apply cli provided class options ([505919e](https://github.com/sile-typesetter/sile/commit/505919e4c07638e7bf6da9ebc4af12e2355a2460))
* **cli:** Allow CLI option to override document specified class ([5232ce8](https://github.com/sile-typesetter/sile/commit/5232ce8dd42fae9005c36c4e04ad988d4afedb77))
* **nodes:** Correct calculating width of postbreak discretionaries ([ea7912c](https://github.com/sile-typesetter/sile/commit/ea7912cf0c1951f68b04b7d2dfef2057115ef77d))
* **nodes:** Work around discressionaries being output when not wanted ([c7dc439](https://github.com/sile-typesetter/sile/commit/c7dc439456ad741fe644a88e6476596b8ec2a72f))
* **packages:** Fix over-aggressive eject in \open-double-page ([5620556](https://github.com/sile-typesetter/sile/commit/562055681c1ccf3b47857864d9363fb985ed7fac))
* **packages:** Homogenize image width and height as measurements ([b91cfbb](https://github.com/sile-typesetter/sile/commit/b91cfbb9e80e4330be5b9dc307d721513bbd462a)), closes [#1506](https://github.com/sile-typesetter/sile/issues/1506)
* **packages:** Make sure PDF initialized before PDF package does anything ([#1550](https://github.com/sile-typesetter/sile/issues/1550)) ([ebc3748](https://github.com/sile-typesetter/sile/commit/ebc3748e00df700002622a7f3b8ad1e2cd5bfb65))
* **packages:** Resolve src= relative to document for SVG images ([b55fc98](https://github.com/sile-typesetter/sile/commit/b55fc98e728ee69fc983be58e7331864617547b8)), closes [#1532](https://github.com/sile-typesetter/sile/issues/1532)


### Reverts

* Revert "chore(cli): Output header before doing anything that might throw warnings" ([58da8ad](https://github.com/sile-typesetter/sile/commit/58da8ad5b824fa9ccc97d0ddfbea44e3a5c39c8e))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.3
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.2...v0.14.3
