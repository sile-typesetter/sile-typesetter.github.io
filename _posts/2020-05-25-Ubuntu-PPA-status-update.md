---
title: Ubuntu PPA Status Update
post_author: Caleb Maclennan
post_gravatar: 11cdaff4c6f9b290db40f69d3b20caf1
---

Beginning with the release of SILE [v0.10.2][] we started building native packages for Ubuntu and distributing them in an official [PPA][]. Initially, builds were only available for Ubuntu 18.04 (Bionic Beaver). Packages for SILE [v0.10.4][] are now available for Ubuntu 20.04 (Focal Fossa) as well.

Usage is the same as before:

```sh
sudo add-apt-repository ppa:sile-typesetter/sile
sudo apt-get update
sudo apt-get install sile
```

It would be possible to support other currently supported [Ubuntu releases][codenames] including older LTS releases 14.04 (Trusty Tahir) and 16.04 (Xenias Xerus) and the most interim release 19.10 (Eoan Ermine) if there is a demand. I don't personally use any of these and –as the LTS versions are now quite old (with the two most recent LTS series supported) and the interim release is immanently being marked as end-of-life in just two months– I figured there might not be any need to go to the trouble. If you have a use case for any of these please feel free to request builds in a [new issue report][newissue].

  [v0.10.2]: /2020/02/sile-0-10-2-is-released
  [v0.10.4]: /2020/04/sile-0-10-4-is-released
  [PPA]: https://launchpad.net/~sile-typesetter/+archive/ubuntu/sile
  [codenames]: https://wiki.ubuntu.com/Releases
  [newissue]: https://github.com/sile-typesetter/sile/issue/new
