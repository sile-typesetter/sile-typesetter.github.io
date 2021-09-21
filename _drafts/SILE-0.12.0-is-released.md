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
Rui Xia started work on a native math feature in April of 2019.
While this initial phase was never completed, it did get as far as a working prototype.
In November of 2020, Oliver Nicole picked up on the work and transformed the prototype into the shape as found in this release.
Additional thank to Mateusz Czapliński for input throughout the process.

On a conceptual level the math support is based on [MathML][] and relies on OpenType math fonts.
The input notation may be MathML (either directly using the native XML syntax or using an 1-to-1 equivalent SIL syntax) or an alternative math shorthand syntax similar to the math syntax used by TeX.
See section 5.29.5 in the [v0.12.0 manual][manual] for detailed documentation on the new math package.
Examples are given for various formulas and syntax options.
A math example has also been added to the [packages example gallery](/examples/packages.html) on this website.

Additionally Didier Willis contributed several new features and fixes including much more control over Table of Contents, styling options for PDF links, correct French punctuation treatment, and more.

Thanks to the contributions of Doron Behar, as of this release SILE is usable as a [Nix Flake][flake] (in addition to the usual Nix package).
This is an easy way to test run the latest Git HEAD version at any time from almost any OS.
One you have flake support enabled, just run `nix run github:sile-typesetter/sile -- <sile orguments>`.
This website use this to regenerate some of the examples in the gallery.

<!-- Insert sile-0.12.0.md -->

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.12.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.11.1...v0.12.0
  [flake]: https://nixos.wiki/wiki/Flakes
  [MathML]: https://www.w3.org/Math/
  [manual]: https://sile-typesetter.org/manual/sile-0.12.0.pdf
