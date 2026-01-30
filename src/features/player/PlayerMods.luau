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

		-- Spoof Device periodic sender
		task.spawn(function()
			local setControlsRemote = Helpers.getSetControlsRemote()
			while true do
				if State.isSpoofDeviceEnabled and State.spoofDevice ~= "None" and setControlsRemote then
					pcall(function()
						setControlsRemote:FireServer(State.spoofDevice)
					end)
				end
				task.wait(1)
			end
		end)

		local flashedMod = Helpers.getFlashedModule()
		if flashedMod then
			local oldAttemptToFlash
			oldAttemptToFlash = hookfunction(flashedMod.AttemptToFlash, function(self, ...)
				if not checkcaller() and State.isAntiFlashEnabled then
					return
				end
				return oldAttemptToFlash(self, ...)
			end)

			local oldFlash
			oldFlash = hookfunction(flashedMod.Flash, function(self, ...)
				if not checkcaller() and State.isAntiFlashEnabled then
					return
				end
				return oldFlash(self, ...)
			end)
		end

		-- Sound Spammer
		task.spawn(function()
			local mechanicsController = Helpers.getMechanicsController()
			while true do
				if State.isSoundSpammerEnabled and mechanicsController then
					pcall(function()
						mechanicsController:PlayMechanicsSound(State.soundSpammerType)
					end)
				end
				task.wait(0.1)
			end
		end)
	end)
end

return PlayerMods
