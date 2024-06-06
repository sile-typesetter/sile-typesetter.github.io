+++
title = "SILE v0.15.0 Is Released"
date = "2024-06-06"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.15.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

In the works for over a year with over 500 commits and 100 issues closed, please welcome the biggest single release in SILE history.
This is the big “Rewrite it in Rust”!
*Caveat lector.*
In truth this is a big release but it is **not** a rewrite.
All the SILE internals are still written in Lua and 100% user modifiable at runtime.
From an end user or 3rd party module developer standpoint little has changed.
However SILE itself is now a compiled Rust application that includes its own Lua interpreter.
The build process can (optionally) embed all the Lua and other resources files that makeup SILE and its dependencies in a single binary.
This opens the door for improvements such as being able to leverage Rust libraries (including exposing their functions to Lua),
    write some parts of core functions in Rust for performance or preference,
    write modules in languages other than Lua or C,
    package SILE for platforms where Lua is not easy to get running,
    and much more.

The language change mostly affects building and packaging SILE itself.
Once running, relatively little has changed with the *way* SILE interacts with documents.
However quite a number of default settings have been changed.
See the *Usage* section of these release notes and the `retrograde` module for tips on this not being too disruptive.

For a transition period, the Lua based CLI is still available as `sile-lua`.
This may be useful for scripting environments that generate inputs and/or parse the output of SILE itself.
These should be transitioned to the new Rust CLI `sile` which has a few minor differences in argument handling and output message formatting.
The Lua CLI will only be available fol a limited number of future releases.
Please do report any issues using the new CLI.

Extra thanks to Didier for lots contributions and input during the development cycle;
    and also to Fredrick for generous sponsorships that enabled me to commit quite a bit more time to development.

#### Installation: For Anyone Installing From Packages

If you install SILE from your distro's package manager or other packaging, nothing about your process needs to change.
Update and enjoy.

#### Installation: For Distro Packagers and Source Installations

If you install from source or package SILE, the build system has new dependencies.
It now requires Rust tooling (`cargo`, `rustc`) as well as some more utilities (`jq`) at build time.
No new dependencies are needed at run time.
In fact it is now no longer necessary to use a Lua VM available at runtime.
SILE brings its own Lua VM along.
Optionally it can also be setup to embed all of its runtime dependencies in a single binary.

The default Lua VM has been switched from whatever the system supplied to to LuaJIT.
This is roughly equivalent to Lua 5.1 and doesn't have some niceties from 5.4, but it is much much faster.
At build time SILE can be configured to used any version of Lua of your choice.
This can be used to match compatibility with 3rd party modules or other system components.

#### Usage

A number of command behaviours and default settings have been changed.
This *will* likely cause documents to render with a different flow.
It will also break support for some 3rd party modules which will need to be updated to match.
Many (but not all) of the changes can be temporarily disabled to cause as few changes when rendering old documents as possible.
A new module called `retrograde` can be loaded at run time that will reset defaults and even revert some commands and functions to their previous behavior.
A target argument can be passed for the version of SILE your document was designed for.
Any default setting changes and as much other functionality as practical that may have changed since that release will be reverted.

```console
$ sile -u 'packages.retrograde[target=v0.14.17]' <INPUTS>
```

Since the Lua VM version used by default is different, you may need to reinstall 3rd party modules with a matching Lua version.
You can first query SILE to understand what version of Lua it is using.
With that information you can specify the Lua version you want when you install modules as LuaRocks to match.
As a demonstration we'll install a Markdown input module in a project-local directory where SILE will find it without extra path configuration, then use it to render a PDF file:

```console
$ sile -q -e 'print(SILE.lua_version); os.exit()'
5.1
$ luarocks --lua-version 5.1 --tree lua_modules install markdown.sile
...
$ echo '# Test *Markdown*' > test.md
$ sile -u inputters.markdown test.md
...
```


### ⚠ BREAKING CHANGES

* **packages:** Lists now respect the input document spacing and normal settings with regard to paragraphs breaks before, after, and inside lists. This is place of overriding the paragraph skip settings to match the list item spacing setting and always forcing paragraph breaks before and after lists.

* **classes:** Hitherto SILE has cleared the current.parindent setting as soon as it used it at the beginning of a paragraph. With this release, the setting is not being cleared until a paragraph is explicitly ended. This will not have an affect on many documents, but could completely blow up layout code that implicitly relied on the effect. Normal paragraphs (e.g. separated by a blank line in the input) and any use cases that explicitly called far ending a paragraph (e.g. by calling `\par`) will be unaffected. But anywhere a paragraph break was simulated by adding vertical space, the indentation will not be applied the next start of a line. This means that calling any variant of `\skip` inline in a paragraph will result in content beginning on a new line without using the parindent setting.

    Fixing this change in behaviour requires either explicitly resetting the current.parindent setting *after* it is initially used or explicitly ending a paragraph before or after placing a vertical skip.

* **inputters:** Input documents using the SIL language will now retain whitespace more consistently. Whitespace following environment blocks is no longer swallowed in differently than space following command syntax. Consecutive line breaks in the input will consistently trigger new paragraphs no matter what they follow.

    Note that this change cannot be patched over via the retrograde package settings because by the time your document could specify what packages to load or settings to set, the input document has already been parsed. To achieve the same rendering results where environments could be ended leaving any amount of blank lines and still joined to the following content as part of the same paragraphs, you will need to remove the extranious whitespace.

* **core:** Several top level instance creaters of various names have been re-organized under SILE.types.

    Specifically SILE.color, SILE.measurement, and SILE.length have the same names, just under SILE.types.<name>. Additionally SILE.nodefactory is now SILE.types.node and SILE.units is not SILE.types.unit.

    This brings a little bit of sanity to the naming schemes so that you can guess how to use something from the name, but it also makes room for 3rd party add ons to more easily extend or replace these functions. It also makes it easier to start substituting Rust bits where desired.

* **core:** Use SILE.papersize() instead of SILE.paperSizeParser()

* **classes:** The "center", "raggedleft" and "raggedright" environments formerly reset the margins (left or right skips), meaning they'd take the full frame width. They all cancelled the paragraph indent. The new behaviour honors the fixed part of the parent context's margins, meaning that if you have an environment playing with margins such as an epigraph or an indented quote, those margins are not lost. The raggedleft and raggedright environment also now no longer cancel the pararagraph indent.

* **classes:** The \script function was heavily overloaded to have many different functions at once and more targeted tools were introduced in SILE v0.14.0 To load 3rd party modules designed for use with SILE, use \use[module=...] instead of \script[src=...]. To run arbitrary Lua code inline use \lua{}; Lua code may be provided inline or externally via either a require= option to load a regular (non-SILE) Lua module using the Lua module path or src= option to load a file by file path.

* **core:** For ... reasons ... the default width of spaces in SILE has been a hightly opinionated and non-standard 1.2 spaces. While it can be argued that this makes some fonts and some documents look better, it is a very strange thing to have as a global default. Unfortunately setting it back to a more conventional 1 space is a major change and will cause many/most documents to reflow.

    The old default can be recovered either in documents with:

    ```sile
    \set[parameter=shaper.spaceenlargementfactor,value=1.2,makedefault=true]
    ```

    ...or even from the CLI when rendering a document:

    ```console
    $ sile -e 'SILE.settings:set("shaper.spaceenlargementfactor", 1.2, true)'
    ```

* **core:** The previous default paragraph indent was hard coded with a point size (20pt) that did not adapt will to different fonts or page layouts. The new default uses a relative unit that will adjust based on the leading (1bs). This will cause most documents to reflow. To keep them the same the setting may be reset to the old default either in the document:

    ```sile
    \set[parameter=document.parindent,value=20pt,makedefault=true]
    ```

    ...or even from the CLI when rendering a document:

    ```console
    $ sile -e 'SILE.settings:set("document.parindent", "20pt", true)'
    ```

* **utilities:** For modules that rely on `SILE.utilities` (`SU`), and in particular raw content handling functions `subContent()`, `walkContent()`, `stripContentPos()`, `hasContent()`, and `contentToString()`, these and similar functions have been moved into `SILE.utilities.ast` (`SU.ast`). The `subContent()` implementation also no longer adds id="stuff" attributes to everything.

* **packages:** The default rendering of Ruby readings has changed from just using a bold weight to using the OpenType +ruby feature. Fonts that support this should work with no change, but documents rendered in fonts that do not support it will neet to set the `ruby.opentype` feature to `false` to get the same rendering method as before.

* **classes:** The former implementation of the "em" command did not support nesting and was just setting the font style to italic. The command now alternates italic and regular when nested. * **packages:** The current (pseudo) idempotent behaviour when loading a package potentially clobbers anything that has been modified since the last load. Loading a package, then modifiying a function it provides, then loading the same package again will clobber the modifiecation. This is good for idempotency but not very good for user experience when you may not be modifiying all aspects of a document render pipeline at once, as in when using templates.

    This change makes the default behaviour to run setting, raw handler, and command registrations only once. An altertanive to :loadpackage() called :reloadpackage() can be used to force all these registrations to be rerun when the goal is to make sure of a specific state.

* **classes:** Remove obsolete/broken native markdown class

* **core:** The internal package manager that installed stuff to the system from inside SILE was deprecated back in v0.13.2. It is now completely removed. External 3rd party packages are fully supported using LuaRocks and are much more robust.


### Features

* **build:** Make vendoring Lua sources controlable at build time ([773245b](https://github.com/sile-typesetter/sile/commit/773245b8dcb8df1bc983c7320cb1ad2cdd46784d))
* **build:** Set default Lua version to prefer LuaJIT ([#1873](https://github.com/sile-typesetter/sile/issues/1873)) ([8a8b506](https://github.com/sile-typesetter/sile/commit/8a8b506fde16c677e5229f0ad5f60be28aeb7373))
* **classes,outputters,packages:** New approach to full bleed printing, cropmarks, background ([aa538e2](https://github.com/sile-typesetter/sile/commit/aa538e215ddb4716e8360899e98fb6ef1512e477))
* **classes:** Make text alignment commands honor nesting and margins ([7cde8a3](https://github.com/sile-typesetter/sile/commit/7cde8a31ff65913e8aed8784183cc939116c18d2))
* **classes:** Provide a "blockquote" environment in the plain class ([75a8bdf](https://github.com/sile-typesetter/sile/commit/75a8bdf35a9ad470d45559ce9c373d8983ba75e3))
* **classes:** Support emphasis nesting ([0c1c017](https://github.com/sile-typesetter/sile/commit/0c1c017c05a8c197dd5120afea2f769ffc5c89be))
* **cli:** Add configure time option to embed Lua resources in binary ([9f11100](https://github.com/sile-typesetter/sile/commit/9f1110049a25bb59de6d2c9aef6b5945b58ec8b0))
* **cli:** Allow more than one input document (Rust edition) ([bdfeecd](https://github.com/sile-typesetter/sile/commit/bdfeecd9c87b74e355ba297b698f817b95d32fef))
* **core:** Allow multiple runtime SILE_PATH segments ([b329923](https://github.com/sile-typesetter/sile/commit/b3299239f608fea68d7b9c491e6f25e7abc889c0))
* **core:** Allow multiple runtime SILE_PATH segments in Lua binary as well as Rust ([5e05fa9](https://github.com/sile-typesetter/sile/commit/5e05fa918cbb3a1c3be496dcb1bc06d86bcfec6c))
* **core:** Automaticalyl include project-local lua_modules in module loader path ([fd940a9](https://github.com/sile-typesetter/sile/commit/fd940a9e0a8d2f813c04c80d408755a28957dcea))
* **core:** Make it easier to add project-specific LuaRocks trees as dependencies ([796b344](https://github.com/sile-typesetter/sile/commit/796b344e557895c5448e552898a808750d382835))
* **docker:** Add all default fonts and package management tooling to container ([6bd5dc0](https://github.com/sile-typesetter/sile/commit/6bd5dc03ff930e881e7d4fe1d9287a8a22f93ef9))
* **docker:** Automatically adjust Docker user to owner of mounted data ([4ee535f](https://github.com/sile-typesetter/sile/commit/4ee535f79db2a3ab9ef2c325ccfd6466de526ea9))
* **docker:** Deploy upcoming major version branches to a `develop` tag on GHCR ([bd2c6f3](https://github.com/sile-typesetter/sile/commit/bd2c6f35aaaa2a3739e5e65adb39b3868b87c2a1))
* **docker:** Enable data for all provided tools that support system locales ([c01203f](https://github.com/sile-typesetter/sile/commit/c01203f2bd08ae8f17da2854679a6cd194082e47))
* **docker:** Make it easier for users to install stuff into the images ([71aa6f2](https://github.com/sile-typesetter/sile/commit/71aa6f2a11c9e61ca054e1d6fe5ac772f2d66f26))
* **inputters:** Add formal grammar specification for SIL files ([5f78af3](https://github.com/sile-typesetter/sile/commit/5f78af34580d1d9afab6f343d5da2455689008ef))
* **inputters:** Output source comments in SIL debug info ([672226f](https://github.com/sile-typesetter/sile/commit/672226f7b5d2d96eb9df32b368f2c6cfaf485e8d))
* **math:** Support numbering display math equations ([d2e348f](https://github.com/sile-typesetter/sile/commit/d2e348fcc999e77126648e09663495f0d8306510))
* **outputters:** Add hook system to outputters ([b5422a8](https://github.com/sile-typesetter/sile/commit/b5422a83dd7727c671359a8a926ab5bbc450b1b2))
* **outputters:** Add support for pdf elements to debug outputter ([a33e5c7](https://github.com/sile-typesetter/sile/commit/a33e5c73d956f07ffb70830032aeb7fb79107e5f))
* **packages:** Add package to reset some defaults similar to previous releases ([fa8d401](https://github.com/sile-typesetter/sile/commit/fa8d40111736d1867d075b44da49d8dbb80af143))
* **packages:** Backport default font change from v0.9.5 to retrograde package ([6b5f52d](https://github.com/sile-typesetter/sile/commit/6b5f52d37bae44c710eea17b297f038157eb1164))
* **packages:** Expand retrograde package to handle behavior shims ([a549b44](https://github.com/sile-typesetter/sile/commit/a549b445700641fcaad7ea91ef3f879cdbfd0945))
* **packages:** Expand retrograde package to shim paragraph indentation changes ([bead177](https://github.com/sile-typesetter/sile/commit/bead177b28e0ad576797446bb95155c4449e508d))
* **packages:** Make most package _init() actions run only once ([ed3331a](https://github.com/sile-typesetter/sile/commit/ed3331af4b9ed60a0010b7f8b617135e1323f5e6))
* **packages:** PDF links can now span multiple lines ([842cb56](https://github.com/sile-typesetter/sile/commit/842cb5640ff61e297fbd3299eaafe55e07ef30db))
* **packages:** Remove arbitrary six-level maximum to list nesting ([ee76eab](https://github.com/sile-typesetter/sile/commit/ee76eab3b51124e3041b3d96b0be0309153c5110))
* **packages:** Strikethrough and underline can span multiple lines ([3eb1a1f](https://github.com/sile-typesetter/sile/commit/3eb1a1f944594283bb68e5876eeaf692dd92678a))
* **packages:** Use OpenType +ruby feature for ruby, toggle with setting ([624e3a8](https://github.com/sile-typesetter/sile/commit/624e3a8888c173497b39c13460604ce55d42ded0))
* **settings:** Add hook callback system for settings ([efade76](https://github.com/sile-typesetter/sile/commit/efade7614f02b59991560bb61beb94ae745bf554))
* **settings:** Allow \set with no parameter as a temporary wrapper ([59755c9](https://github.com/sile-typesetter/sile/commit/59755c98fa640ae3274c0bb3c21ab8c5b9c942a6))
* **tooling:** Add direnv support ([a52e6e5](https://github.com/sile-typesetter/sile/commit/a52e6e5aa2087719356f8d0cc0cafdbac46927c0))
* **tooling:** Add DRAFT flag to allow rendering docs without regenerating TOC ([f581b54](https://github.com/sile-typesetter/sile/commit/f581b54a0dcf23fc7e0d64dc4206cfea68c4a2e3))
* **tooling:** Add nix builds with various lua versions ([c28cd94](https://github.com/sile-typesetter/sile/commit/c28cd9410d817d4a8c6e432076e2f8b5cdae80a7))
* **tooling:** Add nix packages building sile with clang ([5b30695](https://github.com/sile-typesetter/sile/commit/5b30695f4d5618e24aa9af2fbf5ea1b297ffadc5))
* **tooling:** Add tooling to generate Lua API documentation from sources ([3995e14](https://github.com/sile-typesetter/sile/commit/3995e1498745055a2b9e71a6c2b027e66fe7fc9e))
* **types:** Add __tostring to colors for easier debugging ([e1106a7](https://github.com/sile-typesetter/sile/commit/e1106a7ab92cc4e9ec34a532b4556e417a386881))
* **typesetter,shaper:** Add automated italic correction heuristics ([540b0cf](https://github.com/sile-typesetter/sile/commit/540b0cf7d836bec9bd702ba09236bf14791df421))
* **typesetters:** Add base typesetter (multi-)liner support ([e645dbd](https://github.com/sile-typesetter/sile/commit/e645dbd300fcc6541e8e62445eb1d405a04503b3))
* **utilities:** Add Greek alphabetical (non-arithmetic) numbering ([34e2e53](https://github.com/sile-typesetter/sile/commit/34e2e533503d4ef72bf605c9012d192a2591ed8f))
* **utilities:** Automatically cast anything passed to SU.debug to a string ([da80c56](https://github.com/sile-typesetter/sile/commit/da80c56d6ac39e3961bab0ec8473356d54b7075d))
* **utilities:** Make it easier to search breadcrumbs excluding the current command ([64e8d3b](https://github.com/sile-typesetter/sile/commit/64e8d3bb318a4c4f1553a0b233c2b7f09add2096))
* **utilities:** Refactor and extend AST-handling utilities ([fc7e7fb](https://github.com/sile-typesetter/sile/commit/fc7e7fbaad05b37aef573e10058209ca0eb8d123))


### Bug Fixes

* **backends:** Fix plain text backend to work in LuaJIT/Lua 5.1 ([d0a2a1e](https://github.com/sile-typesetter/sile/commit/d0a2a1ee9645ee357fd8efa3e6b9406aad7ddf1c))
* **build:** Adjust macfonts module to more robustly import AppKit ([c0571be](https://github.com/sile-typesetter/sile/commit/c0571befc9187f74e9f8376ed238382fd87fac36))
* **build:** Avoid race condition by making sure binary exists before use ([d37da35](https://github.com/sile-typesetter/sile/commit/d37da35a292bd86738832fc3edb084ff82a5d311))
* **build:** Correct configure flag so debug builds are not release mode ([d931849](https://github.com/sile-typesetter/sile/commit/d931849f93c50a2722e07411579f891708b53fc6))
* **build:** Fix build configuration for --with-system-libtexpdf ([d22ea34](https://github.com/sile-typesetter/sile/commit/d22ea347055ae2e183efc617d45a9e09b03b89c0))
* **build:** Move build-time dependency checks out of runtime dep check configure flag ([5e587bd](https://github.com/sile-typesetter/sile/commit/5e587bdb2574f1e385fe24a1826bdbdb2e4c5253))
* **build:** Stop copying libraries places autotools doesn't normaly handle them ([68d9008](https://github.com/sile-typesetter/sile/commit/68d900804ada4b9dceefe36604b2b22ccfaaffd4))
* **build:** Switch from xz to zst compression for official artifacts ([685780d](https://github.com/sile-typesetter/sile/commit/685780de79c299152221baec0da9cb5498878ec8))
* **classes:** Reset current parindent at end of paragraphs, not beginning ([84c70fd](https://github.com/sile-typesetter/sile/commit/84c70fdf6fba4d9a644b35bf0ee9cbfcd029798f))
* **core:** Output makedepends file after class finish and snippets ([f59670c](https://github.com/sile-typesetter/sile/commit/f59670c95f31cb404ce6bfcd99e4ab750f5387ea))
* **core:** Use unique function name so static linking doesn't clobber Lua-5.1 ([ccdb8a2](https://github.com/sile-typesetter/sile/commit/ccdb8a2d873e45fa3c703fa2a5ab87c628078248))
* **docker:** Use LuaJIT not Lua5.1 for docker builds ([7687bf6](https://github.com/sile-typesetter/sile/commit/7687bf663f281e764b8c848701e11ed81e4f097e))
* **inputters:** Allow empty string as option value in SIL parser ([160501c](https://github.com/sile-typesetter/sile/commit/160501cc8e424a0fffac8a4a9641f760ec7861a0))
* **inputters:** Correct typo in SIL parser, disallow conflicting commands ([923b11e](https://github.com/sile-typesetter/sile/commit/923b11eb46c4e3930c540a249e6320704a54294d))
* **inputters:** Make whitespace after envirnomnts behave the same as commands ([6d51ee3](https://github.com/sile-typesetter/sile/commit/6d51ee3d819902a052b76fbb0acd13cf3d45a038))
* **languages:** Handle UTF8 properly in Liang hyphenation ([b33c11c](https://github.com/sile-typesetter/sile/commit/b33c11ce46766e9280d255e62075ea96c499eeac))
* **languages:** Load default en language support if none explitly requested ([#2036](https://github.com/sile-typesetter/sile/issues/2036)) ([d02b063](https://github.com/sile-typesetter/sile/commit/d02b063a918b9c035138838e456945ff6d294b61))
* **packages:** Color changes shall not affect other content at page breaks ([9d6d409](https://github.com/sile-typesetter/sile/commit/9d6d409a5cb2f593f5c2dee349aad67c8bdacf83))
* **packages:** Correct bogus mixup of variable names in package inits ([8dfe3c3](https://github.com/sile-typesetter/sile/commit/8dfe3c3f070324ba0aced587fccbd063944fe4c0))
* **packages:** Fix broken font fallback clear function ([2b15de5](https://github.com/sile-typesetter/sile/commit/2b15de500371fa6cbdfdf6f302c1360b4a023883))
* **packages:** Use current pagebuilder API not deprecatod one internaly ([730150f](https://github.com/sile-typesetter/sile/commit/730150f9b7a759b2564461b95778bdd27df20b2e))
* **tooling:** Add npx to nix' devShell ([624137f](https://github.com/sile-typesetter/sile/commit/624137fc0aaad08794a41c12dfbea2db64cff066))
* **tooling:** Fix Nix build for rustier sile ([f53904c](https://github.com/sile-typesetter/sile/commit/f53904c629d99d8eeeee7704fdfa6c396b899633))
* **tooling:** Really ignore all nix symlinks ([34b0493](https://github.com/sile-typesetter/sile/commit/34b0493aa3fbc9447f1a723f4101ad2419b69d7f))
* **typesetters:** Debug hbox could show incorrectly offset boxes ([c5113b7](https://github.com/sile-typesetter/sile/commit/c5113b72ddb44f2f6712ac45ff3e5b1668e27166))
* **utilities:** Cast empty to default and only ever return a bool from SU.boolean() ([ba2e37a](https://github.com/sile-typesetter/sile/commit/ba2e37a9959cebf1e0a334351a4041ee026bac4c))
* **utilities:** Fix broken breadcrumbs:contains() ([f1972bd](https://github.com/sile-typesetter/sile/commit/f1972bdee0489abc3a2c13e45309dfdc589e3f9a))


### Performance Improvements

* **utilities:** Leave tostring() casting to after debug invocations, not before ([72965ad](https://github.com/sile-typesetter/sile/commit/72965ada011b2fac942cfb08e09df2ff9b8a5ce5))


### Miscellaneous Chores

* **classes:** Deprecate \script in favor of more explicit options ([b738507](https://github.com/sile-typesetter/sile/commit/b73850745f283fa600ce9aa85a3a22b17641369c))
* **classes:** Remove obsolete/broken native markdown class ([133567e](https://github.com/sile-typesetter/sile/commit/133567e5bb208cce52f748ee6d530d04774c0caa))
* **core:** Change default paragraph indent to 1 baseline skip ([542c869](https://github.com/sile-typesetter/sile/commit/542c869cca59354a3f9319a844459467f92acf0d))
* **core:** Change default space width to 1 space ([66cdbad](https://github.com/sile-typesetter/sile/commit/66cdbad9b991df6664b2729da266f224afeeea55))
* **core:** Deprecate SILE.paperSizeParser() ([4486a19](https://github.com/sile-typesetter/sile/commit/4486a194efd9ae89491d43f67028a54e57db073c))
* **core:** Remove deprecated package manager ([4836a93](https://github.com/sile-typesetter/sile/commit/4836a9369cdd9bd6da54e443d7fefb37a6bd4558))


### Code Refactoring

* **core:** Move assorted classes from oddball names in core to types ([8287a0f](https://github.com/sile-typesetter/sile/commit/8287a0f316cc876231eeea643e7338db318932c4))
* **packages:** Stop overriding paragraph handling in and around lists ([8b2117c](https://github.com/sile-typesetter/sile/commit/8b2117cfa7386065709deb1ea143c5bcf3d90014))

  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.15.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.14.14...v0.15.0
