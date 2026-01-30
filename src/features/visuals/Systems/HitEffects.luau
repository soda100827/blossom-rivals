--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")

--// Dependencies (require)
local State = require("../State")
local HookUtils = require("../../../shared/HookUtils")
local combatHelpers = require("../../combat/Utils/Helpers")

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

	-- Full asset ID check
	if not soundId:find("rbxassetid://") and tonumber(soundId) then
		soundId = "rbxassetid://" .. soundId
	end

	task.spawn(function()
		local sound = Instance.new("Sound")
		sound.SoundId = soundId
		sound.Volume = 3 -- High volume as requested
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

	local isRunning = true
	if _maid then
		_maid:GiveTask(function()
			isRunning = false
		end)
	end

	task.spawn(function()
		if not isRunning then
			return
		end

		-- 1. Custom Hit Sound (Hooking ClientViewModel)
		-- Analyzing rivals_src: PlayHitmarkerSound is the central dispatcher for hit sounds.
		local viewModelModule = combatHelpers.getViewModelModule()
		if viewModelModule and viewModelModule.PlayHitmarkerSound then
			local oldPlayHitmarkerSound
			oldPlayHitmarkerSound = HookUtils.safeHook(viewModelModule, "PlayHitmarkerSound", function(self, ...)
				_playHitSound()
				-- We can skip the original sound if desired, but usually playing over it is safer.
				-- If the user wants ONLY the custom sound, we could theoretically block the original calls
				-- but the original calls use _CreateHitmarkerSound which is internal.
				return oldPlayHitmarkerSound(self, ...)
			end, nil, _maid)
		end

		-- 2. No Hurt Effect on Enemies (Hooking ClientItem: _ImpactMarker & _ImpactMarkerSlash)
		-- Analyzing rivals_src: _ImpactMarker creates the 3D blood/spark effects on the hit surface.
		local clientItemModule = combatHelpers.getClientItemModule()
		if clientItemModule then
			if clientItemModule._ImpactMarker then
				local oldImpactMarker
				oldImpactMarker = HookUtils.safeHook(clientItemModule, "_ImpactMarker", function(self, ...)
					if State.settings.isNoHurtEffectEnabled then
						return -- Block 3D blood/sparks/impact visuals on target
					end
					return oldImpactMarker(self, ...)
				end, nil, _maid)
			end

			if clientItemModule._ImpactMarkerSlash then
				local oldImpactMarkerSlash
				oldImpactMarkerSlash = HookUtils.safeHook(
					clientItemModule,
					"_ImpactMarkerSlash",
					function(self, ...)
						if State.settings.isNoHurtEffectEnabled then
							return -- Block melee blood visuals
						end
						return oldImpactMarkerSlash(self, ...)
					end,
					nil,
					_maid
				)
			end
		end

		-- 4. No Hurt Effect on Hitmarker UI (Hooking Hitmarker:DamageEffect)
		-- Analyzing rivals_src: DamageEffect changes Hitmarker color to red on headshots/kills.
		-- We want to force it to white (Color3.new(1,1,1)) if "No Hurt Effect" is on.
		-- Since Hitmarker UI might be local, we try to find it via GC or Registry if possible,
		-- but hooking the method in the module is more reliable.
		-- Hitmarker module is required by Mouse.lua.
		-- We'll try to find any module that has "DamageEffect" and looks like Hitmarker.
		-- Actually, it's easier to just hook the UI properties if we can find them, but
		-- let's try to hook the function if we can find its module.

		-- 3. Local Hurt Effect (Local red screen overlays)
		local hurtEffectConn = RunService.Heartbeat:Connect(function()
			if State.settings.isNoHurtEffectEnabled then
				local player = Players.LocalPlayer
				if player then
					local playerGui = player:FindFirstChild("PlayerGui")
					if playerGui then
						-- Known Rivals damage indicators/overlays
						local names = { "DamageOverlay", "HurtOverlay", "BloodOverlay", "PainOverlay", "FlashbangGui" }
						for _, name in ipairs(names) do
							local ui = playerGui:FindFirstChild(name, true)
							if ui and ui:IsA("GuiObject") then
								ui.Visible = false
							end
						end

						-- Also find the Hitmarker UI parts and force their color to white
						-- Based on Hitmarker.lua: Dot, TL, TR, BR, BL
						local mouseGui = playerGui:FindFirstChild("MouseGui", true)
							or playerGui:FindFirstChild("MainGui", true)
						if mouseGui then
							local hitmarker = mouseGui:FindFirstChild("Hitmarker", true)
							if hitmarker then
								for _, child in ipairs(hitmarker:GetChildren()) do
									if child:IsA("ImageLabel") then
										child.ImageColor3 = Color3.new(1, 1, 1) -- Force white
									end
								end
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
