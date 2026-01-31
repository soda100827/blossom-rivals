--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Workspace = game:GetService("Workspace")

--// Dependencies (require)
local ExecutorUtils = require("../../../shared/ExecutorUtils")
local HookUtils = require("../../../shared/HookUtils")
local PlayerUtils = require("../../../shared/PlayerUtils")
local TeamUtils = require("../../../shared/TeamUtils")
local State = require("../State")
local Helpers = require("../Utils/Helpers")

--// Constants
local DEFAULT_ORBIT_RADIUS = 100000
local DEFAULT_ORBIT_SPEED = 12
local SWAP_WEAPON_COOLDOWN = 0.2
local TARGET_REFRESH_INTERVAL = 0.05
local DEFAULT_RAGEBOT_OFFSET = Vector3.zero
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
	lastWeaponSwapAt = 0,
	isSwapReloadActive = false,
	isEngaged = false,
	isInputHooked = false,
	isUseItemHooked = false,
	debugNextAt = 0,
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

local function _isTargetInvincible(targetRoot: BasePart?): boolean
	if not targetRoot then
		return false
	end
	local character = targetRoot.Parent
	if not character or not character:IsA("Model") then
		return false
	end
	local entity = character:FindFirstChild("Entity")
	if entity and entity.Get then
		local ok, inv = pcall(entity.Get, entity, "IsInvincible")
		if ok and inv ~= nil then
			if inv == true and State.logger then
				local now = os.clock()
				if now >= _state.debugNextAt then
					_state.debugNextAt = now + 1
					State.logger:info("[Ragebot Debug] Target invincible (Entity:Get)", character.Name)
				end
			end
			return inv == true
		end
	end
	local isInvincible = character:GetAttribute("IsInvincible")
	if type(isInvincible) == "boolean" then
		if isInvincible and State.logger then
			local now = os.clock()
			if now >= _state.debugNextAt then
				_state.debugNextAt = now + 1
				State.logger:info("[Ragebot Debug] Target invincible (Attribute)", character.Name)
			end
		end
		return isInvincible
	end
	return false
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
	local fighter = State.fighterController and State.fighterController.LocalFighter
	if fighter and fighter.IsAlive and not fighter:IsAlive() then
		return nil
	end
	return fighter
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

local function _getAmmo(item: any): number?
	if not item then
		return nil
	end
	local ok, value = pcall(function()
		if item.Get then
			return item:Get("Ammo")
		end
		return nil
	end)
	if ok and type(value) == "number" then
		return value
	end
	local ammoField = (item :: any).Ammo
	if type(ammoField) == "number" then
		return ammoField
	end
	return nil
end

local function _isOutOfAmmo(item: any): boolean
	local ammo = _getAmmo(item)
	if type(ammo) == "number" then
		return ammo <= 0
	end
	return false
end

local function _getItemDebugState(item: any): string
	if not item then
		return "item=nil"
	end

	local ammo = _getAmmo(item)
	local isReloading = _isReloading(item)
	local isEquipping = false
	local okEquipping, equippingValue = pcall(function()
		if item.IsEquipping then
			return item:IsEquipping()
		end
		return false
	end)
	if okEquipping then
		isEquipping = equippingValue == true
	end

	local shootCooldown = (item :: any)._shoot_cooldown
	local reloadCooldown = (item :: any)._reload_cooldown

	return string.format(
		"ammo=%s reload=%s equipping=%s shootCd=%s reloadCd=%s",
		tostring(ammo),
		tostring(isReloading),
		tostring(isEquipping),
		tostring(shootCooldown),
		tostring(reloadCooldown)
	)
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

local function _getDesiredWeaponSlot(): number
	if State.ragebotWeaponSlot == "Secondary" then
		return 2
	end
	return 1
end

local function _getItemBySlot(localFighter: any, slot: number): any
	local items = localFighter and localFighter.Items
	if type(items) == "table" then
		return items[slot]
	end
	return nil
end

local function _ensureDesiredWeapon(localFighter: any)
	if not localFighter or not localFighter.EquipItem then
		return
	end
	local desiredSlot = _getDesiredWeaponSlot()
	local equipped = localFighter.EquippedItem
	if equipped and _isGunItem(equipped) then
		local currentSlot = (equipped :: any).Slot
		if currentSlot == desiredSlot then
			return
		end
	end
	pcall(function()
		localFighter:EquipItem(desiredSlot)
	end)
end

local function _tryStartReload(item: any)
	if not item or not item.Input then
		return
	end
	if _isReloading(item) then
		return
	end
	pcall(function()
		item:Input("StartReloading")
	end)
end

local function _swapWeaponOnReload(localFighter: any)
	if not State.isRagebotSwapWeaponOnReload then
		return
	end
	local now = os.clock()
	if now - _state.lastWeaponSwapAt < SWAP_WEAPON_COOLDOWN then
		return
	end

	if not localFighter or not localFighter.EquipItem then
		return
	end

	local mainSlot = _getDesiredWeaponSlot()
	local offSlot = if mainSlot == 2 then 1 else 2
	local mainItem = _getItemBySlot(localFighter, mainSlot)
	local offItem = _getItemBySlot(localFighter, offSlot)
	if not mainItem then
		return
	end

	local equipped = localFighter.EquippedItem
	if _isOutOfAmmo(mainItem) then
		_tryStartReload(mainItem)
		if offItem and equipped ~= offItem then
			_state.lastWeaponSwapAt = now
			pcall(function()
				localFighter:EquipItem(offSlot)
			end)
		end
		_state.isSwapReloadActive = true
		return
	end

	if _state.isSwapReloadActive then
		if equipped ~= mainItem then
			_state.lastWeaponSwapAt = now
			pcall(function()
				localFighter:EquipItem(mainSlot)
			end)
		end
		_state.isSwapReloadActive = false
	end
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

local function _safeCallInput(obj: any, inputName: string): any
	if not obj or not obj.Input then
		return nil
	end

	-- Attempt to lower identity to bypass "require" checks in game modules for high-identity threads
	local set_identity = ExecutorUtils.getGlobal("setthreadidentity") or ExecutorUtils.getGlobal("set_thread_identity")
	local get_identity = ExecutorUtils.getGlobal("getthreadidentity") or ExecutorUtils.getGlobal("get_thread_identity")

	if set_identity and get_identity then
		local old = get_identity()
		set_identity(2)
		local success, result = pcall(function()
			return obj:Input(inputName)
		end)
		set_identity(old)
		if not success then
			if State.logger then
				State.logger:warn("[Ragebot] SafeInput failed:", result)
			end
			return nil
		end
		return result
	else
		return obj:Input(inputName)
	end
end

local function _equippedItemInput(localFighter: any, equipped: any, inputName: string)
	if equipped and equipped.Input then
		local wasEquipped = equipped.IsEquipped
		local isSpoofNeeded = not wasEquipped and type(inputName) == "string" and string.sub(inputName, 1, 5) == "Start"

		if isSpoofNeeded then
			equipped.IsEquipped = true
		end

		local ok = _safeCallInput(equipped, inputName)

		if isSpoofNeeded then
			equipped.IsEquipped = wasEquipped
		end
		if State.logger and State.isRagebotEnabled then
			local now = os.clock()
			if now >= _state.debugNextAt then
				_state.debugNextAt = now + 1
				State.logger:info(
					"[Ragebot Debug] EquippedItem:Input",
					inputName,
					ok == true,
					_getItemDebugState(equipped)
				)
			end
		end
		if ok == true then
			return true
		end
	end
	if localFighter and localFighter.Input then
		local ok = _safeCallInput(localFighter, inputName)
		if State.logger and State.isRagebotEnabled then
			local now = os.clock()
			if now >= _state.debugNextAt then
				_state.debugNextAt = now + 1
				State.logger:info("[Ragebot Debug] LocalFighter:Input", inputName, ok == true)
			end
		end
		return ok == true
	end
	return false
end

local function _forceShootReady(equipped: any)
	if not equipped then
		return
	end
	if _isReloading(equipped) then
		return
	end
	local ammo = _getAmmo(equipped)
	if type(ammo) == "number" and ammo <= 0 then
		return
	end

	if (equipped :: any)._shoot_cooldown ~= nil then
		(equipped :: any)._shoot_cooldown = 0
	end
	if (equipped :: any)._shoot_cooldown_no_ammo ~= nil then
		(equipped :: any)._shoot_cooldown_no_ammo = 0
	end
	if (equipped :: any)._is_input_queueing ~= nil then
		(equipped :: any)._is_input_queueing = false
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

	_forceShootReady(equipped)

	-- Apply Modifications (NoSpread, FastFire) locally
	local info = equipped.Info
	local savedSpread, savedAimML, savedQuick
	local savedShootCd, savedBurstCd

	if info then
		if State.isNoSpreadEnabled then
			savedSpread = info.ShootSpread
			savedAimML = info.AimSpreadMultiplier
			savedQuick = info.QuickShotSpread

			info.ShootSpread = 0
			info.AimSpreadMultiplier = 0
			if info.QuickShotSpread then
				info.QuickShotSpread = 0
			end
			State.forcingAim = true
		end

		if State.attackCooldownMultiplier < 100 then
			savedShootCd = info.ShootCooldown
			savedBurstCd = info.ShootBurstCooldown

			local mult = State.attackCooldownMultiplier / 100
			if savedShootCd then
				info.ShootCooldown = savedShootCd * mult
			end
			if savedBurstCd then
				info.ShootBurstCooldown = savedBurstCd * mult
			end
		end
	end

	-- Camera Spoof for 360 Hit
	local targetRoot = _state.cachedTargetRoot
	local currentCamera = Workspace.CurrentCamera
	local savedCFrame

	if targetRoot and currentCamera then
		savedCFrame = currentCamera.CFrame
		local aimPos = targetRoot.Position
		local myPos = currentCamera.CFrame.Position
		-- Ensure we don't lookAt identical position (creates NaN)
		if (aimPos - myPos).Magnitude > 0.1 then
			currentCamera.CFrame = CFrame.lookAt(myPos, aimPos)
		else
			-- If super close, just use target's rotation (to face where they face) or generic offset
			currentCamera.CFrame = targetRoot.CFrame
		end
	end

	local didShoot = _equippedItemInput(localFighter, equipped, "StartShooting")

	-- Restore Camera
	if savedCFrame and currentCamera then
		currentCamera.CFrame = savedCFrame
	end

	-- Restore Modifications
	if info then
		if State.isNoSpreadEnabled then
			info.ShootSpread = savedSpread
			info.AimSpreadMultiplier = savedAimML
			if savedQuick ~= nil then
				info.QuickShotSpread = savedQuick
			end
			State.forcingAim = false
		end

		if State.attackCooldownMultiplier < 100 then
			if savedShootCd then
				info.ShootCooldown = savedShootCd
			end
			if savedBurstCd then
				info.ShootBurstCooldown = savedBurstCd
			end
		end
	end

	if didShoot and equipped.Name ~= "Flamethrower" then
		task.delay(0.1, function()
			if localFighter.EquippedItem == equipped and equipped.Input then
				_equippedItemInput(localFighter, equipped, "FinishShooting")
			end
		end)
	end
end

local function _applyRagebotSilentAimOverride(isEnabled: boolean)
	if isEnabled then
		if State.ragebotSavedSilentAimFovRadius == nil then
			State.ragebotSavedSilentAimFovRadius = State.silentAimFovRadius
		end
		State.silentAimFovRadius = math.huge
	else
		if State.ragebotSavedSilentAimFovRadius ~= nil then
			State.silentAimFovRadius = State.ragebotSavedSilentAimFovRadius
			State.ragebotSavedSilentAimFovRadius = nil
		end
	end
end

local function _teleportToTarget(localRoot: BasePart, targetRoot: BasePart)
	local offset = State.ragebotOffset or DEFAULT_RAGEBOT_OFFSET
	localRoot.CFrame = targetRoot.CFrame * CFrame.new(offset)
end

local function _orbitTarget(localRoot: BasePart, targetRoot: BasePart)
	local orbitSpeed = State.ragebotOrbitSpeed or DEFAULT_ORBIT_SPEED
	local orbitRadius = State.ragebotOrbitRadius or DEFAULT_ORBIT_RADIUS
	local angle = os.clock() * orbitSpeed
	local offset = Vector3.new(math.cos(angle), 0, math.sin(angle)) * orbitRadius
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

	local connection = RunService.Heartbeat:Connect(function()
		if not State.isRagebotEnabled then
			_applyRagebotSilentAimOverride(false)
			if _state.isEngaged then
				_state.isEngaged = false
				if State.ragebotSavedSilentAimEnabled ~= nil then
					State.isSilentAimEnabled = State.ragebotSavedSilentAimEnabled
					State.ragebotSavedSilentAimEnabled = nil
				end
				if State.ragebotSavedAttackCooldownMultiplier ~= nil then
					State.attackCooldownMultiplier = State.ragebotSavedAttackCooldownMultiplier
					State.ragebotSavedAttackCooldownMultiplier = nil
				end
			end
			return
		end
		_applyRagebotSilentAimOverride(true)

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

		if not State.isRagebotSwapWeaponOnReload and not _state.isSwapReloadActive then
			_ensureDesiredWeapon(localFighter)
		end

		_refreshTarget(localRoot)
		local targetRoot = _state.cachedTargetRoot
		if not targetRoot then
			if _state.isEngaged then
				_state.isEngaged = false
				if State.ragebotSavedSilentAimEnabled ~= nil then
					State.isSilentAimEnabled = State.ragebotSavedSilentAimEnabled
					State.ragebotSavedSilentAimEnabled = nil
				end
				if State.ragebotSavedAttackCooldownMultiplier ~= nil then
					State.attackCooldownMultiplier = State.ragebotSavedAttackCooldownMultiplier
					State.ragebotSavedAttackCooldownMultiplier = nil
				end
			end
			return
		end
		if _isTargetInvincible(targetRoot) then
			return
		end

		if not _state.isEngaged then
			_state.isEngaged = true
			if State.ragebotSavedSilentAimEnabled == nil then
				State.ragebotSavedSilentAimEnabled = State.isSilentAimEnabled
			end
			if State.ragebotSavedAttackCooldownMultiplier == nil then
				State.ragebotSavedAttackCooldownMultiplier = State.attackCooldownMultiplier
			end
			State.isSilentAimEnabled = true
			State.attackCooldownMultiplier = 1
		end

		local equipped = _ensureGunEquipped(localFighter)
		_swapWeaponOnReload(localFighter)
		if equipped and _isReloading(equipped) then
			if State.isRagebotOrbitEnabled then
				_orbitTarget(localRoot, targetRoot)
			end
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
