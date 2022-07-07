+++
aliases = ["2016/05/snake-justification"]
title = "Snake Justification"
date = "2016-05-04"

[extra]
post_author = "Simon Cozens"
post_gravatar = "11cdaff4c6f9b290db40f69d3b20caf1"
+++

*(Note: This blog post was edited when the proof of concept example was moved from a package in an unreleased branch to this website’s example section.)*

The ever-excellent [xkcd][] has produced a table of full-width justification strategies:

![XKCD](https://imgs.xkcd.com/comics/full_width_justification.png)

Naturally, SILE can support snake-based justification.
Check out the code in the “Snake Justification” example on this site.
You can see the result in [PDF form here](/examples/snakes.pdf), and it looks like this:

![snake-justification](/examples/snakes.png)

Because SILE is an extremely flexible typesetting engine, this took less than 20 lines of Lua code to implement.

We have been doing lots of other SILE development too, but snakes are fun.

[xkcd]: https://xkcd.com/
