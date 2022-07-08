#!/usr/bin/env lua

local datadir = os.getenv("SILE_PATH") or "/usr/share/sile"
local libdir = os.getenv("SILE_LIB_PATH") or os.getenv("SILE_PATH") or "/usr/lib"

package.path = datadir .. "/?.lua;" ..
  datadir .. "/lua-libraries/?.lua;" ..
  datadir .. "/lua-libraries/?/init.lua;" ..
  package.path

package.cpath = libdir .. "/?.so;" ..
  libdir .. "/sile/?.so;" ..
  libdir .. "/sile/core/?.so;" ..
  package.cpath

SILE = require("core/sile")

SILE.version = "foo"
SILE.full_version = "foo_bar"
SILE.outputFilename = _G.arg[1]

SILE.init()

local class = SILE.require("plain", "classes")
class.options.papersize("a5")
SILE.documentState.documentClass = class;

local initialFrame = class:init()
SILE.typesetter:init(initialFrame)

SILE.call("font", { family = "Libertinus Serif", size = "14pt" })
SILE.typesetter:typeset("To Sherlock Holmes she is always the woman. I have seldom heard him mention her under any other name. In his eyes she eclipses and predominates the whole of her sex.")

class:finish()
