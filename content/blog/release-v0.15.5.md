+++
title = "SILE v0.15.5 Is Released"
date = "2024-08-29"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.5 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This is a relatively minor maintenance release.
Thanks again to ongoing work by [Didier Willis](http://github.com/Omikhleia), support for bibtex format bibliographies is improving.
Date and author parsing and rendering has been improved.
Support for CSL is still brewing in the [bibliography][] project.

Additionally the `--quiet` flag now correctly suppresses all parts of warning messages for cleaner output when you don't want to debug your project.
Even more behind the scenes, the entire code base has also been spell-checked, with hundreds of words in comments, code, and documentation being corrected.


### New Features

* **packages:** Support biblatex date field and improve date formatting ([5169d67](https://github.com/sile-typesetter/sile/commit/5169d678588bd47bc86b9b65686b9408f14f0208))


### Bug Fixes

* **build:** Fix distribution of unit tests clean up dist file list ([00abf9b](https://github.com/sile-typesetter/sile/commit/00abf9b9497e9bfa8565b7768479ef0e241522bb))
* **classes:** Make document state available during class's post init ([71336b9](https://github.com/sile-typesetter/sile/commit/71336b9434a3dc90601ac73a94e80e6f0da9db58))
* **cli:** Suppress trace info in quiet for warnings but do show errors ([e12dcc9](https://github.com/sile-typesetter/sile/commit/e12dcc9d07ead3e70c2f1bee9874a4be0ce574e4))
* **packages:** Parse and split all bibtex name fields ([e3a7dc1](https://github.com/sile-typesetter/sile/commit/e3a7dc197e86f651edac1915c288b1085ecbb041)), closes [#2052](https://github.com/sile-typesetter/sile/issues/2052)
* **packages:** Use non-breakable space in bibTeX name splitting, not tilde ([f4ea4ed](https://github.com/sile-typesetter/sile/commit/f4ea4ed0a24ea9d821dfed0d8e20cadd78f6d95d))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.5
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.15.4...v0.15.5
  [bibliography]: https://github.com/orgs/sile-typesetter/projects/12

