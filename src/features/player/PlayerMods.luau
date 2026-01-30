--!strict

--// Services

--// Dependencies (require)
local State = require("./State")
local Helpers = require("./Helpers")

--// Constants

--// Types

--// Private state
local PlayerMods = {}

--// Private helpers

--// Public API
function PlayerMods.setup()
	local hookfunction = Helpers.getGlobal("hookfunction") or Helpers.getGlobal("replaceclosure")
	local checkcaller = Helpers.getGlobal("checkcaller") or function()
		return false
	end

	if not hookfunction then
		State.logger:warn("hookfunction not found, Player Mods will not work.")
		return
	end

	task.spawn(function()
		local replicatedClassMod = Helpers.getReplicatedClassModule()
		if replicatedClassMod then
			local oldGet
			oldGet = hookfunction(replicatedClassMod.Get, function(self, key)
				if not checkcaller() then
					if key == "SlidingSpeedMax" and State.isSlideBoostEnabled then
						return 3 * State.slideBoostMultiplier
					end
				end
				return oldGet(self, key)
			end)
		end

		local controlsController = Helpers.getControlsController()
		if controlsController then
			local oldSetControls
			oldSetControls = hookfunction(controlsController.SetControls, function(self, device)
				if not checkcaller() and State.spoofDevice ~= "None" then
					device = State.spoofDevice
				end
				return oldSetControls(self, device)
			end)

			-- Periodically ensure CurrentControls is spoofed if active
			task.spawn(function()
				while true do
					if State.spoofDevice ~= "None" then
						if controlsController.CurrentControls ~= State.spoofDevice then
							controlsController.CurrentControls = State.spoofDevice
							if controlsController.ControlsChanged then
								controlsController.ControlsChanged:Fire()
							end
						end
					end
					task.wait(0.5)
				end
			end)
		end
	end)
end

return PlayerMods
