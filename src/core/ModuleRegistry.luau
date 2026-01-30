--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type Module = {
	init: ((self: Module, client: any) -> ())?,
	cleanup: ((self: Module) -> ())?,
	Init: ((self: Module, client: any) -> ())?,
	Cleanup: ((self: Module) -> ())?,
	[string]: unknown,
}

export type ModuleEntry = {
	name: string,
	loader: Module,
}

--// Private state
local ModuleRegistry = {}
ModuleRegistry.__index = ModuleRegistry

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function ModuleRegistry.getModules(): { ModuleEntry }
	return {
		{ name = "TeamUtils", loader = require("src/shared/TeamUtils") :: Module },
		{ name = "Visuals", loader = require("src/features/visuals/Init") :: Module },
		{ name = "Player", loader = require("src/features/player/Init") :: Module },
		{ name = "Combat", loader = require("src/features/combat/Init") :: Module },
		{ name = "Interface", loader = require("src/ui/Interface") :: Module },
	}
end

return ModuleRegistry
