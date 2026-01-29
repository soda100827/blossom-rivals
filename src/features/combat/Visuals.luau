--!strict

--// Services
local UserInputService = game:GetService("UserInputService")

--// Dependencies (require)
local State = require("./State")
local Constants = require("./Constants")
local Helpers = require("./Helpers")

--// Constants

--// Types

--// Private state
local Visuals = {}

--// Private helpers
local function _updateCircle(circleId: string, isEnabled: boolean, radius: number, color: Color3, transparency: number)
	local lib = Helpers.getDrawingLib()
	if not lib then
		return
	end

	local stateAny = State :: any
	local circle = stateAny[circleId]
	if isEnabled then
		if not circle then
			circle = lib.new("Circle")
			stateAny[circleId] = circle
		end

		local c = circle :: any
		c.Thickness = Constants.FOV_CIRCLE_THICKNESS
		c.NumSides = Constants.FOV_CIRCLE_NUM_SIDES
		c.Filled = false
		c.Color = color
		c.Transparency = math.clamp(transparency, 0, 1)

		local mouseLocation = UserInputService:GetMouseLocation()
		c.Position = mouseLocation
		c.Radius = radius
		c.Visible = true
	else
		local c = circle :: any
		if c then
			c.Visible = false
		end
	end
end

--// Public API
function Visuals.updateFovCircle()
	_updateCircle("fovCircle", State.isFovEnabled, State.fovRadius, State.fovColor, State.fovTransparency)
	_updateCircle(
		"silentAimFovCircle",
		State.isSilentAimFovEnabled,
		State.silentAimFovRadius,
		State.silentAimFovColor,
		State.silentAimFovTransparency
	)
end

return Visuals
