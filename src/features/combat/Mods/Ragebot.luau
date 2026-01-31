--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Dependencies (require)
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local PlayerUtils = require("../../../shared/PlayerUtils")
local TeamUtils = require("../../../shared/TeamUtils")
local State = require("../State")
local Helpers = require("../Utils/Helpers")

--// Constants
local ORBIT_RADIUS = 100000
local ORBIT_SPEED = 12
local TARGET_REFRESH_INTERVAL = 0.05
local TELEPORT_OFFSET = Vector3.new(0, 0, 2)
local MOUSE_SHOT_RELEASE_DELAY = 0.03

--// Types

--// Private state
local Ragebot = {}
Ragebot.__index = Ragebot

local _maid = nil :: any
local _signals = {}
local _state = {
	lastTargetRefresh = 0,
	lastFighterFetch = 0,
	cachedTarget = nil :: Player?,
	cachedTargetRoot = nil :: BasePart?,
	lastShotAt = 0,
	mouse1press = nil :: (() -> ())?,
	mouse1release = nil :: (() -> ())?,
	mouse1click = nil :: (() -> ())?,
}

--// Private helpers
local function _getLocalRoot(): BasePart?
	local localPlayer = PlayerUtils.getLocalPlayer()
	local character = localPlayer and localPlayer.Character
	return character and (character:FindFirstChild("HumanoidRootPart") :: BasePart?) or nil
end

local function _isRoundStarted(): boolean
	local localPlayer = PlayerUtils.getLocalPlayer()
	if not localPlayer then
		return false
	end
	if not TeamUtils.isInDuel(localPlayer) then
		return false
	end

	local duel = TeamUtils.getLocalDuel()
	if duel and duel.Get then
		local isOk, status = pcall(duel.Get, duel, "Status")
		if isOk and status ~= nil then
			return status == "RoundStarted"
		end
	end

	return true
end

local function _getBestTarget(localRoot: BasePart): (Player?, BasePart?)
	local localPlayer = PlayerUtils.getLocalPlayer()
	if not localPlayer then
		return nil, nil
	end
	if not TeamUtils.isInDuel(localPlayer) then
		return nil, nil
	end

	local bestPlayer: Player? = nil
	local bestRoot: BasePart? = nil
	local bestDist = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		if TeamUtils.isSameTeam(player, localPlayer) then
			continue
		end
		if not TeamUtils.isInSameDuel(localPlayer, player) then
			continue
		end

		local character = player.Character
		if not character then
			continue
		end
		local root = character:FindFirstChild("HumanoidRootPart") :: BasePart?
		local hum = character:FindFirstChildOfClass("Humanoid")
		if not root or not hum or hum.Health <= 0 then
			continue
		end

		local dist = (localRoot.Position - root.Position).Magnitude
		if dist < bestDist then
			bestDist = dist
			bestPlayer = player
			bestRoot = root
		end
	end

	return bestPlayer, bestRoot
end

local function _getLocalFighter(): any
	local now = os.clock()
	if now - _state.lastFighterFetch >= 0.25 then
		_state.lastFighterFetch = now
		Helpers.fetchFighterController(State.logger)
	end
	return State.fighterController and State.fighterController.LocalFighter
end

local function _isReloading(item: any): boolean
	if not item then
		return false
	end

	local isOk, value = pcall(function()
		if item.Get then
			return item:Get("IsReloading")
		end
		return nil
	end)
	if isOk and value ~= nil then
		return value == true
	end

	local reloadCooldown = (item :: any)._reload_cooldown
	if type(reloadCooldown) == "number" and reloadCooldown > tick() then
		return true
	end

	local isReloadingValue = (item :: any)._is_reloading or (item :: any).IsReloading
	if type(isReloadingValue) == "boolean" then
		return isReloadingValue
	end

	return false
end

local function _isGunItem(equipped: any): boolean
	if not equipped then
		return false
	end
	local info = equipped.Info
	if not info then
		return false
	end
	if info.Type == "Gun" then
		return true
	end
	if info.Class == "Primary" or info.Class == "Secondary" then
		return true
	end
	if info.ShootCooldown ~= nil or info.AmmoType ~= nil then
		return true
	end
	return false
end

local function _ensureGunEquipped(localFighter: any): any
	if not localFighter then
		return nil
	end

	local equipped = localFighter.EquippedItem
	if _isGunItem(equipped) then
		return equipped
	end

	return nil
end

local function _refreshInputFunctions()
	if _state.mouse1press or _state.mouse1click then
		return
	end
	_state.mouse1press = ExecutorUtils.getGlobal("mouse1press")
	_state.mouse1release = ExecutorUtils.getGlobal("mouse1release")
	_state.mouse1click = ExecutorUtils.getGlobal("mouse1click")
end

local function _tryMouseShot(equipped: any): boolean
	_refreshInputFunctions()

	if _state.mouse1click then
		_state.mouse1click()
		return true
	end

	if _state.mouse1press and _state.mouse1release then
		_state.mouse1press()
		local shouldRelease = equipped.Name ~= "Flamethrower"
		if shouldRelease then
			task.delay(MOUSE_SHOT_RELEASE_DELAY, function()
				local releaseFn = _state.mouse1release
				if releaseFn then
					releaseFn()
				end
			end)
		end
		return true
	end

	return false
end

local function _getShootCooldown(equipped: any): number
	local info = equipped and equipped.Info
	local baseCooldown = (info and info.ShootCooldown) or 0.1
	local multiplier = State.attackCooldownMultiplier
	if type(multiplier) == "number" and multiplier > 0 and multiplier < 100 then
		baseCooldown = baseCooldown * (multiplier / 100)
	end
	return math.max(baseCooldown, 0.02)
end

local function _equippedItemInput(localFighter: any, equipped: any, inputName: string)
	if localFighter and localFighter.Input then
		localFighter:Input(inputName)
		return
	end
	if equipped and equipped.Input then
		equipped:Input(inputName)
	end
end

local function _shoot(localFighter: any)
	local equipped = _ensureGunEquipped(localFighter)
	if not equipped or not equipped.Input then
		return
	end

	local now = os.clock()
	local cooldown = _getShootCooldown(equipped)
	if now - _state.lastShotAt < cooldown then
		return
	end
	_state.lastShotAt = now

	if _tryMouseShot(equipped) then
		return
	end

	_equippedItemInput(localFighter, equipped, "StartShooting")
	if equipped.Name ~= "Flamethrower" then
		task.delay(0.1, function()
			if localFighter.EquippedItem == equipped and equipped.Input then
				_equippedItemInput(localFighter, equipped, "FinishShooting")
			end
		end)
	end
end

local function _teleportToTarget(localRoot: BasePart, targetRoot: BasePart)
	localRoot.CFrame = targetRoot.CFrame * CFrame.new(TELEPORT_OFFSET)
end

local function _orbitTarget(localRoot: BasePart, targetRoot: BasePart)
	local angle = os.clock() * ORBIT_SPEED
	local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * ORBIT_RADIUS
	local position = targetRoot.Position + offset
	localRoot.CFrame = CFrame.new(position, targetRoot.Position)
end

local function _refreshTarget(localRoot: BasePart)
	local now = os.clock()
	if now - _state.lastTargetRefresh < TARGET_REFRESH_INTERVAL then
		return
	end
	_state.lastTargetRefresh = now
	_state.cachedTarget, _state.cachedTargetRoot = _getBestTarget(localRoot)
end

local function _connect()
	if not _maid then
		return
	end

	local connection = RunService.RenderStepped:Connect(function()
		if not State.isRagebotEnabled then
			return
		end
		if not _isRoundStarted() then
			return
		end

		if not State.isSilentAimEnabled then
			State.isSilentAimEnabled = true
		end
		if State.attackCooldownMultiplier > 1 then
			State.attackCooldownMultiplier = 1
		end

		local localRoot = _getLocalRoot()
		if not localRoot then
			return
		end

		local localFighter = _getLocalFighter()
		if not localFighter then
			return
		end

		_refreshTarget(localRoot)
		local targetRoot = _state.cachedTargetRoot
		if not targetRoot then
			return
		end

		local equipped = _ensureGunEquipped(localFighter)
		if equipped and _isReloading(equipped) then
			_orbitTarget(localRoot, targetRoot)
			return
		end

		_teleportToTarget(localRoot, targetRoot)
		if equipped then
			_shoot(localFighter)
		end
	end)
	_maid:GiveTask(connection)
end

--// Public API
function Ragebot.setup(maid: any): ()
	_maid = maid
	_connect()
end

return Ragebot
