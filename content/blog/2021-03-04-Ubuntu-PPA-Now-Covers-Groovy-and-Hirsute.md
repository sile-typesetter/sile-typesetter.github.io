+++
title = "Ubuntu PPA Now Covers Groovy and Hirsute"

[extra]
post_author = "Caleb Maclennan"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++
Our “official” Ubuntu [PPA][] with prebuilt SILE packages –including all the dependencies missing from the base Ubuntu package set– fell a little bit behind last month. In fact it never got updated with the SILE [v0.10.14][] release. It has been revived and is now up to date with [v0.10.15][] packages.

As before, both of the last two major [LTS releases][codenames] are supported: Bionic Beaver (18.04) and Focal Fossa (20.04). In addition, as of today the distribution coverage has been expanded to cover both of the currently active short term releases. We were late getting on the ball with Groovy Gorilla (20.10) and it is already nearing the end of its short lifespan but if you are using it, SILE packages are available. To make up for the tardyness we're early with Hirsute Hippo (21.04) support and SILE packages are available for it now — even ahead of it's official release in April.

Usage is the same as before for all distros:

```sh
sudo add-apt-repository ppa:sile-typesetter/sile
sudo apt-get update
sudo apt-get install sile
```

The two latest distros Groovy and Hirsute should support Lua 5.4 as well. If you encounter any trouble with any of these packages feel free to open a [new issue report][newissue] on our GitHub tracker.

Lastly if anybody knows their way around Launchpad and Ubuntu package devoplement and is interested in helping automate and maintain the packaging, we're willing to accept help. Maintaining packaging for distros we don't use personally is quite a bit of mental overhead.

  [v0.10.14]: /2021/02/sile-0-10-14-is-released
  [v0.10.15]: /2021/03/sile-0-10-15-is-released
  [PPA]: https://launchpad.net/~sile-typesetter/+archive/ubuntu/sile
  [codenames]: https://wiki.ubuntu.com/Releases
  [newissue]: https://github.com/sile-typesetter/sile/issues/new
