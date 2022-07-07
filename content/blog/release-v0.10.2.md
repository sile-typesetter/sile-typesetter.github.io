+++
aliases = ["2020/02/sile-0-10-2-is-released"]
title = "SILE v0.10.2 Is Released"
date = "2020-02-03"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.10.2 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

This release primarily fixes minor packaging issues. The biggest change is this will be the first release with an officially supported [Ubuntu PPA](https://launchpad.net/~sile-typesetter/+archive/ubuntu/sile)! In addition to the previously available installation methods Ubuntu users will be able to install sile with:


```sh
sudo add-apt-repository ppa:sile-typesetter/sile
sudo apt-get update
sudo apt-get install sile
```

### Notable Bug Fixes

* **build:** Don't include build *.so modules in dist ([4eb2a73](https://github.com/sile-typesetter/sile/commit/4eb2a731b131bab0c1f86ac12b112e2b9035cb15))
* **build:** Fix version detection in sparse git checkouts ([#803](https://github.com/sile-typesetter/sile/issues/803)) ([e46091f](https://github.com/sile-typesetter/sile/commit/e46091f7f9051b6daed07bfc76d05ab550adde2b))
* **build:** Include modules for all supported Lua versions in dist ([a4e9f03](https://github.com/sile-typesetter/sile/commit/a4e9f0380243684737f884a2111615f391170324))
* **build:** Look for Lua 5.3 executables with the version in their name ([3952bf8](https://github.com/sile-typesetter/sile/commit/3952bf8de762723ec6dff950bc9a498fe6e991d3))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.10.2
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.10.1...v0.10.2
  [wiki]: https://github.com/sile-typesetter/sile/wiki
