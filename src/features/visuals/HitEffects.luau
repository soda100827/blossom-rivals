--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

--// Dependencies (require)
local State = require("./State")

--// Constants

--// Private state
local HitEffects = {}
local _maid: any = nil

--// Private helpers
local function _playHitSound()
	if not State.settings.isCustomHitSoundEnabled then
		return
	end

	local soundId = State.settings.hitSoundId
	if not soundId or soundId == "" then
		return
	end

	-- Strip "rbxassetid://" if user only pasted numbers
	if not soundId:find("rbxassetid://") then
		soundId = "rbxassetid://" .. soundId
	end

	-- Run in separate task to avoid interfering with game process
	task.defer(function()
		local sound = Instance.new("Sound")
		sound.SoundId = soundId
		sound.Volume = 2 -- Loud
		sound.Parent = SoundService
		sound:Play()

		task.delay(2, function()
			sound:Destroy()
		end)
	end)
end

--// Public API
function HitEffects.setup(maid: any)
	_maid = maid

	task.spawn(function()
		local combatHelpers = require("../combat/Helpers")
		local gameplayUtility = combatHelpers.getGameplayUtility()
		local hookfunction = combatHelpers.getGlobal("hookfunction") or combatHelpers.getGlobal("replaceclosure")

		if gameplayUtility then
			-- 1. HitMarker (Usually the 2D crosshair indicator)
			if gameplayUtility._HitMarker then
				local oldHitMarker
				oldHitMarker = hookfunction(gameplayUtility._HitMarker, function(...)
					_playHitSound()

					-- No Hurt Effect (Target Visuals)
					-- Some games put the target effects inside _HitMarker call.
					-- If the user wants to remove the effect on target, we might need to block this.
					-- But usually _HitMarker is just for the local UI.
					return oldHitMarker(...)
				end)
			end

			-- 2. ImpactMarker (Usually the 3D effect on the enemy body - Blood/Sparks)
			if gameplayUtility._ImpactMarker then
				local oldImpactMarker
				oldImpactMarker = hookfunction(gameplayUtility._ImpactMarker, function(...)
					-- If No Hurt Effect is ON, we skip the 3D impact visual on the enemy
					if State.settings.isNoHurtEffectEnabled then
						return -- Skip sparks/blood on target
					end
					return oldImpactMarker(...)
				end)
			end
		end

		-- Hook SoundService directly as a fallback for hits
		-- This is high-frequency, so we check carefully
		local oldPlayLocalSound
		oldPlayLocalSound = hookfunction(SoundService.PlayLocalSound, function(self, sound)
			if sound and State.settings.isCustomHitSoundEnabled then
				-- Often hit sounds are named "Hit" or "Impact"
				local name = sound.Name:lower()
				if name:find("hit") or name:find("impact") or name:find("kill") then
					_playHitSound()
				end
			end
			return oldPlayLocalSound(self, sound)
		end)

		-- 3. No Hurt Effect (Local red screen overlays)
		local hurtEffectConn = RunService.Heartbeat:Connect(function()
			if State.settings.isNoHurtEffectEnabled then
				local player = Players.LocalPlayer
				if player then
					local playerGui = player:FindFirstChild("PlayerGui")
					if playerGui then
						-- Block various known damage overlay names
						local names = { "DamageOverlay", "HurtOverlay", "BloodOverlay", "PainOverlay" }
						for _, name in ipairs(names) do
							local ui = playerGui:FindFirstChild(name, true)
							if ui and ui:IsA("GuiObject") then
								ui.Visible = false
							end
						end
					end
				end
			end
		end)
		_maid:GiveTask(hurtEffectConn)
	end)
end

return HitEffects
