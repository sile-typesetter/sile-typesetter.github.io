#!/usr/bin/env lua

local datadir = os.getenv("SILE_PATH") or "/usr/share/sile"
local libdir = os.getenv("SILE_LIB_PATH") or "/usr/lib/sile"

-- BEGIN COPY FROM sile.in --
local executable = debug.getinfo(1, "S").source
local luaversion = _VERSION:match("%d+%.%d+")

local function prepend_and_dedup (segment, path)
  local escaped = segment:gsub('[%-%.%+%[%]%(%)%$%^%%%?%*]','%%%1') -- copied from pl.utils.escape() which we can't load yet
  local striped = path:gsub(("^%s"):format(escaped), ""):gsub((";%s"):format(escaped), "")
  return ("%s;%s"):format(segment, striped)
end

local function prependPath (path)
  package.path  = prepend_and_dedup(path .. "/?/init.lua", package.path)
  package.path  = prepend_and_dedup(path .. "/?.lua", package.path)
end

local function prependCPath (path)
  package.cpath = prepend_and_dedup(path .. "/?.so", package.cpath)
end

local function extendPaths (path, ours)
  prependCPath(path)
  prependPath(path)
  if ours then
    prependPath(path .. "/lua-libraries")
    prependCPath(path .. "/lua_modules/lib/lua/" .. luaversion)
    prependPath(path .. "/lua_modules/share/lua/" .. luaversion)
  else
    prependCPath(path .. "/sile")
    prependPath(path .. "/sile")
  end
end

-- Facilitate loading SILE classes & packages from system LuaRocks
-- Also weed out CWD relative paths, we add them in a different order later
local luapath = {}
local extpath = {}
for path in package.path:gmatch("[^;]+") do
  table.insert(extpath, tostring(path:gsub("%?", "sile/?")))
  table.insert(luapath, path)
end
package.path = table.concat(luapath, ";")

extendPaths(datadir, true)
extendPaths(libdir, true)

package.path = table.concat(extpath, ";") .. ";" .. package.path

local pathvar = os.getenv("SILE_PATH")
if pathvar then
  for path in string.gmatch(pathvar, "[^;]+") do
    if not path:match("^./") and path:len() >= 1 then
      extendPaths(path)
    end
  end
end

local cwd = executable:gsub("(.*)(/.*)", "%1")
if cwd:match("^@") then -- Consider "ours" for the sake of Nix Flake
  extendPaths(".", true)
else
  if cwd ~= "./" then extendPaths(cwd) end
  extendPaths(".")
end
-- END COPY FROM sile.in --

local SILE = require("core.sile")

SILE.outputFilename = _G.arg[1]

SILE.init()
SILE.use("inputters.base")

local plain = require("classes.plain")
local class = plain({ papersize = "a5" })

SILE.documentState.documentClass = class

SILE.call("font", { family = "Libertinus Serif", size = "24pt" })
SILE.typesetter:typeset("To Sherlock Holmes she is always the woman. I have seldom heard him mention her under any other name. In his eyes she eclipses and predominates the whole of her sex.")

class:finish()
