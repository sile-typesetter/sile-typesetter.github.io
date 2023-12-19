+++
title = "SILE v0.15.0 Is Released"
date = "TBD"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

The big rewrite in Rust!
*Caveat lector.*
In truth this is a big release but it is **not** a rewrite.
All the SILE internals are still written in Lua and 100% user modifiable at runtime.

metrics default changes, see usage and retrograde

Lua VM default change, see notes on installing matching 3rd party packages

For transition, `sile-lua` (but report issues with the default `sile`).

#### Installation: For Anyone Installing From Packages

If you install SILE from your distro's package manager or other packaging, nothing about your process needs to change.
Update and enjoy.

#### Installation: For Distro Packages and Source Installations

If you install from source or package SILE, the build system has new dependencies.
It now requires Rust tooling (`cargo`, `rustc`) as well as some more utilities (`jq`) at build time.
No new dependencies are needed at run time.
In fact it is now no longer necessary to have a system Lua VM available at runtime.
SILE brings it's own Lua VM along at runtime.
Optionally 

default switch to LuaJIT.

#### Usage

Breaking changes

Changed defaults

```console
sile -u 'packages.retrograde[target=v0.14.14]' <INPUTS>
```

Installing 3rd party modules that match the Lua version:


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.14...v0.15.0
