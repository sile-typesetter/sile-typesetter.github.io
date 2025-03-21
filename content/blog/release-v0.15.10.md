
+++
title = "SILE v0.15.10 Is Released"
date = "2025-03-21"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.10 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release brings yet another layer of improvements contributed by [Didier Willis](http://github.com/Omikhleia), especially to the bibliography and indexing features.
The bibliography system now uses CSL (Citation Style Language) by default, with enhanced support for grouped citations via `\cites`, better name formatting, and improved style compliance.
The indexer received significant upgrades including page range collapsing, customizable styling hooks, flexible placement in documents, and language-aware sorting.
Font handling saw improvements with new ex-height and cap-height adjustments, particularly benefiting code and verbatim text display.

The CLI also gained a new argument to streamline the process of loading 3rd party modules.
SILE has always found packages in specific system or relative locations easily, but setting the path to custom LuaRocks trees was not trivial.
A new `--luarocks-tree` argument should make it much simpler to match however you install with .

Other notable changes include avoiding hyphenation prior to page breaks, and fixes for various language-specific issues including Uyghur hyphenation and UTF-16 handling.
Warning messages involving unsupported languages should also make more sense and not spam the terminal over and over.

### New Features

* **build:** Add tooling to generate tarball of vendored crates ([55be5cd](https://github.com/sile-typesetter/sile/commit/55be5cdd864b9166a54e169f02766bfaa46816c1))
* **cli:** Add argument to ease soarch for 3rd party module(s) ([4f0d5a4](https://github.com/sile-typesetter/sile/commit/4f0d5a4fcf396525345272e841788bf695a7cd6f))
* **core:** Support ex-height and cap-height font adjustment ([4e16acf](https://github.com/sile-typesetter/sile/commit/4e16acfda605eaed19409deb7525cc5a5155edd4))
* **packages:** Add `\cites` to output grouped bibliographic citations ([bdba2ea](https://github.com/sile-typesetter/sile/commit/bdba2ea28c0eb6ec991135dd9fb20c122e0b7e2f))
* **packages:** Add `\nocite` for marking a bibliography entry as cited ([f828e9b](https://github.com/sile-typesetter/sile/commit/f828e9b7f72d0eeacf664147a83654b07ae778d2))
* **packages:** Add indexer options minimal/minimal-two for page range collapsing ([e272e43](https://github.com/sile-typesetter/sile/commit/e272e43aa74a138ff22b2d4cf1e712fa07c2921e))
* **packages:** Add new styling hooks to the indexer ([facf84c](https://github.com/sile-typesetter/sile/commit/facf84c0b06fb0452f69ae534e0ee68a3ef9c138))
* **packages:** Add option for filler between item and page in indexer ([691bfe2](https://github.com/sile-typesetter/sile/commit/691bfe2244d3adf920d0a3a3dce2520860497b61))
* **packages:** Allow indexes to be used anywhere in a document ([808aaf4](https://github.com/sile-typesetter/sile/commit/808aaf40731531c9c04c014208bdf9277c4acb5f))
* **packages:** Honor bibliography style indentation rules ([c08fcaa](https://github.com/sile-typesetter/sile/commit/c08fcaaab8cbea9abc0d481b48eab36f234df882))
* **packages:** Partial support for name-parts formatting ([18c436e](https://github.com/sile-typesetter/sile/commit/18c436e44b5d722bfb887fa0ef1f57c5957e1cc1))
* **packages:** Support links to pages in the indexer ([5953e59](https://github.com/sile-typesetter/sile/commit/5953e59b3e66862f324bb57839531e89919fdb48))
* **packages:** Support page ranges in indexer ([a84d4ef](https://github.com/sile-typesetter/sile/commit/a84d4ef0a884288fe7e5f63fb8df8cbe4a47c4c1))
* **packages:** Use the CSL implementation by default for bibliographies ([d3c352b](https://github.com/sile-typesetter/sile/commit/d3c352b16635d03193bd51a62f1698f3744d4399))
* **shapers:** Warn when asked to measure a character not shaped in a font ([e0b5cd8](https://github.com/sile-typesetter/sile/commit/e0b5cd88fd326d19d47cd4cf17aae2ea74db1cfa))
* **typesetters:** Add content to text utility to the base typesetter ([6af4934](https://github.com/sile-typesetter/sile/commit/6af4934e6dbb2fda74339db43dd214490b2ff417))
* **typesetters:** Discourage page breaks after hyphenated lines ([ba49c8c](https://github.com/sile-typesetter/sile/commit/ba49c8c89a4f681a676b356f35b1b669ad3d2c23))


### Bug Fixes

* **classes,packages:** Use ex-height font adjustment for code ([5b52afc](https://github.com/sile-typesetter/sile/commit/5b52afc3095b874875fc12430be021858c899ce2))
* **font:** Properly cache fonts before use so a hook could look at them ([7e24648](https://github.com/sile-typesetter/sile/commit/7e24648a1947373e6c90d458dbb0674149f3f9d6))
* **languages:** Account for possible null termination in UTF-16 → 8 conversion ([#2243](https://github.com/sile-typesetter/sile/issues/2243)) ([e42b8de](https://github.com/sile-typesetter/sile/commit/e42b8deea1579d60db6403099e7f11786afcda99))
* **languages:** Fix Uyghur hyphenation ([2bff142](https://github.com/sile-typesetter/sile/commit/2bff1421bd3750c63eabd6f2cdaaf418c23d9070))
* **languages:** Move language setting declaration to after language supporte exists ([447df41](https://github.com/sile-typesetter/sile/commit/447df415380c7ceb5373cc55202d04ee20f86d92))
* **languages:** Update tests for changed ICU defaults ([bf6e0bc](https://github.com/sile-typesetter/sile/commit/bf6e0bc464683b8c58192da9c117f75120804fff))
* **math:** Script 'math' is needed for the ssty feature to work properly ([cb64f9e](https://github.com/sile-typesetter/sile/commit/cb64f9e6078077d3e70a5ac0c9516b450ccbf2cd))
* **packages:** Always use fake superscripts in bibliography for consistency ([97453b1](https://github.com/sile-typesetter/sile/commit/97453b13e163bd448fe6efaf5daa0b841c1dc8dc))
* **packages:** Apply default locale on locale overrides without xml:lang ([cd70266](https://github.com/sile-typesetter/sile/commit/cd702668e6b1f935b00e3d72c3c925c587cb2a6d))
* **packages:** Automatically register the indexer on endpage class hook ([d697388](https://github.com/sile-typesetter/sile/commit/d697388d604217e4046a4aa65cdb5c5fcecaf607))
* **packages:** Correct error handling the locator on some CSL styles ([21b751e](https://github.com/sile-typesetter/sile/commit/21b751eb8f423932c227448ea6e664d706772152))
* **packages:** Correct invalid links on CSL DOI, PMID, PMCID with affixes ([d8386ab](https://github.com/sile-typesetter/sile/commit/d8386ab18403c450b19e6bdef78d7d54c3a7b6bb))
* **packages:** CSL choose must inherit delimiter from nearest ancestor ([64eaba4](https://github.com/sile-typesetter/sile/commit/64eaba499b466dda185b4e75777d20b686fc5bff))
* **packages:** Honor affixes on multiple CSL citations correctly ([5de5607](https://github.com/sile-typesetter/sile/commit/5de5607fde3eadb93f77b7260a326c43396cf229))
* **packages:** Option "plural" on bibliography terms can be false ([4d4bae5](https://github.com/sile-typesetter/sile/commit/4d4bae5ed3bf957a45d93f97d96c3c17a557f9e5))
* **packages:** Suppress empty CSL macros ([98a7ebe](https://github.com/sile-typesetter/sile/commit/98a7ebe0d8094e15cbf1ef96dc946156848a51aa))
* **packages:** Use ex-height font adjustment for verbatim ([dae3849](https://github.com/sile-typesetter/sile/commit/dae384979cee963d1317aa668e34b76054297519))
* **packages:** Use language-dependent sorting (collation) in indexer ([5db2dcd](https://github.com/sile-typesetter/sile/commit/5db2dcda566d3ccbd2b4650751de4dee3bb20868))
* **shapers:** Properly calculate metrics of single characters composed of many glyphs ([2b109a0](https://github.com/sile-typesetter/sile/commit/2b109a05729684a6fd8343ed905781d1f8bf7642))
* **typesetters:** Special punctuation spaces need better italic correction ([448ab15](https://github.com/sile-typesetter/sile/commit/448ab15100ab12a790add49b75f5b4e792c9001f))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.10
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.9...v0.15.10
