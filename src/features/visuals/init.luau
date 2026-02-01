--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local ExecutorUtils = require("../../shared/ExecutorUtils")
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local Helpers = require("./Utils/Helpers")
local State = require("./State")
local Types = require("./Types")
local Constants = require("./Constants")

--// Constants
local ESP_RENDER_INTERVAL = Constants.ESP_RENDER_INTERVAL

--// Types
type VisualsFeature = Types.VisualsFeature

--// Private state
local Visuals = {}
Visuals.__index = Visuals

local _maid = nil :: any
local _signals = {}
local _state = {
	lastRender = 0,
}

--// Private helpers
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

function Visuals.onHit(self: VisualsFeature, position: Vector3?): ()
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
