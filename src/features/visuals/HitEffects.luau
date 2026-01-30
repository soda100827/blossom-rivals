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

	local sound = Instance.new("Sound")
	sound.SoundId = soundId
	sound.Volume = 0.5
	sound.Parent = SoundService
	sound:Play()

	task.delay(2, function()
		sound:Destroy()
	end)
end

--// Public API
function HitEffects.setup(maid: any)
	_maid = maid

	-- No Hurt Effect
	local hurtEffectConn = RunService.Heartbeat:Connect(function()
		if State.settings.isNoHurtEffectEnabled then
			local player = Players.LocalPlayer
			if player then
				local playerGui = player:FindFirstChild("PlayerGui")
				if playerGui then
					-- Blossom Rivals specific: DamageOverlay or HurtEffect
					local damageOverlay = playerGui:FindFirstChild("DamageOverlay", true)
					if damageOverlay and damageOverlay:IsA("GuiObject") then
						damageOverlay.Visible = false
					end
					local hurtOverlay = playerGui:FindFirstChild("HurtOverlay", true)
					if hurtOverlay and hurtOverlay:IsA("GuiObject") then
						hurtOverlay.Visible = false
					end
				end
			end
		end
	end)
	_maid:GiveTask(hurtEffectConn)

	-- Custom Hit Sound Hook
	task.spawn(function()
		local combatHelpers = require("../combat/Helpers")
		local gameplayUtility = combatHelpers.getGameplayUtility()
		if gameplayUtility then
			local oldHitMarker = gameplayUtility._HitMarker
			if oldHitMarker then
				gameplayUtility._HitMarker = function(...)
					_playHitSound()
					return oldHitMarker(...)
				end
			end
		end
	end)
end

return HitEffects
