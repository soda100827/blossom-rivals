--!strict

--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

--// Constants
local RAGE_HEIGHT = 7 -- Above target
local TARGET_RADIUS = 99999

--// Dependencies
local State = require(script.Parent.Parent.State)
local SilentAim = require(script.Parent.SilentAim)

local TeamUtils = require("../../../shared/TeamUtils")

--// Helper Variables
local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")
local Controllers = PlayerScripts:WaitForChild("Controllers")

--// Controller Access
local FighterControllerModule = require(Controllers:WaitForChild("FighterController"))

--// Private state
local Ragebot = {}
Ragebot.__index = Ragebot

--// Utilities

local function getLocalFighter()
	return FighterControllerModule.LocalFighter
end

local function getEquippedWeapon(fighter: any)
	if not fighter then
		return nil
	end

	-- Strategy 1: Search top-level items
	for _, v in pairs(fighter) do
		if type(v) == "table" and v.IsEquipped == true and v.ViewModel then -- ViewModel check ensures it's an Item
			return v
		end
	end

	-- Strategy 2: Check Inventory/Items tables
	if fighter.Inventory then
		for _, item in pairs(fighter.Inventory) do
			if item.IsEquipped then
				return item
			end
		end
	end

	if fighter.Items then
		for _, item in pairs(fighter.Items) do
			if item.IsEquipped then
				return item
			end
		end
	end

	return nil
end

local function findTarget(localFighter: any)
	local closest = nil
	local closestDist = TARGET_RADIUS

	local myRoot = localFighter.Entity and localFighter.Entity.RootPart
	if not myRoot then
		return nil
	end

	for _, fighter in pairs(FighterControllerModule.Objects) do
		if fighter == localFighter then
			continue
		end

		-- Check validity
		if not fighter.Entity or not fighter.Entity.RootPart or not fighter.Entity.Humanoid then
			continue
		end
		if fighter.Entity.Humanoid.Health <= 0 then
			continue
		end

		-- Check Team
		local fighterPlayer = fighter.Player
		if fighterPlayer then
			if TeamUtils.isSameTeam(LocalPlayer, fighterPlayer) then
				continue
			end
		end

		local dist = (myRoot.Position - fighter.Entity.RootPart.Position).Magnitude
		if dist < closestDist then
			closestDist = dist
			closest = fighter
		end
	end

	return closest
end

--// Public API
function Ragebot.setup(maid: any)
	-- Initialize Silent Aim Hooks
	SilentAim.setup(maid)

	-- Ragebot Loop
	maid:GiveTask(RunService.Heartbeat:Connect(function()
		Ragebot.update()
	end))
end

function Ragebot.update()
	local localFighter = getLocalFighter()
	if not localFighter or not localFighter.Entity or not localFighter.Entity.RootPart then
		return
	end

	-- Force Enable Silent Aim State for Ragebot
	State.isSilentAimEnabled = true
	State.silentHitChance = 100
	State.silentAimFovRadius = math.huge -- Ignore FOV limit

	local weapon = getEquippedWeapon(localFighter)
	local target = findTarget(localFighter)

	if target and target.Entity and target.Entity.RootPart then
		local targetRoot = target.Entity.RootPart
		local myRoot = localFighter.Entity.RootPart

		-- 1. Teleport Logic
		-- Position above target
		local approachCFrame = CFrame.new(targetRoot.Position + Vector3.new(0, RAGE_HEIGHT, 0))
		-- Use LookAt so character faces target (helps targeting logic)
		local lookAtCFrame = CFrame.lookAt(approachCFrame.Position, targetRoot.Position)

		myRoot.CFrame = lookAtCFrame
		myRoot.Velocity = Vector3.zero
		myRoot.AssemblyLinearVelocity = Vector3.zero

		-- Sync Camera to LookAt (Ensures 'OnScreen' check in Silent Aim passes)
		if Workspace.CurrentCamera then
			Workspace.CurrentCamera.CFrame = lookAtCFrame
		end

		-- 2. Shooting Logic
		if weapon then
			-- Bypass Cooldowns locally
			if weapon._shoot_cooldown then
				weapon._shoot_cooldown = 0
			end
			if weapon._shoot_cooldown_no_ammo then
				weapon._shoot_cooldown_no_ammo = 0
			end
			if weapon._burst_count then
				weapon._burst_count = 0
			end

			-- Trigger "StartShooting"
			-- SilentAim hooks (Raycast/EncodeCFrame) will handle the actual aiming correction
			weapon:Input("StartShooting")
		end
	end
end

return Ragebot
