--!strict

-- Services

-- Dependencies (require)
local TeamUtils = require("src/shared/TeamUtils")
local Visuals = require("src/features/visuals/Init")
local Player = require("src/features/player/Init")
local Combat = require("src/features/combat/Init")
local Interface = require("src/ui/Interface")

-- Constants

-- Types
export type Module = {
  init: ((self: Module, client: unknown) -> ())?,
  Init: ((self: Module, client: unknown) -> ())?,
  Destroy: ((self: Module) -> ())?,
  [string]: unknown,
}

export type ModuleEntry = {
  name: string,
  loader: Module,
}

-- Private state
local ModuleRegistry = {}
ModuleRegistry.__index = ModuleRegistry

local _maid = nil :: unknown
local _state = {}
local _signals = {}

-- Private helpers

-- Public API
function ModuleRegistry.getModules(): { ModuleEntry }
  return {
    { name = "TeamUtils", loader = TeamUtils :: Module },
    { name = "Visuals", loader = Visuals :: Module },
    { name = "Player", loader = Player :: Module },
    { name = "Combat", loader = Combat :: Module },
    { name = "Interface", loader = Interface :: Module },
  }
end

return ModuleRegistry
