+++
title = "SILE v0.15.7 Is Released"
date = "2024-11-26"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.7 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Please welcome CSL support.
This is still a bit experimental, but this begins the deprecation of the home grown bibliography styling in our *bibtex* package.
SILE can now leverage industry standard Citation Style Language specifications, which opens up a world of existing locale and style guide support.
This is thanks to long-running work from from [Didier Willis](http://github.com/Omikhleia) on overhauling [bibliography][] support.
His work on the *math* package also continues with many operator and layout fixes and a few new features continuing to round out out MathML compatibility.

For folks calling out to Lua functions or system tools in their classes, packages, or documents, those calls will now track the document locale.
If you use an OS function or external tool that supports localization, you should now get results that match the locale in the document at the time it was called.
Responsiveness to locale modifiers might be a little rough until we normalize our locale format to be BCP-47 compliant, but it already works for basic locales.
Incidentally this also provides a utility API that can be used to set any ENV variable you want before running external tooling.

Of interest only to SILE developers, some new configure flags have been added for convenience.
Any individual tool used in the development and release process can be skipped or overridden using standard `--with[out]-PACKAGE=PATH` flags.
Additionally skipping *all* the tooling checks can be done with `--without-developer-tools` even when `--with-developer-mode` is used.

Finally for distribution packagers, cross compilation of the Rust binaries should be a bit easier now.

### New Features

* **build:** Add configure flag to skip checks for all developer tools ([c01c867](https://github.com/sile-typesetter/sile/commit/c01c867174a708e75a4bdb929eb8cac25b7a1048))
* **build:** Enable --with[out]-EXECUTABLE=PATH configure flags for tooling dependencies ([89b5836](https://github.com/sile-typesetter/sile/commit/89b583651f1741be4f7dca118c858b6e41c070b0))
* **core:** Set Lua's internal locale so builtin functions respond to document language ([a614169](https://github.com/sile-typesetter/sile/commit/a614169522d23e50855b56116fe95227fa7ab43d))
* **core:** Set system locale for subprocesses to match the document language ([b28cafd](https://github.com/sile-typesetter/sile/commit/b28cafd9bcfcffdcc1ea8546e83d4c0d18423150))
* **math:** Add pre-defined TeX-like operator functions (cos, sin, etc.) ([8d83821](https://github.com/sile-typesetter/sile/commit/8d83821adda90020ed6c7861b36010829a934e30))
* **math:** Support TeX-like apostrophe and multiplication sign as primes and asterisk ([b8f35ff](https://github.com/sile-typesetter/sile/commit/b8f35ff81257125f408009a053a929d35f28b88d))
* **math:** Support TeX-like left..right delimiter syntax ([960dc3f](https://github.com/sile-typesetter/sile/commit/960dc3f49dba5a78c44cde391923cbde8e2ed986))
* **math:** Support the MathML operator dictionary and many TeX-like aliases ([3dd25e9](https://github.com/sile-typesetter/sile/commit/3dd25e95331e19c7b6e1a5af67106098ffaf3aad))
* **packages:** Add lightweight CSL engine ([8d3961c](https://github.com/sile-typesetter/sile/commit/8d3961c9f4f78614278d4f761f690801e9b9a63b))
* **packages:** Keep track of cited bibliography entries ([57b3b7c](https://github.com/sile-typesetter/sile/commit/57b3b7ce607db422b6030d115653a4ffdd1e1c5f))
* **packages:** Use experimental CSL renderer for BibTeX ([808c6bb](https://github.com/sile-typesetter/sile/commit/808c6bbd8165b8b5d4fff11489fb2a5341d6b3dd))
* **utilities:** Add function to set environment variables ([0f0ed02](https://github.com/sile-typesetter/sile/commit/0f0ed023893212b7d6d9a2a26afb3cb17e369ead))

### Bug Fixes

* **build:** Support cross-compilation of Rust binaries ([#2178](https://github.com/sile-typesetter/sile/issues/2178)) ([19c7c1d](https://github.com/sile-typesetter/sile/commit/19c7c1d4cf07ac7baa7c4c6b24d0d82f2dcea0af))
* **math:** A period must be allowed in TeX-like math syntax for numbers ([56edc14](https://github.com/sile-typesetter/sile/commit/56edc14c9b69806ef288ce870abad1d0f6add34f))
* **math:** Add math.font.script.feature setting, defaulting to ssty ([2adc912](https://github.com/sile-typesetter/sile/commit/2adc912bf8ebfda5d30a7404f41d5390d986bf17))
* **math:** Improve spacing rules on limit-like operators ([781f62a](https://github.com/sile-typesetter/sile/commit/781f62ad0527a6275b4ce8645c3231bae98a1121))
* **math:** Spacing rules must distinguish binary and unary operators ([81a1be5](https://github.com/sile-typesetter/sile/commit/81a1be52604efbb162c18bf45bcc1473e42c1f9a))
* **math:** Suppress invisible operators in MathML ([#2177](https://github.com/sile-typesetter/sile/issues/2177)) ([72faad5](https://github.com/sile-typesetter/sile/commit/72faad564eb28ec21460d4e68730d2224fe954ab))
* **math:** The (escaped) percent is an ordinary atom in TeX-like syntax ([4170719](https://github.com/sile-typesetter/sile/commit/41707190c58035741de60a8b3b638ec1d5d3826c))
* **packages:** Fix bogus command in Pandoc module's definition lists leaking bold ([8c9348b](https://github.com/sile-typesetter/sile/commit/8c9348bcd0cdf471568a71c190b1b6585f22eddb))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.7
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.6...v0.15.7
  [bibliography]: https://github.com/orgs/sile-typesetter/projects/12

