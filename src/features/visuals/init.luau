--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local ExecutorUtils = require("../../shared/ExecutorUtils")
local PlayerUtils = require("../../shared/PlayerUtils")
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local HookUtils = require("../../shared/HookUtils")
local Helpers = require("./Utils/Helpers")
local State = require("./State")
local Types = require("./Types")
local Constants = require("./Constants")

--// Constants
local ESP_RENDER_INTERVAL = Constants.ESP_RENDER_INTERVAL
local HIT_NOTIFY_COOLDOWN = 0.05
local KILL_NOTIFY_COOLDOWN = 0.1
local HIT_NOTIFY_OFFSET_Y = -40
local KILL_NOTIFY_OFFSET_Y = -20
local HIT_NOTIFY_SIZE = 22
local KILL_NOTIFY_SIZE = 24
local HIT_NOTIFY_COLOR = Color3.fromRGB(255, 255, 255)
local KILL_NOTIFY_COLOR = Color3.fromRGB(255, 80, 80)

--// Types
type VisualsFeature = Types.VisualsFeature

--// Private state
local Visuals = {}
Visuals.__index = Visuals

local _maid = nil :: any
local _signals = {}
local _state = {
	lastRender = 0,
	hitNotify = {
		drawing = nil :: any,
		expiresAt = 0,
		token = 0,
		lastAt = 0,
	},
	killNotify = {
		drawing = nil :: any,
		expiresAt = 0,
		token = 0,
		lastAt = 0,
	},
}

--// Private helpers
local function _getNotifyDrawing(store: { drawing: any, token: number, expiresAt: number, lastAt: number }): any
	local lib = ExecutorUtils.getDrawingLib()
	if not lib then
		return nil
	end
	local drawing = store.drawing
	if not drawing then
		drawing = lib.new("Text")
		drawing.Center = true
		drawing.Outline = true
		drawing.OutlineColor = Color3.new(0, 0, 0)
		drawing.Visible = false
		store.drawing = drawing
	end
	return drawing
end

local function _getNotifyPosition(offsetY: number): Vector2
	local camera = PlayerUtils.getCamera()
	local size = camera.ViewportSize
	return Vector2.new(size.X / 2, size.Y / 2 + offsetY)
end

local function _showNotify(
	store: { drawing: any, token: number, expiresAt: number, lastAt: number },
	text: string,
	color: Color3,
	lifetime: number,
	size: number,
	offsetY: number
): ()
	local drawing = _getNotifyDrawing(store)
	if not drawing then
		return
	end

	local now = os.clock()
	store.token += 1
	store.expiresAt = now + lifetime
	local token = store.token

	drawing.Text = text
	drawing.Color = color
	drawing.Size = size
	drawing.Position = _getNotifyPosition(offsetY)
	drawing.Visible = true

	task.delay(lifetime, function()
		if store.token ~= token then
			return
		end
		if store.expiresAt > os.clock() then
			return
		end
		drawing.Visible = false
	end)
end

local function _clearNotify(store: { drawing: any, token: number, expiresAt: number, lastAt: number }): ()
	local drawing = store.drawing
	if drawing then
		drawing:Remove()
		store.drawing = nil
	end
	store.token = 0
	store.expiresAt = 0
	store.lastAt = 0
end

local function _getDamageTargetName(damageInfo: any): string?
	if type(damageInfo) ~= "table" then
		return nil
	end

	local target = damageInfo.Target
		or damageInfo.target
		or damageInfo.Victim
		or damageInfo.victim
		or damageInfo.Player
		or damageInfo.player
		or damageInfo.Character
		or damageInfo.character

	if typeof(target) == "Instance" then
		if target:IsA("Player") then
			return target.DisplayName or target.Name
		end
		if target:IsA("Model") then
			local player = Players:GetPlayerFromCharacter(target)
			if player then
				return player.DisplayName or player.Name
			end
			return target.Name
		end
	end

	if type(target) == "string" then
		return target
	end

	return nil
end

local function _isKillDamageInfo(damageInfo: any): boolean
	if type(damageInfo) ~= "table" then
		return false
	end

	local flag = damageInfo.IsKill
		or damageInfo.isKill
		or damageInfo.Kill
		or damageInfo.kill
		or damageInfo.Killed
		or damageInfo.killed
		or damageInfo.IsFatal
		or damageInfo.isFatal
	if flag ~= nil then
		return flag == true
	end

	local health = damageInfo.Health or damageInfo.health or damageInfo.NewHealth or damageInfo.newHealth
	local damage = damageInfo.Damage or damageInfo.damage or damageInfo.Amount or damageInfo.amount
	if type(health) == "number" and type(damage) == "number" then
		return (health - damage) <= 0
	end

	local humanoid = damageInfo.Humanoid or damageInfo.humanoid or damageInfo.TargetHumanoid or damageInfo.targetHumanoid
	if typeof(humanoid) == "Instance" and humanoid:IsA("Humanoid") then
		return humanoid.Health <= 0
	end

	return false
end

local function _tryShowHitNotify(damageInfo: any)
	if not State.settings.shouldShowHitNotify then
		return
	end
	local now = os.clock()
	if now - _state.hitNotify.lastAt < HIT_NOTIFY_COOLDOWN then
		return
	end
	_state.hitNotify.lastAt = now
	local name = _getDamageTargetName(damageInfo)
	local text = name and ("Hit " .. name) or "Hit"
	_showNotify(_state.hitNotify, text, HIT_NOTIFY_COLOR, State.settings.hitNotifyLifetime, HIT_NOTIFY_SIZE, HIT_NOTIFY_OFFSET_Y)
end

local function _tryShowKillNotify(damageInfo: any)
	if not State.settings.shouldShowKillNotify then
		return
	end
	if not _isKillDamageInfo(damageInfo) then
		return
	end
	local now = os.clock()
	if now - _state.killNotify.lastAt < KILL_NOTIFY_COOLDOWN then
		return
	end
	_state.killNotify.lastAt = now
	local name = _getDamageTargetName(damageInfo)
	local text = name and ("Killed " .. name) or "Kill"
	_showNotify(
		_state.killNotify,
		text,
		KILL_NOTIFY_COLOR,
		State.settings.killNotifyLifetime,
		KILL_NOTIFY_SIZE,
		KILL_NOTIFY_OFFSET_Y
	)
end

local function _clearNotifies()
	_clearNotify(_state.hitNotify)
	_clearNotify(_state.killNotify)
end
local function _connect()
	_maid:DoCleaning()
	local removeConn = Players.PlayerRemoving:Connect(function(player)
		Helpers.removePlayer(player)
	end)
	_maid:GiveTask(removeConn)

	local renderConn = RunService.RenderStepped:Connect(function()
		local now = os.clock()
		if now - _state.lastRender < ESP_RENDER_INTERVAL then
			return
		end
		_state.lastRender = now
		Helpers.render()
	end)
	_maid:GiveTask(renderConn)

	-- Hit Detection Hook
	local viewModelMod = Helpers.getViewModelModule()
	if viewModelMod then
		local oldPlayHitmarkerSound
		oldPlayHitmarkerSound = HookUtils.safeHook(
			viewModelMod,
			"PlayHitmarkerSound",
			function(self, isHeadshot, pitchModifier, ...)
				_tryShowHitNotify(nil)
				if State.settings.shouldPlayHitSound then
					Visuals:onHit(nil)
					return
				end

				return oldPlayHitmarkerSound(self, isHeadshot, pitchModifier, ...)
			end,
			State.logger,
			_maid
		)
	end

	-- No Hitmarker Hook (Visuals)
	local hitmarkerMod = Helpers.getHitmarkerModule()
	if hitmarkerMod then
		local oldDamageEffect
		oldDamageEffect = HookUtils.safeHook(hitmarkerMod, "DamageEffect", function(self, damageInfo, ...)
			if State.settings.shouldHideHitmarker then
				if State.settings.shouldPlayHitSound then
					Visuals:onHit(damageInfo)
				end
				_tryShowHitNotify(damageInfo)
				_tryShowKillNotify(damageInfo)
				return -- Block visual effect
			end
			_tryShowHitNotify(damageInfo)
			_tryShowKillNotify(damageInfo)
			return oldDamageEffect(self, damageInfo, ...)
		end, State.logger, _maid)
	end
end

local function _enable()
	if not ExecutorUtils.getDrawingLib() then
		State.isEnabled = false
		return
	end
	_connect()
end

local function _disable()
	_maid:DoCleaning()
	Helpers.clearAll()
	_clearNotifies()
end

--// Public API
function Visuals.init(self: VisualsFeature, client: any): ()
	State.client = client
	State.logger = client.Logger
	_maid = Maid.new()
end

function Visuals.Destroy(self: VisualsFeature): ()
	State.isEnabled = false
	_disable()
end

function Visuals.toggle(self: VisualsFeature, isEnabled: boolean): ()
	if State.isEnabled == isEnabled then
		return
	end
	State.isEnabled = isEnabled
	if isEnabled then
		_enable()
	else
		_disable()
	end
end

function Visuals.setEspEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.isEspEnabled = isEnabled
	if not isEnabled then
		Helpers.clearAll()
	end
end

function Visuals.setShowNames(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowNames = shouldShow
end

function Visuals.setShowWeapon(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowWeapon = shouldShow
end

function Visuals.setShowDistance(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowDistance = shouldShow
end

function Visuals.setShowBoxes(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowBoxes = shouldShow
end

function Visuals.setShowSkeleton(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowSkeleton = shouldShow
end

function Visuals.setShowHealthbar(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowHealthbar = shouldShow
end

function Visuals.setShowHighlight(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowHighlight = shouldShow
	if not shouldShow then
		Helpers.clearHighlights()
	end
end

function Visuals.setShowTeammates(self: VisualsFeature, shouldShow: boolean): ()
	State.settings.shouldShowTeammates = shouldShow
end

function Visuals.setBoxColor(self: VisualsFeature, color: Color3): ()
	State.settings.boxColor = color
end

function Visuals.setTextColor(self: VisualsFeature, color: Color3): ()
	State.settings.textColor = color
end

function Visuals.setWeaponColor(self: VisualsFeature, color: Color3): ()
	State.settings.weaponColor = color
end

function Visuals.setDistanceColor(self: VisualsFeature, color: Color3): ()
	State.settings.distanceColor = color
end

function Visuals.setSkeletonColor(self: VisualsFeature, color: Color3): ()
	State.settings.skeletonColor = color
end

function Visuals.setHealthbarColor(self: VisualsFeature, color: Color3): ()
	State.settings.healthbarColor = color
end

function Visuals.setHealthbarOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.healthbarOutlineColor = color
end

function Visuals.setNameOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.nameOutlineColor = color
end

function Visuals.setWeaponOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.weaponOutlineColor = color
end

function Visuals.setDistanceOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.distanceOutlineColor = color
end

function Visuals.setBoxOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.boxOutlineColor = color
end

function Visuals.setSkeletonOutlineColor(self: VisualsFeature, color: Color3): ()
	State.settings.skeletonOutlineColor = color
end

function Visuals.setHighlightFill(self: VisualsFeature, color: Color3): ()
	State.settings.highlightFill = color
end

function Visuals.setHighlightOutline(self: VisualsFeature, color: Color3): ()
	State.settings.highlightOutline = color
end

function Visuals.setBoxThickness(self: VisualsFeature, value: number): ()
	State.settings.boxThickness = value
end

function Visuals.setSkeletonThickness(self: VisualsFeature, value: number): ()
	State.settings.skeletonThickness = value
end

function Visuals.setTextSize(self: VisualsFeature, value: number): ()
	State.settings.textSize = value
end

function Visuals.setOutline(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldOutline = isEnabled
end

function Visuals.setOverrideCheck(self: VisualsFeature, check: () -> boolean): ()
	State.overrideCheck = check
end

function Visuals.setHitSoundEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldPlayHitSound = isEnabled
end

function Visuals.setHitSound(self: VisualsFeature, sound: string): ()
	State.settings.hitSound = sound
end

function Visuals.setHitSoundVolume(self: VisualsFeature, volume: number): ()
	State.settings.hitSoundVolume = volume
end

function Visuals.setBulletTracersEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldShowBulletTracers = isEnabled
end

function Visuals.setHitNotifyEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldShowHitNotify = isEnabled
end

function Visuals.setKillNotifyEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldShowKillNotify = isEnabled
end

function Visuals.setHideHitmarkerEnabled(self: VisualsFeature, isEnabled: boolean): ()
	State.settings.shouldHideHitmarker = isEnabled
end

function Visuals.setKillNotifyLifetime(self: VisualsFeature, delay: number): ()
	State.settings.killNotifyLifetime = delay
end

function Visuals.setHitNotifyLifetime(self: VisualsFeature, delay: number): ()
	State.settings.hitNotifyLifetime = delay
end

function Visuals.setTracerLifetime(self: VisualsFeature, delay: number): ()
	State.settings.tracerLifetime = delay
end

function Visuals.setTracerThickness(self: VisualsFeature, thickness: number): ()
	State.settings.tracerThickness = thickness
end

function Visuals.onHit(self: VisualsFeature, _damageInfo: any): ()
	if State.settings.shouldPlayHitSound then
		local soundName = State.settings.hitSound
		local volume = State.settings.hitSoundVolume
		local soundId = Constants.SOUNDS[soundName]
		if soundId then
			local sound = Instance.new("Sound")
			sound.SoundId = soundId
			sound.Volume = volume
			sound.Parent = game:GetService("SoundService")
			sound:Play()
			game:GetService("Debris"):AddItem(sound, 3)
		end
	end
end

return Visuals
