--!strict

--// Services

--// Dependencies (require)

--// Constants

--// Types
export type ExecutorUtils = {
	getGlobal: (name: string) -> any,
	getDrawingLib: () -> any,
}

--// Private state
local ExecutorUtils = {}
ExecutorUtils.__index = ExecutorUtils

local _maid = nil :: any
local _state = {}
local _signals = {}

--// Private helpers

--// Public API
function ExecutorUtils.getGlobal(name: string): any
	local getfenvAny = getfenv :: any
	local env = getfenvAny(0) :: any
	local genv = (env.getgenv and env.getgenv()) or env
	return genv[name] or env[name]
end

function ExecutorUtils.getDrawingLib(): any
	local getfenvAny = getfenv :: any
	local g = getfenvAny(0) :: any
	local lib = g.Drawing
	if not lib and g.getgenv then
		lib = g.getgenv().Drawing
	end
	if not lib then
		lib = rawget(_G, "Drawing")
	end
	return lib
end

return ExecutorUtils
