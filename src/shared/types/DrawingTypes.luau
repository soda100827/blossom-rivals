--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type DrawingObject = {
	Remove: (self: DrawingObject) -> (),
}

export type DrawingLibrary = {
	new: (class: string) -> DrawingObject,
}

--// Private state
local DrawingTypes = {}
DrawingTypes.__index = DrawingTypes

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API

return DrawingTypes
