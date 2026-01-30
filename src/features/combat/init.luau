--!strict

--// Services
local RunService = game:GetService("RunService")

--// Dependencies (require)
local Maid = require("Packages/_Index/soda100827_maid@0.4.0/maid") :: any
local State = require("./State")
local Constants = require("./Constants")
local Helpers = require("./Helpers")
local Targeting = require("./Targeting")
local Aimbot = require("./Aimbot")
local Types = require("./Types")
local SilentAim = require("./SilentAim") :: { setup: () -> () }
local GunMods = require("./GunMods") :: { setup: () -> () }
local MeleeMods = require("./MeleeMods") :: { setup: () -> () }
local Visuals = require("./Visuals") :: Types.CombatVisuals

--// Constants

--// Types
type CombatFeature = Types.CombatFeature

--// Private state
local Combat = {}
Combat.__index = Combat

local _maid = nil :: any

--// Private helpers
local function _connect()
	_maid:DoCleaning()
	task.spawn(function()
		Helpers.fetchCameraController(State.logger)
	end)
	SilentAim.setup()
	GunMods.setup()
	MeleeMods.setup()

	RunService:BindToRenderStep(
		Constants.AIMBOT_RENDER_STEP_NAME,
		Enum.RenderPriority.Camera.Value + 1,
		function(deltaTime)
			Visuals.updateFovCircle()

			if State.isAimbotEnabled then
				local target = Targeting.resolveTarget()
				if target then
					local _isValid, _bestPart, _anyOnScreen, _shortestDist = Targeting.getTargetState(target)
					if _isValid and _bestPart then
						Helpers.applyInputLock(true)
						Aimbot.aimAt(target, _bestPart, deltaTime)
					else
						Helpers.applyInputLock(false)
					end
				else
					Helpers.applyInputLock(false)
				end
			else
				State.target = nil
				Helpers.applyInputLock(false)
			end

			if State.isSilentAimEnabled then
				Targeting.resolveSilentTarget()
			else
				State.silentTarget = nil
			end
		end
	)
	_maid:GiveTask(function()
		RunService:UnbindFromRenderStep(Constants.AIMBOT_RENDER_STEP_NAME)
	end)
end

local function _disconnect()
	if State.fovCircle then
		pcall(function()
			(State.fovCircle :: any):Remove()
		end)
		State.fovCircle = nil
	end
	if State.silentAimFovCircle then
		pcall(function()
			(State.silentAimFovCircle :: any):Remove()
		end)
		State.silentAimFovCircle = nil
	end
	State.target = nil
	State.silentTarget = nil
	State.targetLostAt = nil
	State.silentTargetLostAt = nil
	Helpers.applyInputLock(false)
	_maid:DoCleaning()
end

--// Public API
function Combat.init(self: CombatFeature, client: any): ()
	State.client = client
	State.logger = client.Logger
	_maid = Maid.new()
	_connect()
end

function Combat.cleanup(self: CombatFeature): ()
	State.isAimbotEnabled = false
	_disconnect()
end

function Combat.setAimbotEnabled(self: CombatFeature, isEnabled: boolean): ()
	if State.isAimbotEnabled == isEnabled then
		return
	end
	State.isAimbotEnabled = isEnabled
	if not isEnabled then
		State.target = nil
		State.targetLostAt = nil
		Helpers.applyInputLock(false)
	end
end

function Combat.setFovEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isFovEnabled = isEnabled
end

function Combat.setFovRadius(self: CombatFeature, radius: number): ()
	State.fovRadius = radius
end

function Combat.setFovColor(self: CombatFeature, color: Color3): ()
	State.fovColor = color
end

function Combat.setFovTransparency(self: CombatFeature, transparency: number): ()
	State.fovTransparency = math.clamp(transparency, 0, 1)
end

function Combat.setSmoothness(self: CombatFeature, smoothness: number): ()
	local wasMaxSmoothness = Helpers.isMaxSmoothness()
	State.smoothness = math.clamp(smoothness, 0, Constants.MAX_SMOOTHNESS)
	if wasMaxSmoothness and not Helpers.isMaxSmoothness() then
		Helpers.applyInputLock(false)
	end
end

function Combat.setWallCheckEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isWallCheckEnabled = isEnabled
end

function Combat.setSilentAimEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isSilentAimEnabled = isEnabled
	if not isEnabled then
		State.silentTarget = nil
		State.silentTargetLostAt = nil
	end
end

function Combat.setSilentAimFovEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isSilentAimFovEnabled = isEnabled
end

function Combat.setSilentAimFovRadius(self: CombatFeature, radius: number): ()
	State.silentAimFovRadius = radius
end

function Combat.setSilentAimFovColor(self: CombatFeature, color: Color3): ()
	State.silentAimFovColor = color
end

function Combat.setSilentAimFovTransparency(self: CombatFeature, transparency: number): ()
	State.silentAimFovTransparency = math.clamp(transparency, 0, 1)
end

function Combat.setSilentHitChance(self: CombatFeature, chance: number): ()
	State.silentHitChance = math.clamp(chance, 0, 100)
end

function Combat.setTargetPart(self: CombatFeature, part: string): ()
	State.targetPart = part
end

function Combat.setManipulationEnabled(self: CombatFeature, enabled: boolean): ()
	State.isManipulationEnabled = enabled
end

function Combat.setAntiKatanaEnabled(self: CombatFeature, enabled: boolean): ()
	State.isAntiKatanaEnabled = enabled
end

function Combat.setClosestPositionEnabled(self: CombatFeature, enabled: boolean): ()
	State.isClosestPositionEnabled = enabled
end

function Combat.setClosestPositionWhitelist(self: CombatFeature, whitelist: { string }): ()
	State.closestPositionWhitelist = whitelist
end

function Combat.setNoRecoilEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isNoRecoilEnabled = isEnabled
end

function Combat.setNoSpreadEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isNoSpreadEnabled = isEnabled
end

function Combat.setNoMuzzleFlashEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isNoMuzzleFlashEnabled = isEnabled
end

function Combat.setAttackCooldownMultiplier(self: CombatFeature, multiplier: number): ()
	State.attackCooldownMultiplier = multiplier
end

function Combat.setMeleeAttackCooldownEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isMeleeAttackCooldownEnabled = isEnabled
end

function Combat.setMeleeAttackCooldownMultiplier(self: CombatFeature, multiplier: number): ()
	State.meleeAttackCooldownMultiplier = multiplier
end

function Combat.setMeleeSkillCooldownEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isMeleeSkillCooldownEnabled = isEnabled
end

function Combat.setMeleeSkillCooldownMultiplier(self: CombatFeature, multiplier: number): ()
	State.meleeSkillCooldownMultiplier = multiplier
end

function Combat.setMeleeAuraEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isMeleeAuraEnabled = isEnabled
end

function Combat.setTeleportAuraEnabled(self: CombatFeature, isEnabled: boolean): ()
	State.isTeleportAuraEnabled = isEnabled
end

function Combat.setMeleeAuraRadius(self: CombatFeature, radius: number): ()
	State.meleeAuraRadius = radius
end

function Combat.setTeleportAuraRadius(self: CombatFeature, radius: number): ()
	State.teleportAuraRadius = radius
end

return Combat
