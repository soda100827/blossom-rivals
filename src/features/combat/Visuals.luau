--!strict
local UserInputService = game:GetService("UserInputService")
local State = require("./State")
local Constants = require("./Constants")
local Helpers = require("./Helpers")

local Visuals = {}

function Visuals.updateFovCircle()
	local lib = Helpers.getDrawingLib()
	if not lib then
		return
	end

	local function updateCircle(circleId, isEnabled, radius, color, transparency)
		local circle = State[circleId]
		if isEnabled then
			if not circle then
				circle = lib.new("Circle")
				State[circleId] = circle
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

	updateCircle("fovCircle", State.isFovEnabled, State.fovRadius, State.fovColor, State.fovTransparency)
	updateCircle(
		"silentAimFovCircle",
		State.isSilentAimFovEnabled,
		State.silentAimFovRadius,
		State.silentAimFovColor,
		State.silentAimFovTransparency
	)
end

return Visuals
