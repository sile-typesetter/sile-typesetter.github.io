---
title: SILE v0.12.0 Is Released
post_author: Caleb Maclennan
post_gravatar: 11cdaff4c6f9b290db40f69d3b20caf1
---
Version v0.12.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Please welcome *MATH* typesetting!

While this release follows close on the heals of previous releases it represents over 2 years of work from community contributors.
Rui Xia started work on a native math feature in April 2019.
While the initial contribution was not completed, it did get as far as a working prototype.
In November 2020 Oliver Nicole picked up on the work and transformed the prototype into this initial release.
Also thanks to Mateusz Czapliński for input on throughout the process.

The math support is based on [MathML][] and OpenType math fonts.
Input notation may be MathML (using either XML syntax directly or the equivalent SIL syntax) or an alternative math shorthand syntax similar to the math syntax of TeX.
See section 5.29.5 in the [v0.12.0 manual][manual] for the new math package documentation.
Examples are given for various formulas and syntax options.

Additionally Didier Willis contributed several new features including much more control over Table of Contents and styling options for PDF links.

<!-- Insert sile-0.12.0.md -->

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.11.1...v0.12.0
  [MathML]: https://www.w3.org/Math/
  [manual]: https://sile-typesetter.org/manual/sile-0.12.0.pdf
