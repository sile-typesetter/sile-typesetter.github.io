+++
title = "SILE v0.14.0 Is Released"
date = "2022-08-06"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

Version v0.14.0 of SILE has been released and is [available for download][release]!
See the included [CHANGELOG.md][changelog] or review the [commit history][commits] for more explicit details.

### Summary of Improvements

Work to refactor SILE's internals into a more regular API has been in progress for some time.
This release brings a big chunk of that work to light.
Many/most of the changes are under the hood and won't show up in the appearance of documents.
They do affect anybody writing classes or packages for SILE, hopefully for the better.

Most notably, 3rd party modules have *much* more robust support.
A module may be a class, a package, a typesetter, a shapper, an inputter, an outputter, etc.
This makes it easy for developers to extend SILE without needing to modify the core distribution.
Modules can be packaged and installed using LuaRocks.
[LuaRocks.org][luarocks] may be used to host and distribute SILE addons.
Rocks may also be distrusted independently.
Either way they are easy to install with `luarocks install` and such installs will make the modules available for loading into SILE.
The old built in package manager is still functional for now but deprecated.

The ergonomics of packages has changed a little.
The overloaded `\script` command has gained some more specialized peers.
For example Lua code may be passed in `\lua` commands.
To load a package or other module, use `\use[module=package.name]`.
This syntax also allows passing options to modules.

The inputters have been normalized a bit, and XML, SIL, and Lua are all first class input languages.
Passing some content in XML format from a SIL format document is as easy as placing it in an `\xml` command.
The same goes for SIL format content in an XML document.

3rd party developers may add new input formats as well!
All that is required is an inputter module that returns an AST.
Expect to see new inputters soon.
Didier Willis has already been working on a new Markdown inputter module.
Other XML based formats such Docbook have been supported for a while, but the new class and inputter APIs make them easier to add and use.

The CLI has gained several new options.
As usual `sile --help` and `man sile` both have relevant information.
Notably the `-I`/`--include` argument has been deprecated in favor of more explicit `-u`/`--use`, `-p`/`--preamble`, and `-P`/`--postamble`.
As you might expect from those options this makes it possible to load an inputter, class, or package from the command line without having it set in the document.
The preamble/postamble system has been cleaned up so content or code can easily be injected at the start or end of a document.
This is a change from the previous 'preamble' system that actually became the master document and then included the original master as effectively a postamble.

Many old shims and deprecated functions have been completely removed.
Most will still throw relevant warning messages with hints about how to update.

While I was busy moving cheese, several contributers were chipping in new features and fixes.
Rolf Marvin Bøe Lindgren pitched in Norwegian localization and improved hyphenation.
Mattéo Delabre contributed quite a few new features and fixes to the math package.
Didier Willis did some data mining and came up with localization strings for a whole slew of languages.
He also pitched in fixes to a number of packages.
He also has pending contribution for many new packages and features.
Be sure to checkout the PR scene on GitHub if you are looking for new features.

### ⚠ BREAKING CHANGES

* **packages:** The primary use was probably internal to SILE, but if
	by chance you have bibtex databases with formatting commands in SIL
	markup format rather than just plain text content the markup will cease
	to function and will need to be converted to XML syntax instead.

	This enables the use of declarative markup in Fluent localizations.

* **classes:** Each SILE package now inherits some interfaces from
	a common base package. This model allows packages easier access to SILE
	internals while at the same time tracking what they do so it is easier
	to enable/disable them. The package knows which document class instance
	it is attached to, and the document class knows which packages are
	loaded at any given time. Legacy style packages will continue to work
	for the time being but will not be tracked in the same way.

* **core:** The role of document commands has always been tightly
	scoped to classes. For example the *book* class has a `\footnote`
	command while *plain* does not—unless you manually load the package and setup the
	frames. In spite of this obvious functional scope, registering commands
	has been a global operation that stored them in a global registry. In
	order to allow SILE to be used more programmatically as a library with
	potentially more than one document and class being processed at at once,
	these need to be moved out of the global scope. This will also
	facilitate things like being able *unload* packages and revert to
	previous functionality for anything they over-rood on load. For now the
	functionality is shimmed, but code using the `SILE.registerCommand()`
	function should switch to the method of the same name on the current
	class, i.e. `class:registerCommand()`.

* **core:** Some internal files and APIs got renamed with more
	structured name spaces. In particular the inputter, shaper, and
	outputter libraries all have a common naming scheme now and sensible
	inheritance chains. No functionality was harmed, but if you are
	overriding undocumented internal Lua methods you might have to update
	your name spaces to match.

* **cli:** The `-I` / `--include` option was overloaded for more
	than one purpose and is now deprecated in favor of more specific
	replacements: `-r` / `--require` for loading code into SILE before input
	processing, `-p` / `--preamble` for processing content prior to
	a document and `-P` / `--postamble` for processing content after
	a document.

* **packages:** The original package manager POC that used Git to clone
	packages into the SILE installation directory has been deprecated. It
	will continue to function for a while, but all new 3rd party packages
	should use the LuaRocks based installation process. Whether or not they
	use `luarocks` as a package manager or LuaRocks.org as a distribution
	channel they should install themselves to any usable the system or user
	Lua library path under a top level "sile" namespace.

* **classes:** The shims allowing classes designed for SILE releases
	v0.12.x and prior have now been removed and documents using them will
	now throw errors when rendering. Only the refactored class system
	introduced in SILE v0.13.0 is supported going forward.

* **deps:** We previously deprecated all use of stdlib. This
	release stops providing it entirely. If you use it in your own projects
	you will now need to provide and require() it directly.

* **build:** The C modules compiled as shared libraries (.so files
	on Linux, .dll on Windows) are now installed to the project root shared
	directory instead of it's 'core' subdirectory. Distro packages that
	split the library into its own package will need to adjust this path.
	People installing from their distro packages or from source should be
	unaffected, but this will bring us one step closer to being able to
	install and use SILE *as* a library.

### Features

* **classes:** Add \use command to help deconflate \script usage ([eb298c3](https://github.com/sile-typesetter/sile/commit/eb298c3f24a48a0b2c63c9681024afb4eb1c5515))
* **classes:** Track loaded packages per document class ([32bd87b](https://github.com/sile-typesetter/sile/commit/32bd87b39b921ff889cd8e61a910e09f32f7a686))
* **cli:** Add CLI argument -E for evaluating Lua code after input ([5948aca](https://github.com/sile-typesetter/sile/commit/5948aca990e8d6548fcf753afeb50e5a5d6f7353))
* **cli:** Add usage hints and cleanup output of errors ([cc58824](https://github.com/sile-typesetter/sile/commit/cc58824a91b2ee042795b16a5c4223b5db85fb36))
* **cli:** Allow loading custom inputters from `-r` option ([a212e83](https://github.com/sile-typesetter/sile/commit/a212e834a05cf23702934f991e207ebc9e1615ef))
* **cli:** Allow passing options to any modules specified from --use ([4cdcae7](https://github.com/sile-typesetter/sile/commit/4cdcae756f51b681673d8187c876fac93fc8d2be))
* **cli:** Change --require to --use to match declarative markup ([2411328](https://github.com/sile-typesetter/sile/commit/2411328c72514a6a9db96fa9a3fd2d69f8fe284e))
* **core:** Add ability to pass args to modules via \use and other commands that load modules ([9e54bad](https://github.com/sile-typesetter/sile/commit/9e54bad757cbb9cddc725faf3478d2dca1c9c03c))
* **core:** Add ability to pass args to modules via \use and other commands that load modules ([e64ce0f](https://github.com/sile-typesetter/sile/commit/e64ce0f5c7b4d04a3ef9429f92ce57566c0c66c4))
* **core:** Add inline-escaping in SIL-language ([f09b135](https://github.com/sile-typesetter/sile/commit/f09b13578db44e87f0bef526b2027e35aac32c12))
* **core:** Support loading classes/packages installed with `luarocks` ([232e72b](https://github.com/sile-typesetter/sile/commit/232e72b39d1d9e72897ec2d50033d5fe5e5402e4))
* **i18n:** Add more Russion localizations ([350cf14](https://github.com/sile-typesetter/sile/commit/350cf1459e4143898de32d6e78da7871cf8946da))
* **i18n:** Add support for as many languages as possible ([da57577](https://github.com/sile-typesetter/sile/commit/da5757771a911555dc6b4adeaaec38041094ded0))
* **i18n:** Fallback to messages from 'und' language if no localized ([9f47715](https://github.com/sile-typesetter/sile/commit/9f477155dc6f3372477e3dd7859fe71bf41cec18))
* **i18n:** Parse XML style SILE commands in Fluent messages ([989290b](https://github.com/sile-typesetter/sile/commit/989290b255573c3a656eae3340c3944dd08e0c01))
* **inputters:** Allow arbitrary root elements from XML input without a preamble ([ad46a92](https://github.com/sile-typesetter/sile/commit/ad46a926494778830416f037bca54fe35a0b3998))
* **inputters:** Allow CLI to mandate inputter used for master document ([1b9009f](https://github.com/sile-typesetter/sile/commit/1b9009f96555f3127da6b434ba94cd7209f94f3d))
* **inputters:** Promote Lua to first class input filetype, improve input type detection ([3540943](https://github.com/sile-typesetter/sile/commit/3540943eb20f69a94d1ded638c7996c82cb96e34))
* **languages:** Add Norwegian localizations ([76b8f84](https://github.com/sile-typesetter/sile/commit/76b8f840b94a16ad65ad244308748c57c2fb1db0))
* **languages:** Add Norwegian Nynorsk hyphenation exceptions ([520cd3f](https://github.com/sile-typesetter/sile/commit/520cd3f594c843a343e4cea26c4f015f86250655))
* **languages:** Handle 'nb' code for Norwegian Bokmål, linked to 'no' rules ([373bd17](https://github.com/sile-typesetter/sile/commit/373bd1754ff3ce4459d856b4fddcc601c86eeff5))
* **math:** Add modulus operator support ([429b162](https://github.com/sile-typesetter/sile/commit/429b162ee6eac141deb0390ab762584d8cd93ee2))
* **math:** Allow forcing the atom type of an operator ([14d384c](https://github.com/sile-typesetter/sile/commit/14d384cec39446d34cb27db18f94e18920253ef7))
* **math:** Express lengths in “mu” (math units) ([39c7efc](https://github.com/sile-typesetter/sile/commit/39c7efceccad0a37bb30a70531cd91adb7975e51))
* **math:** Macros no longer wrap their replacement into <mrow>s ([d1f24b3](https://github.com/sile-typesetter/sile/commit/d1f24b3ab05fa29d567e34cf54f7b9a5c6c8f687))
* **math:** Print resulting mbox tree to debug log ([f2e7c33](https://github.com/sile-typesetter/sile/commit/f2e7c33ee553f0ff74be17b2e8aab776a762e62f))
* **math:** Support relative units in spaces and add standard spaces ([4f2bee2](https://github.com/sile-typesetter/sile/commit/4f2bee208be4cf4f1ebfbc35707977f3d19c0bb0))
* **packages:** Add new method to export package functions to class ([07a28a4](https://github.com/sile-typesetter/sile/commit/07a28a4da4cd392d6a07ac639f4cccf4014e82dc))
* **packages:** Allow configuring target folio frame from options ([74e3924](https://github.com/sile-typesetter/sile/commit/74e3924a9e0a5b6635e91d28d841d80634f8ec8d))
* **packages:** Provide API for registering commands linked to packages ([4875972](https://github.com/sile-typesetter/sile/commit/4875972c6942db2901c51fa4955e36df5d850466))


### Bug Fixes

* **build:** Update Flake to work with Nix >= 2.10 ([effb0dc](https://github.com/sile-typesetter/sile/commit/effb0dc8c96f8be655ab40c1a7a625b949f48688))
* **classes:** Reset default font direction if document direction changed ([11bb0f9](https://github.com/sile-typesetter/sile/commit/11bb0f9a8bf714fbd0f44730437c50b32fde437f))
* **cli:** Avoid throwing extra error on error without message ([0d530a5](https://github.com/sile-typesetter/sile/commit/0d530a5e5b195af8278e592f9ac45a465cb16cfa))
* **core:** Avoid error when outputting overflow warnings with specific measurements ([49ef650](https://github.com/sile-typesetter/sile/commit/49ef650217615548c65741b1cbe553631d0fa90d)), closes [#945](https://github.com/sile-typesetter/sile/issues/945)
* **debug:** Flatten content if necessary to process and debug location ([c753bd2](https://github.com/sile-typesetter/sile/commit/c753bd23ee5b15549d5f0f59a2df514d0411b9b4))
* **debug:** Re-implement option display in trace stacks lost with std ([01d2379](https://github.com/sile-typesetter/sile/commit/01d2379a9c36852eb4c3486e121b64fdd7d154f1))
* **inputs:** Drop Lua path handling duplicated in core ([8abb0f2](https://github.com/sile-typesetter/sile/commit/8abb0f28f82c5d60d7722b96b7bafeb5b2f8caf2))
* **math:** Fix caching of getMathMetrics ([3332698](https://github.com/sile-typesetter/sile/commit/333269851d2916687f8b5dedc191e8399a4590e4))
* **math:** Fix debug logs in TeX-like parsing ([a686f90](https://github.com/sile-typesetter/sile/commit/a686f90ec0650296a8406c17e642675774c5ec5f))
* **math:** Fix spacing before integral operators ([bc847b3](https://github.com/sile-typesetter/sile/commit/bc847b3856f7b70a71a2288568fabd6dde139288))
* **math:** Fix tostring functions in mbox subclasses ([7a7c6bc](https://github.com/sile-typesetter/sile/commit/7a7c6bc6318f2a7ef21caeb6586b077b25e5dccd))
* **math:** Set math elements to inherit hbox node properties ([0279556](https://github.com/sile-typesetter/sile/commit/0279556fa271f5117f04b520bec392d195c0d3db))
* **math:** Turn font name printing into debug log ([068ec4b](https://github.com/sile-typesetter/sile/commit/068ec4b06701202f3a1e9d05efa632e6e1a81cb5))
* **outputter:** Non-RGB colors shall work with the debug outputter ([#1469](https://github.com/sile-typesetter/sile/issues/1469)) ([e68dee3](https://github.com/sile-typesetter/sile/commit/e68dee3bb3ac593d03fcd3867c38b4483b3a8a9d))
* **packages:** Correct URL formatting when backend is not libpdftex ([fc4212d](https://github.com/sile-typesetter/sile/commit/fc4212dd672962bc48ad0cc86245494b6516a742))
* **packages:** Ensure grid hook is ineffective when grid is off ([b99482b](https://github.com/sile-typesetter/sile/commit/b99482b02c0cc09425a4910bc5b25671fb879a25)), closes [/github.com/sile-typesetter/sile/issues/1174#issuecomment-1173141699](https://github.com/sile-typesetter//github.com/sile-typesetter/sile/issues/1174/issues/issuecomment-1173141699)
* **packages:** Make \script command properly initialize packages ([#1479](https://github.com/sile-typesetter/sile/issues/1479)) ([9723d0d](https://github.com/sile-typesetter/sile/commit/9723d0dbd147287071cc49777c12ee365b4a5123))
* **packages:** Parse height argument to `\raise` / `\lower` as measurement ([#1506](https://github.com/sile-typesetter/sile/issues/1506)) ([7196fda](https://github.com/sile-typesetter/sile/commit/7196fdaa2497b92bb47a5a49bd82f732b90f4bcf))
* **packages:** Stop legacy package manager from adding empty paths ([cf9b9fa](https://github.com/sile-typesetter/sile/commit/cf9b9faa433f230a63cf9a8c1a56cbd256b1c5dd))
* **packages:** Stricter color parsing and improved color documentation ([f7b919a](https://github.com/sile-typesetter/sile/commit/f7b919ac5e9ad47f4c01531064be7bdae8d5311d))
* **packages:** The autodoc package could choke on some inputs ([#1491](https://github.com/sile-typesetter/sile/issues/1491)) ([c7db5d5](https://github.com/sile-typesetter/sile/commit/c7db5d5b3c5c6756ffe7e923ea3b938148167b2b))
* **utilities:** Correct traceback output for SILE.error() to show parent, not itself ([16b8900](https://github.com/sile-typesetter/sile/commit/16b8900546667e671f794a384e88892f94739d40))


### Miscellaneous Chores

* **build:** Move C modules to same relative location in source directory as installed ([55ad795](https://github.com/sile-typesetter/sile/commit/55ad79541c6c3908685e6cafedf2c96926d85d37))
* **classes:** Remove stdlib class shims ([c4210da](https://github.com/sile-typesetter/sile/commit/c4210dac55c5c80b8f169541b57d5f612706f45a))
* **cli:** Deprecate CLI argument -I in favor of -r, -p, and -P ([d63a484](https://github.com/sile-typesetter/sile/commit/d63a4840f3970b2664743036847d8a7aebf1c623))
* **deps:** Stop providing Lua stdlib ([8a8c0e9](https://github.com/sile-typesetter/sile/commit/8a8c0e96e62e8288961333de2d468fca3a86e20a))
* **packages:** Deprecate legacy package manager ([b72653c](https://github.com/sile-typesetter/sile/commit/b72653c274b5779af8261843505049bc89a8d301))


### Code Refactoring

* **core:** Move inputters/shapers/outputters to isolated classes ([14329ce](https://github.com/sile-typesetter/sile/commit/14329ced288c40de5d61e01666afd41446511d45))
* **core:** Move registerCommand() out of global to classes ([bc527ea](https://github.com/sile-typesetter/sile/commit/bc527ea400f16b5970c77b609377ee3321e1bf42))
* **packages:** Process bibtex content as XML not SIL ([a259b32](https://github.com/sile-typesetter/sile/commit/a259b32490546c0a55bcec1a41dc04f48acb2711))


  [release]: https://github.com/sile-typesetter/sile/releases/tag/v0.14.0
  [changelog]: https://github.com/sile-typesetter/sile/blob/master/CHANGELOG.md
  [commits]: https://github.com/sile-typesetter/sile/compare/v0.13.3...v0.14.0
  [luarocks]: https://luarocks.org
