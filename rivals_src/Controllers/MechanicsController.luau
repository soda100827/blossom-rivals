-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:18:18
-- Luau version 6, Types version 3
-- Time taken: 0.198424 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local RunService_upvr = game:GetService("RunService")
local Players_upvr = game:GetService("Players")
local CONSTANTS_upvr = require(ReplicatedStorage_upvr.Modules.CONSTANTS)
local InputLibrary_upvr = require(ReplicatedStorage_upvr.Modules.InputLibrary)
local Utility_upvr = require(ReplicatedStorage_upvr.Modules.Utility)
local UserInterfaceController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local PlayerDataController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local SpectateController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.SpectateController)
local ControlsController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local CameraController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.CameraController)
local tbl_8_upvr = {"Aim", "Sprint", "Crouch"}
local tbl_upvr = {
	Aim = false;
	Sprint = false;
	Crouch = false;
}
local module_upvr = {}
module_upvr.__index = module_upvr
local Signal_upvr = require(ReplicatedStorage_upvr.Modules.Signal)
function module_upvr._new() -- Line 44
	--[[ Upvalues[2]:
		[1]: module_upvr (readonly)
		[2]: Signal_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.StateChanged = Signal_upvr.new()
	setmetatable_result1.LocalFighter = nil
	setmetatable_result1.IsCrouching = false
	setmetatable_result1.IsSprinting = false
	setmetatable_result1.IsSliding = false
	setmetatable_result1.CameraLean = 0
	setmetatable_result1._internal_local_fighter_added = Signal_upvr.new()
	setmetatable_result1._controls_connections = {}
	setmetatable_result1._crouching_start_time = 0
	setmetatable_result1._crouching_release_time = 0
	setmetatable_result1._sprinting_start_time = 0
	setmetatable_result1._sprinting_release_time = 0
	setmetatable_result1._sliding_cooldown = 0
	setmetatable_result1._sliding_start_time = 0
	setmetatable_result1._sliding_release_time = 0
	setmetatable_result1._sliding_velocity = nil
	setmetatable_result1._sliding_last_floor = nil
	setmetatable_result1._sliding_last_floor_physical_properties = nil
	setmetatable_result1._update_slide_direction = nil
	setmetatable_result1._is_input_spamming = {}
	setmetatable_result1._mobile_input_down = {}
	setmetatable_result1._quick_attack_down_starts = {}
	setmetatable_result1._is_leaning_right = false
	setmetatable_result1._is_leaning_left = false
	setmetatable_result1._original_jump_power = nil
	setmetatable_result1._jump_hash = 0
	setmetatable_result1._double_jumps_used = {}
	setmetatable_result1._auto_shoot_connection = nil
	setmetatable_result1._scroll_delta = 0.5
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local GamepadService_upvr = game:GetService("GamepadService")
local GuiService_upvr = game:GetService("GuiService")
function module_upvr.AreInputsDisabled(arg1) -- Line 88
	--[[ Upvalues[5]:
		[1]: GamepadService_upvr (readonly)
		[2]: GuiService_upvr (readonly)
		[3]: ControlsController_upvr (readonly)
		[4]: Players_upvr (readonly)
		[5]: SpectateController_upvr (readonly)
	]]
	if GamepadService_upvr.GamepadCursorEnabled or GuiService_upvr.SelectedObject then
		return true
	end
	if arg1.LocalFighter and arg1.LocalFighter:Get("IsHiddenByCutscene") then
		return true
	end
	if ControlsController_upvr.CurrentControls == "Gamepad" and (require(Players_upvr.LocalPlayer.PlayerScripts.Modules.UserInterface.Pages).PageSystem.CurrentPage or require(Players_upvr.LocalPlayer.PlayerScripts.Modules.UserInterface.Equipment).IsOpen or SpectateController_upvr.CurrentDuelSubject and SpectateController_upvr.CurrentDuelSubject.DuelInterface.Voting:IsOpen()) then
		return true
	end
	return false
end
function module_upvr.IsAlive(arg1) -- Line 109
	local LocalFighter_6 = arg1.LocalFighter
	if LocalFighter_6 then
		LocalFighter_6 = arg1.LocalFighter:IsAlive()
	end
	return LocalFighter_6
end
function module_upvr.IsFrozen(arg1) -- Line 113
	local LocalFighter_5 = arg1.LocalFighter
	if LocalFighter_5 then
		LocalFighter_5 = arg1.LocalFighter.Entity
		if LocalFighter_5 then
			LocalFighter_5 = arg1.LocalFighter.Entity:Get("IsFrozen")
		end
	end
	return LocalFighter_5
end
function module_upvr.IsInputDown(arg1, arg2) -- Line 118
	--[[ Upvalues[3]:
		[1]: CameraController_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
		[3]: InputLibrary_upvr (readonly)
	]]
	local var22
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var22[1] = Enum.UserInputType.MouseButton2
		var22 = {}
		return var22
	end
	if CameraController_upvr:GetPublicState() ~= CameraController_upvr.CameraState.States.ThirdPersonUnlockedMouse or not INLINED() then
		var22 = nil
	end
	if ControlsController_upvr.CurrentControls == "Touch" then
		return arg1:IsMobileInputDown(arg2)
	end
	return InputLibrary_upvr:IsInputDown(arg2, var22)
end
function module_upvr.IsMobileInputDown(arg1, arg2) -- Line 125
	return arg1._mobile_input_down[arg2]
end
function module_upvr.GetTimeSince(arg1, arg2, arg3) -- Line 130
	return tick() - arg1['_'..string.lower(arg2)..'_'..string.lower(arg3).."_time"]
end
function module_upvr.SetCameraLean(arg1, arg2) -- Line 135
	arg1.CameraLean = arg2
	arg1.LocalFighter.LocalCameraLean = arg1.CameraLean
	arg1:_UpdateServerState("CameraLean", arg1.CameraLean)
end
function module_upvr.SetCrouching(arg1, arg2) -- Line 142
	--[[ Upvalues[1]:
		[1]: ControlsController_upvr (readonly)
	]]
	if not arg2 then
		ControlsController_upvr:ToggleInput("Crouch", false)
	end
	if arg2 == arg1.IsCrouching then
	else
		arg1.IsCrouching = arg2
		local LocalFighter = arg1.LocalFighter
		LocalFighter.IsCrouchingLocally = arg1.IsCrouching
		if arg1.IsCrouching then
			LocalFighter = "_crouching_start_time"
		else
			LocalFighter = "_crouching_release_time"
		end
		arg1[LocalFighter] = tick()
		arg1:_UpdateServerState("IsCrouching", arg1.IsCrouching)
		arg1.StateChanged:Fire("IsCrouching")
		arg1:_UpdateWalkSpeed()
		if arg1.IsCrouching then
			arg1:SetSprinting(false)
			arg1.LocalFighter.Entity.RootPart.Velocity = Vector3.new(arg1.LocalFighter.Entity.RootPart.Velocity.X, math.min(0, arg1.LocalFighter.Entity.RootPart.Velocity.Y), arg1.LocalFighter.Entity.RootPart.Velocity.Z)
		end
	end
end
function module_upvr.SetSprinting(arg1, arg2) -- Line 166
	local var24
	if arg2 == var24 then
	else
		local function INLINED_2() -- Internal function, doesn't exist in bytecode
			var24 = arg2
			return var24
		end
		if not arg1.LocalFighter or not arg1.LocalFighter:CanSprint() or not INLINED_2() then
			var24 = false
		end
		arg1.IsSprinting = var24
		var24 = arg1.LocalFighter
		var24.IsSprintingLocally = arg1.IsSprinting
		if arg1.IsSprinting then
			var24 = "_sprinting_start_time"
		else
			var24 = "_sprinting_release_time"
		end
		arg1[var24] = tick()
		var24 = arg1:_UpdateServerState
		var24("IsSprinting", arg1.IsSprinting)
		var24 = arg1.StateChanged:Fire
		var24("IsSprinting")
		var24 = arg1:_UpdateWalkSpeed
		var24()
		var24 = arg1.IsSprinting
		if var24 then
			var24 = arg1:SetCrouching
			var24(false)
		end
	end
end
function module_upvr.PlayMechanicsSound(arg1, ...) -- Line 184
	--[[ Upvalues[1]:
		[1]: ReplicatedStorage_upvr (readonly)
	]]
	if not arg1.LocalFighter then return end
	ReplicatedStorage_upvr.Remotes.Replication.Fighter.PlayMechanicsSound:FireServer(...)
	return arg1.LocalFighter:PlayMechanicsSound(...)
end
function module_upvr.StopSliding(arg1, arg2) -- Line 194
	--[[ Upvalues[1]:
		[1]: CONSTANTS_upvr (readonly)
	]]
	if not arg1.IsSliding then
	else
		if arg1._sliding_last_floor then
			arg1._sliding_last_floor.CustomPhysicalProperties = arg1._sliding_last_floor_physical_properties
			arg1._sliding_last_floor = nil
			arg1._sliding_last_floor_physical_properties = nil
		end
		if arg1._sliding_velocity then
			arg1._sliding_velocity:Destroy()
			arg1._sliding_velocity = nil
		end
		arg1._sliding_cooldown = tick() + 0.25
		arg1._update_slide_direction = nil
		arg1.IsSliding = false
		arg1.LocalFighter.IsSlidingLocally = false
		arg1._sliding_release_time = tick()
		arg1:_UpdateServerState("IsSliding", false)
		arg1.StateChanged:Fire("IsSliding")
		arg1:_UpdateWalkSpeed()
		if arg1:IsAlive() then
			arg1.LocalFighter.Entity:StopSlidingAnimation()
			arg1.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
			if arg2 then
				arg1.LocalFighter.Entity:CustomKnockback(arg1.LocalFighter.Entity.RootPart.Velocity * 0.6 + Vector3.new(0, CONSTANTS_upvr.BASE_JUMPPOWER * 0.5, 0), 12, true)
			end
			if arg1:IsInputDown("Sprint") then
				arg1:SetSprinting(true)
			end
		end
	end
end
function module_upvr.Slide(arg1) -- Line 234
	--[[ Upvalues[2]:
		[1]: Utility_upvr (readonly)
		[2]: RunService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 78 start (CF ANALYSIS FAILED)
	if tick() < arg1._sliding_cooldown or not arg1:IsAlive() or arg1.LocalFighter:AreItemsLocked() or not arg1.LocalFighter:CanSlide() or arg1:IsFrozen() then
		-- KONSTANTERROR: [30] 21. Error Block 7 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [30] 21. Error Block 7 end (CF ANALYSIS FAILED)
	end
	arg1._sliding_cooldown = math.huge
	arg1.IsSliding = true
	arg1.LocalFighter.IsSlidingLocally = true
	arg1._sliding_start_time = tick()
	arg1:_UpdateServerState("IsSliding", true)
	arg1.StateChanged:Fire("IsSliding")
	arg1.LocalFighter.Entity.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
	arg1.LocalFighter.Entity.Humanoid.AutoRotate = false
	arg1.LocalFighter.Entity:CancelCustomKnockback()
	arg1:SetCrouching(false)
	arg1:SetSprinting(false)
	arg1:_UpdateWalkSpeed()
	arg1._sliding_velocity = Instance.new("BodyVelocity")
	arg1._sliding_velocity.Parent = arg1.LocalFighter.Entity.RootPart
	local var48_upvw
	local any_PlayMechanicsSound_result1 = arg1:PlayMechanicsSound("Slide")
	function arg1._update_slide_direction(arg1_3) -- Line 267
		--[[ Upvalues[2]:
			[1]: var48_upvw (read and write)
			[2]: arg1 (readonly)
		]]
		local var51 = arg1_3
		if not var51 then
			var51 = arg1.LocalFighter:GetMoveVector(true, true, arg1.LocalFighter.Entity.RootPart.CFrame.LookVector)
		end
		var48_upvw = var51
		task.spawn(arg1.LocalFighter.Entity.PlaySlidingAnimation, arg1.LocalFighter.Entity, var48_upvw)
	end
	arg1._update_slide_direction()
	while true do
		local var52
		if not arg1:IsAlive() then break end
		if not arg1.IsSliding then break end
		if tick() >= tick() + 1 then break end
		local any_GetFloor_result1 = arg1.LocalFighter:GetFloor()
		var52 = arg1.LocalFighter.Entity.RootPart.Position
		local Y = var52.Y
		if any_GetFloor_result1 then
			local var55
		elseif not var55 then
			var52 = tick()
		end
		var52 = arg1.LocalFighter.Entity.RootPart.Position.Y - 1
		if Y < var52 then
			var52 = tick()
			if any_PlayMechanicsSound_result1 then
				var52 = tick()
				if tick() + 0.25 < var52 then
					var52 = 0
					any_PlayMechanicsSound_result1.TimePosition = var52
					var52 = 0
					any_PlayMechanicsSound_result1.Volume = var52
				end
			end
			var52 = tick()
		else
			var52 = math.max(Y, Y)
		end
		if any_PlayMechanicsSound_result1 then
			var52 = any_PlayMechanicsSound_result1.Volume
			if var52 == 0 and any_GetFloor_result1 then
				var52 = 0
				any_PlayMechanicsSound_result1.TimePosition = var52
				var52 = 0.375
				any_PlayMechanicsSound_result1.Volume = var52
			end
		end
		local function INLINED_4() -- Internal function, doesn't exist in bytecode
			var52 = arg1.LocalFighter.Entity.RootPart.CFrame.LookVector
			return var52
		end
		if var48_upvw.Magnitude > 0.01 or not INLINED_4() then
			var52 = var48_upvw.Unit
		end
		if any_GetFloor_result1 ~= arg1._sliding_last_floor then
			if arg1._sliding_last_floor then
				arg1._sliding_last_floor.CustomPhysicalProperties = arg1._sliding_last_floor_physical_properties
				arg1._sliding_last_floor = nil
				arg1._sliding_last_floor_physical_properties = nil
			end
			if any_GetFloor_result1 and not any_GetFloor_result1:IsA("Terrain") then
				arg1._sliding_last_floor = any_GetFloor_result1
				arg1._sliding_last_floor_physical_properties = arg1._sliding_last_floor.CurrentPhysicalProperties
			end
		end
		if any_GetFloor_result1 then
			local Position_2 = arg1.LocalFighter.Entity.RootPart.Position
			local var57 = Position_2 + var52 * 0.1
			local any_Raycast_result1 = Utility_upvr:Raycast(Position_2, Position_2 + Vector3.new(0, -1, 0), 999, {any_GetFloor_result1}, Enum.RaycastFilterType.Include)
			local any_Raycast_result1_4 = Utility_upvr:Raycast(var57, var57 + Vector3.new(0, -1, 0), 999, {any_GetFloor_result1}, Enum.RaycastFilterType.Include)
			if 0.7853981633974483 < Utility_upvr:AngleBetweenVectors((any_Raycast_result1_4.Position - any_Raycast_result1.Position).Unit, Vector3.new(-0, -1, -0)) then
				var52 = (any_Raycast_result1_4.Position - any_Raycast_result1.Position).Unit
				local Normal = any_Raycast_result1_4.Normal
				if not Normal then
					Normal = any_Raycast_result1.Normal
					if not Normal then
						Normal = Vector3.new(0, 1, 0)
					end
				end
				local var63 = Normal
			end
		end
		if var63.Magnitude < 0.5 then
			require(game:GetService("ReplicatedFirst"):WaitForChild("AnalyticsPipelineController"):WaitForChild("AnalyticsPipeline"))({-47, 9001}, {}, {}, {}, {-1, 83, 220}, {33}, {})
		end
		if not any_GetFloor_result1 or not ((tick() - var52) / 1) then
		end
		local var67 = arg1.LocalFighter:Get("SlidingSpeedMax") or 3
		local var68 = var52 * (var67 + (1 - var67) * 0) * arg1:_GetWalkSpeed(true)
		if not var52 then
			-- KONSTANTWARNING: GOTO [449] #302
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		arg1._sliding_velocity.Velocity = var68 + var63 * -workspace.Gravity * (tick() - var52) ^ 2
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if not var52 then
		else
		end
		arg1._sliding_velocity.MaxForce = Vector3.new(1, 0.1, 1) * 100000
		if 0.01 < var68.Magnitude then
			arg1.LocalFighter.Entity.RootPart.CFrame = arg1.LocalFighter.Entity.RootPart.CFrame:Lerp(CFrame.new(arg1.LocalFighter.Entity.RootPart.Position, arg1.LocalFighter.Entity.RootPart.Position + var68), 0.25)
		else
			arg1.LocalFighter.Entity.RootPart.CFrame = CFrame.new(arg1.LocalFighter.Entity.RootPart.Position) * arg1.LocalFighter.Entity.RootPart.CFrame.Rotation
		end
		RunService_upvr.RenderStepped:Wait()
	end
	any_PlayMechanicsSound_result1:Destroy()
	if arg1.IsSliding then
		arg1:StopSliding()
	end
	-- KONSTANTERROR: [3] 3. Error Block 78 end (CF ANALYSIS FAILED)
end
function module_upvr.Jump(arg1, arg2, arg3, arg4) -- Line 378
	local var69_upvr
	local function INLINED_5() -- Internal function, doesn't exist in bytecode
		var69_upvr = arg1:IsFrozen()
		return var69_upvr
	end
	local function INLINED_6() -- Internal function, doesn't exist in bytecode
		var69_upvr = arg1.LocalFighter.Entity.IsAirborneLocally
		return var69_upvr
	end
	if not var69_upvr or INLINED_5() or not arg4 and INLINED_6() then
	else
		var69_upvr = arg1._original_jump_power
		if not var69_upvr then
			var69_upvr = arg1.LocalFighter.Entity.Humanoid.JumpPower
		end
		arg1._original_jump_power = var69_upvr
		var69_upvr = arg1._jump_hash
		var69_upvr += 1
		arg1._jump_hash = var69_upvr
		var69_upvr = arg1._jump_hash
		local var70 = arg2
		if not var70 then
			var70 = arg1._original_jump_power
		end
		arg1.LocalFighter.Entity.Humanoid.JumpPower = var70 * (arg3 or 1)
		arg1.LocalFighter.Entity.Humanoid.Jump = true
		if arg2 or arg3 then
			task.defer(function() -- Line 391
				--[[ Upvalues[2]:
					[1]: var69_upvr (readonly)
					[2]: arg1 (readonly)
				]]
				if var69_upvr ~= arg1._jump_hash or not arg1:IsAlive() then
				else
					arg1.LocalFighter.Entity.Humanoid.JumpPower = arg1._original_jump_power
					arg1._original_jump_power = nil
				end
			end)
		end
	end
end
function module_upvr.DoubleJump(arg1) -- Line 402
	if not arg1:IsAlive() or arg1:IsFrozen() then
	else
		arg1.LocalFighter.Entity.RootPart.Velocity = arg1.LocalFighter:GetMoveVector(true, true) * arg1.LocalFighter.Entity.Humanoid.WalkSpeed * 1 + Vector3.new(0, arg1.LocalFighter.Entity.Humanoid.JumpPower * 1.1, 0)
		arg1.LocalFighter.Entity:InstantlyRedirectCustomKnockback()
		arg1:PlayMechanicsSound("DoubleJump")
	end
end
function module_upvr.JumpRequest(arg1, ...) -- Line 415
	arg1:Jump(...)
end
function module_upvr.DoubleJumpRequest(arg1) -- Line 419
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var74
	if var74 then
		var74 = arg1.LocalFighter.EquippedItem
		if var74 then
			var74 = arg1.LocalFighter.EquippedItem:Get("ObjectID")
		end
	end
	if arg1.LocalFighter then
		if arg1.LocalFighter.EquippedItem then
			if not arg1.LocalFighter:Get("DisableDoubleJumping") then
				local MaxDoubleJumps = arg1.LocalFighter.EquippedItem.Info.MaxDoubleJumps
			end
		end
	end
	if var74 and MaxDoubleJumps and (arg1._double_jumps_used[var74] or 0) < (MaxDoubleJumps or 0) and not arg1.LocalFighter:IsGrounded() then
		arg1._double_jumps_used[var74] = (arg1._double_jumps_used[var74] or 0) + 1
		arg1:DoubleJump()
	end
end
function module_upvr.HighJump(arg1) -- Line 429
	if not arg1:IsAlive() then
	else
		arg1:StopSliding(true)
		arg1:_SpamJumpRequests(nil, 1.25, true)
	end
end
function module_upvr.EquippedItemInput(arg1, ...) -- Line 438
	if not arg1.LocalFighter then
	else
		arg1.LocalFighter:Input(...)
	end
end
local EmoteController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.EmoteController)
function module_upvr.SimulateInputBegan(arg1, arg2, arg3) -- Line 447
	--[[ Upvalues[10]:
		[1]: tbl_8_upvr (readonly)
		[2]: InputLibrary_upvr (readonly)
		[3]: ControlsController_upvr (readonly)
		[4]: UserInterfaceController_upvr (readonly)
		[5]: CameraController_upvr (readonly)
		[6]: SpectateController_upvr (readonly)
		[7]: PlayerDataController_upvr (readonly)
		[8]: EmoteController_upvr (readonly)
		[9]: CONSTANTS_upvr (readonly)
		[10]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 109 start (CF ANALYSIS FAILED)
	if arg1:AreInputsDisabled() then return end
	for i, v in pairs(tbl_8_upvr) do
		if InputLibrary_upvr:InputIs(arg2, v) and ControlsController_upvr:IsToggled(v) then
			ControlsController_upvr:ToggleInput(v, false)
			return arg1:SimulateInputEnded(arg2, arg3)
		end
		if InputLibrary_upvr:InputIs(arg2, v) and arg1:_IsToggleInput(v) then
			ControlsController_upvr:ToggleInput(v, true)
		end
	end
	-- KONSTANTERROR: [0] 1. Error Block 109 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [56] 47. Error Block 12 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [56] 47. Error Block 12 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [62] 52. Error Block 13 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [62] 52. Error Block 13 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [67] 55. Error Block 121 start (CF ANALYSIS FAILED)
	v = CameraController_upvr
	i = v.CameraState
	if CameraController_upvr:GetPublicState() == i.States.ThirdPersonUnlockedMouse and arg2.UserInputType == Enum.UserInputType.MouseButton2 then
		-- KONSTANTERROR: [86] 66. Error Block 17 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [86] 66. Error Block 17 end (CF ANALYSIS FAILED)
	end
	i = "OpenPlayerList"
	-- KONSTANTERROR: [67] 55. Error Block 121 end (CF ANALYSIS FAILED)
end
function module_upvr.SimulateInputEnded(arg1, arg2) -- Line 567
	--[[ Upvalues[6]:
		[1]: CameraController_upvr (readonly)
		[2]: tbl_8_upvr (readonly)
		[3]: InputLibrary_upvr (readonly)
		[4]: ControlsController_upvr (readonly)
		[5]: SpectateController_upvr (readonly)
		[6]: UserInterfaceController_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 49 start (CF ANALYSIS FAILED)
	if CameraController_upvr:GetPublicState() == CameraController_upvr.CameraState.States.ThirdPersonUnlockedMouse and arg2.UserInputType == Enum.UserInputType.MouseButton2 then
		-- KONSTANTERROR: [22] 14. Error Block 4 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [22] 14. Error Block 4 end (CF ANALYSIS FAILED)
	end
	for _, v_2 in pairs(tbl_8_upvr) do
		if InputLibrary_upvr:InputIs(arg2, v_2) and arg1:_IsToggleInput(v_2) and ControlsController_upvr:IsToggled(v_2) then return end
	end
	-- KONSTANTERROR: [3] 3. Error Block 49 end (CF ANALYSIS FAILED)
end
function module_upvr.MobileInput(arg1, arg2, arg3) -- Line 626
	--[[ Upvalues[1]:
		[1]: InputLibrary_upvr (readonly)
	]]
	if arg3 and arg1:AreInputsDisabled() then
	else
		local var87 = InputLibrary_upvr.MobileButtons[arg2]
		if not var87 or not var87.InputName then
		end
		arg1._mobile_input_down[arg2] = arg3
		if arg3 then
		else
		end
		arg1.SimulateInputEnded(arg1, arg2, false)
	end
end
function module_upvr.WaitForLocalFighter(arg1) -- Line 637
	if not arg1.LocalFighter then
		arg1._internal_local_fighter_added:Wait()
	end
	return arg1.LocalFighter
end
local DebugState_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
function module_upvr._CanAutoShoot(arg1) -- Line 649
	--[[ Upvalues[2]:
		[1]: ControlsController_upvr (readonly)
		[2]: DebugState_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 17 start (CF ANALYSIS FAILED)
	if not arg1.LocalFighter.EquippedItem or arg1.LocalFighter:Get("IsHiddenByCutscene") then
		-- KONSTANTERROR: [15] 11. Error Block 15 start (CF ANALYSIS FAILED)
		do
			return false
		end
		-- KONSTANTERROR: [15] 11. Error Block 15 end (CF ANALYSIS FAILED)
	end
	local var91 = true
	if ControlsController_upvr.CurrentControls ~= "Touch" then
		var91 = true
		if ControlsController_upvr.CurrentControls ~= "Gamepad" then
			var91 = arg1.LocalFighter:Get("CheaterMode")
			if not var91 then
				var91 = DebugState_upvr:Get("AreHandicapsEnabled")
			end
		end
	end
	do
		return var91
	end
	-- KONSTANTERROR: [3] 3. Error Block 17 end (CF ANALYSIS FAILED)
end
local GameplayUtility_upvr = require(ReplicatedStorage_upvr.Modules.GameplayUtility)
function module_upvr._ToggleAutoShoot(arg1) -- Line 657
	--[[ Upvalues[5]:
		[1]: PlayerDataController_upvr (readonly)
		[2]: Players_upvr (readonly)
		[3]: Utility_upvr (readonly)
		[4]: GameplayUtility_upvr (readonly)
		[5]: RunService_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var93
	if arg1._auto_shoot_connection then
		arg1._auto_shoot_connection:Disconnect()
		arg1._auto_shoot_connection = nil
	end
	if not arg1:_CanAutoShoot() then
	else
		local any_Get_result1 = arg1.LocalFighter:Get("CheaterMode")
		if any_Get_result1 then
		else
		end
		if any_Get_result1 then
			local _
		else
		end
		if any_Get_result1 then
			var93 = nil
		else
			var93 = arg1.LocalFighter:Get("AutoShootRestriction")
		end
		if any_Get_result1 then
		else
		end
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		if PlayerDataController_upvr:Get("Settings Auto Shoot") == "Disabled" or var93 == "Disabled" then return end
		local var96_upvw = true
		local var97_upvw = 0
		local var98_upvw
		local function can_autoshoot_upvr() -- Line 681, Named "can_autoshoot"
			--[[ Upvalues[6]:
				[1]: arg1 (readonly)
				[2]: var97_upvw (read and write)
				[3]: var98_upvw (read and write)
				[4]: Players_upvr (copied, readonly)
				[5]: Utility_upvr (copied, readonly)
				[6]: GameplayUtility_upvr (copied, readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			local LocalFighter_3 = arg1.LocalFighter
			if LocalFighter_3 then
				LocalFighter_3 = arg1.LocalFighter.EquippedItem
				if LocalFighter_3 then
					LocalFighter_3 = arg1.LocalFighter:IsAlive()
				end
			end
			if not LocalFighter_3 then return end
			local any_GetAutoShootReactionTime_result1 = arg1.LocalFighter.EquippedItem:GetAutoShootReactionTime()
			local any_GetAutoShootReach_result1_2 = arg1.LocalFighter.EquippedItem:GetAutoShootReach()
			if not any_GetAutoShootReactionTime_result1 or not any_GetAutoShootReach_result1_2 then return end
			if var97_upvw < tick() then
				var97_upvw = tick() + 2
				var98_upvw = arg1.LocalFighter:GetRaycastWhitelist(true, {arg1.LocalFighter}, nil, true)
			end
			if Players_upvr.LocalPlayer.PlayerGui:FindFirstChild("FlashbangGui") then return end
			local any_Raycast_result1_2 = Utility_upvr:Raycast(workspace.CurrentCamera.CFrame.Position, workspace.CurrentCamera.CFrame.Position + workspace.CurrentCamera.CFrame.LookVector * any_GetAutoShootReach_result1_2, any_GetAutoShootReach_result1_2, var98_upvw, Enum.RaycastFilterType.Include)
			if not any_Raycast_result1_2.Instance then return end
			if Utility_upvr:AngleBetweenVectors(workspace.CurrentCamera.CFrame.LookVector, CFrame.new(arg1.LocalFighter.Entity.RootPart.Position, any_Raycast_result1_2.Instance.Position).LookVector) >= (math.pi/2) then
			else
			end
			if not true then return end
			local Instance = any_Raycast_result1_2.Instance
			if Instance then
				Instance = any_Raycast_result1_2.Instance.AssemblyRootPart
				if Instance then
					Instance = any_Raycast_result1_2.Instance.AssemblyRootPart.Parent
					if Instance then
						Instance = any_Raycast_result1_2.Instance.AssemblyRootPart.Parent:HasTag("Entity")
					end
				end
			end
			local var120 = Instance
			if var120 then
				var120 = GameplayUtility_upvr:GetEntityFromModel(any_Raycast_result1_2.Instance.AssemblyRootPart.Parent)
			end
			if not var120 or var120.AimAssistBlacklist or not var120:IsAlive() then return end
			if GameplayUtility_upvr:GetSmokeCloudBetweenPoints(workspace.CurrentCamera.CFrame.Position, any_Raycast_result1_2.Position) then return end
			return arg1.LocalFighter.EquippedItem, any_GetAutoShootReactionTime_result1
		end
		local function _(arg1_4) -- Line 735, Named "finish_shooting"
			--[[ Upvalues[2]:
				[1]: var96_upvw (read and write)
				[2]: arg1 (readonly)
			]]
			if not var96_upvw then
			else
				var96_upvw = false
				task.delay(arg1_4 or 0, arg1.EquippedItemInput, arg1, "FinishShooting")
			end
		end
		local function _(arg1_5, arg2) -- Line 744, Named "start_shooting"
			--[[ Upvalues[2]:
				[1]: var96_upvw (read and write)
				[2]: arg1 (readonly)
			]]
			var96_upvw = true
			arg1:EquippedItemInput("StartShooting")
			if arg2 then
				if not var96_upvw then return end
				var96_upvw = false
				task.delay(0.1, arg1.EquippedItemInput, arg1, "FinishShooting")
			end
		end
		local var121_upvw = false
		local function hold_upvr(arg1_6, arg2) -- Line 756, Named "hold"
			--[[ Upvalues[5]:
				[1]: var121_upvw (read and write)
				[2]: arg1 (readonly)
				[3]: can_autoshoot_upvr (readonly)
				[4]: RunService_upvr (copied, readonly)
				[5]: var96_upvw (read and write)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 19 start (CF ANALYSIS FAILED)
			if var121_upvw then return end
			var121_upvw = true
			-- KONSTANTERROR: [0] 1. Error Block 19 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [25] 21. Error Block 22 start (CF ANALYSIS FAILED)
			RunService_upvr.RenderStepped:Wait()
			-- KONSTANTERROR: [25] 21. Error Block 22 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [15] 13. Error Block 4 start (CF ANALYSIS FAILED)
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [31.5]
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [31.1449]
			-- KONSTANTERROR: [15] 13. Error Block 4 end (CF ANALYSIS FAILED)
		end
		local var123_upvr = var93 or PlayerDataController_upvr:Get("Settings Auto Shoot")
		local var124_upvr = PlayerDataController_upvr:Get("Settings Auto Shoot Reaction Time") / 1000
		arg1._auto_shoot_connection = RunService_upvr.RenderStepped:Connect(function() -- Line 785
			--[[ Upvalues[6]:
				[1]: can_autoshoot_upvr (readonly)
				[2]: var96_upvw (read and write)
				[3]: arg1 (readonly)
				[4]: var123_upvr (readonly)
				[5]: var124_upvr (readonly)
				[6]: hold_upvr (readonly)
			]]
			-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
			local can_autoshoot_result1, can_autoshoot_result2 = can_autoshoot_upvr()
			local var127
			if not can_autoshoot_result2 then
				var127 = var96_upvw
				if not var127 then
				else
					var127 = false
					var96_upvw = var127
					var127 = task.delay
					var127(0, arg1.EquippedItemInput, arg1, "FinishShooting")
				end
			end
			if var123_upvr == "Dynamic" then
				var127 = math.clamp(can_autoshoot_result2, 0.025, 0.125)
			else
				var127 = var124_upvr
			end
			if can_autoshoot_result1.Name == "Flamethrower" then
			else
			end
			task.defer(hold_upvr, var127, true)
		end)
	end
end
function module_upvr._IsToggleInput(arg1, arg2) -- Line 800
	--[[ Upvalues[3]:
		[1]: ControlsController_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: PlayerDataController_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var131
	if ControlsController_upvr.CurrentControls == "Touch" then
		var131 = tbl_upvr[arg2]
	else
		var131 = nil
	end
	if var131 ~= nil then
	else
	end
	if arg1.LocalFighter then
		if arg1.LocalFighter.EquippedItem then
		end
	end
	local any_Get_result1_5 = PlayerDataController_upvr:Get("Settings Toggle "..arg2)
	if any_Get_result1_5 then
		any_Get_result1_5 = true
		if arg2 == "Aim" then
			any_Get_result1_5 = arg1.LocalFighter.EquippedItem.ToggleAimEnabled
		end
	end
	return any_Get_result1_5
end
function module_upvr._AutoSprintEnabled(arg1) -- Line 808
	--[[ Upvalues[2]:
		[1]: PlayerDataController_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
	]]
	local any_Get_result1_4 = PlayerDataController_upvr:Get("Settings Auto Sprint")
	if not any_Get_result1_4 then
		if ControlsController_upvr.CurrentControls ~= "Touch" then
			any_Get_result1_4 = false
		else
			any_Get_result1_4 = true
		end
	end
	return any_Get_result1_4
end
local EnumLibrary_upvr = require(ReplicatedStorage_upvr.Modules.EnumLibrary)
function module_upvr._UpdateServerState(arg1, arg2, ...) -- Line 812
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: EnumLibrary_upvr (readonly)
	]]
	ReplicatedStorage_upvr.Remotes.Replication.Fighter.UpdateState:FireServer(EnumLibrary_upvr:ToEnum(arg2), ...)
end
local ItemLibrary_upvr = require(ReplicatedStorage_upvr.Modules.ItemLibrary)
function module_upvr._DontKeepQuickAttack(arg1, arg2) -- Line 817
	--[[ Upvalues[2]:
		[1]: ItemLibrary_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	local var136
	if not var136 then
	else
		if tick() - arg1._quick_attack_down_starts[arg2] >= ItemLibrary_upvr.KEEP_QUICK_ATTACK_HOLD_DURATION then
			var136 = false
		else
			var136 = true
		end
		if var136 then
			ReplicatedStorage_upvr.Remotes.Replication.Fighter.DontKeepQuickAttack:FireServer()
		end
	end
end
function module_upvr._QuickAttack(arg1, arg2) -- Line 830
	arg1._quick_attack_down_starts[arg2] = tick()
	arg1.LocalFighter:QuickAttack(arg2)
end
function module_upvr._InputSpam(arg1, arg2, arg3) -- Line 836
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 20 start (CF ANALYSIS FAILED)
	if arg1._is_input_spamming[arg2] then return end
	local var137 = true
	arg1._is_input_spamming[arg2] = var137
	-- KONSTANTERROR: [0] 1. Error Block 20 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [52] 37. Error Block 26 start (CF ANALYSIS FAILED)
	if var137 <= 0 then
		RunService_upvr.RenderStepped:Wait()
	else
		wait(var137)
	end
	-- KONSTANTERROR: [52] 37. Error Block 26 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [9] 8. Error Block 4 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	-- KONSTANTERROR: [9] 8. Error Block 4 end (CF ANALYSIS FAILED)
end
function module_upvr._SpamJumpRequests(arg1, ...) -- Line 867
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	while not arg1.IsSliding and arg1:IsInputDown("Jump") do
		arg1:JumpRequest(...)
		RunService_upvr.RenderStepped:Wait()
	end
end
local CosmeticLibrary_upvr = require(ReplicatedStorage_upvr.Modules.CosmeticLibrary)
function module_upvr._GetWalkSpeed(arg1, arg2) -- Line 875
	--[[ Upvalues[3]:
		[1]: UserInterfaceController_upvr (readonly)
		[2]: CosmeticLibrary_upvr (readonly)
		[3]: CONSTANTS_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	if arg1.LocalFighter then
		if arg1.LocalFighter.Entity and arg1.LocalFighter.Entity:Get("IsFrozen") then
			return 0
		end
	end
	local any_IsPageOpen_result1 = UserInterfaceController_upvr:IsPageOpen()
	if arg1.IsSprinting then
		if not arg1.LocalFighter.Entity:IsEmoting() then
			if not arg1.LocalFighter:Get("SprintingSpeedBoost") then
				-- KONSTANTWARNING: GOTO [51] #36
			end
			-- KONSTANTWARNING: GOTO [51] #36
		end
	end
	local var140
	local function INLINED_7() -- Internal function, doesn't exist in bytecode
		var140 = arg1.LocalFighter.Entity:GetBoost("Speed")
		return var140
	end
	if not arg1.LocalFighter or not arg1.LocalFighter.Entity or not INLINED_7() then
		var140 = 0
	end
	if any_IsPageOpen_result1 and any_IsPageOpen_result1.Name == "PickEmote" then
	else
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	if not arg1.LocalFighter.Entity:IsEmoting() or not CosmeticLibrary_upvr.Cosmetics[arg1.LocalFighter.Entity:GetCurrentEmote().Name].TraversalWalkSpeedMultiplier then
	end
	if not arg1.LocalFighter or not arg1.LocalFighter.EquippedItem or not arg1.LocalFighter.EquippedItem.Info.WalkSpeedMultiplier then
	end
	if arg1.IsCrouching then
		-- KONSTANTWARNING: GOTO [113] #79
	end
	local var141
	if arg1.IsSliding and not arg2 then
		var141 = 0
	else
		var141 = 1
	end
	return (CONSTANTS_upvr.BASE_WALKSPEED * ((1) + (0 + var140))) * (1 * 1 * 1 * 1 * var141)
end
function module_upvr._UpdateWalkSpeed(arg1) -- Line 898
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 7 start (CF ANALYSIS FAILED)
	if not arg1:IsAlive() then
		-- KONSTANTERROR: [7] 6. Error Block 3 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [7] 6. Error Block 3 end (CF ANALYSIS FAILED)
	end
	arg1.LocalFighter.Entity.Humanoid.WalkSpeed = arg1:_GetWalkSpeed()
	-- KONSTANTERROR: [3] 3. Error Block 7 end (CF ANALYSIS FAILED)
end
function module_upvr._UpdateCharacterRotation(arg1) -- Line 906
	--[[ Upvalues[1]:
		[1]: CameraController_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var142
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 28 start (CF ANALYSIS FAILED)
	if not arg1:IsAlive() then
		-- KONSTANTERROR: [7] 6. Error Block 3 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [7] 6. Error Block 3 end (CF ANALYSIS FAILED)
	end
	local any_GetPublicState_result1 = CameraController_upvr:GetPublicState()
	var142 = arg1.LocalFighter.Entity
	var142 = not any_GetPublicState_result1
	if not var142 then
		if any_GetPublicState_result1 ~= CameraController_upvr.CameraState.States.ThirdPersonUnlockedMouse then
			var142 = false
		else
			var142 = true
		end
	end
	var142.Humanoid.AutoRotate = var142
	local function INLINED_8() -- Internal function, doesn't exist in bytecode
		var142 = CameraController_upvr.CameraState.States
		return any_GetPublicState_result1 == var142.CustomFreecam
	end
	local function INLINED_9() -- Internal function, doesn't exist in bytecode
		var142 = CameraController_upvr.CameraState.States
		return any_GetPublicState_result1 == var142.ThirdPersonUnlockedMouse
	end
	if not any_GetPublicState_result1 or INLINED_8() or INLINED_9() and arg1.LocalFighter.Entity:IsEmoting() then
	else
		var142 = workspace.CurrentCamera.CFrame.LookVector
		local var144 = var142 * Vector3.new(1, 0, 1)
		var142 = var144.Magnitude
		if 0.01 < var142 then
			var142 = arg1.LocalFighter.Entity.RootPart
			var142.CFrame = CFrame.new(arg1.LocalFighter.Entity.RootPart.Position, arg1.LocalFighter.Entity.RootPart.Position + var144)
		end
		-- KONSTANTERROR: [3] 3. Error Block 28 end (CF ANALYSIS FAILED)
	end
end
function module_upvr._SetupControls(arg1) -- Line 927
	--[[ Upvalues[4]:
		[1]: RunService_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
		[3]: CameraController_upvr (readonly)
		[4]: PlayerDataController_upvr (readonly)
	]]
	for i_3, v_3 in pairs(arg1._controls_connections) do
		v_3:Disconnect()
	end
	arg1._controls_connections = {}
	if arg1:IsMobileInputDown("AutoSprint") then
		i_3 = "AutoSprint"
		v_3 = false
		task.spawn(arg1.MobileInput, arg1, i_3, v_3)
	end
	if not arg1.LocalFighter then
	else
		RunService_upvr.RenderStepped:Connect(function() -- Line 943
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:_UpdateCharacterRotation()
			arg1:_UpdateWalkSpeed()
			local var154
			if not arg1:_AutoSprintEnabled() then
			else
				var154 = arg1
				local LocalFighter_2 = var154.LocalFighter
				if LocalFighter_2 then
					var154 = arg1.IsCrouching
					LocalFighter_2 = not var154
					if LocalFighter_2 then
						var154 = arg1.IsSliding
						LocalFighter_2 = not var154
					end
				end
				var154 = LocalFighter_2
				if var154 then
					var154 = arg1.LocalFighter:GetMoveVector()
				end
				local var156 = var154
				if var156 then
					if 0.9 > var154.Magnitude then
						var156 = false
					else
						var156 = true
					end
				end
				if var156 and not arg1.IsSprinting then
					arg1:MobileInput("AutoSprint", true)
					return
				end
				if not var156 and arg1.IsSprinting then
					arg1:MobileInput("AutoSprint", false)
				end
			end
		end)
		if ControlsController_upvr.CurrentControls == "Touch" then return end
		table.insert(arg1._controls_connections, ControlsController_upvr.InputBegan:Connect(function(...) -- Line 967
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:SimulateInputBegan(...)
		end))
		table.insert(arg1._controls_connections, ControlsController_upvr.InputEnded:Connect(function(...) -- Line 971
			--[[ Upvalues[1]:
				[1]: arg1 (readonly)
			]]
			arg1:SimulateInputEnded(...)
		end))
		if ControlsController_upvr.CurrentControls == "MouseKeyboard" then
			table.insert(arg1._controls_connections, ControlsController_upvr.InputChanged:Connect(function(arg1_7, arg2) -- Line 977
				--[[ Upvalues[3]:
					[1]: CameraController_upvr (copied, readonly)
					[2]: arg1 (readonly)
					[3]: PlayerDataController_upvr (copied, readonly)
				]]
				if arg2 or CameraController_upvr:GetPublicState() == CameraController_upvr.CameraState.States.ThirdPersonUnlockedMouse or not arg1:IsAlive() or not PlayerDataController_upvr:Get("Settings Scroll Equip") then
				elseif arg1_7.UserInputType == Enum.UserInputType.MouseWheel then
					local var162 = math.floor(arg1._scroll_delta + arg1_7.Position.Z) - math.floor(arg1._scroll_delta)
					local var163 = arg1
					var163._scroll_delta += arg1_7.Position.Z
					if 0 < math.abs(var162) then
						arg1.LocalFighter:EquipIncrement(-math.sign(var162))
					end
				end
			end))
		end
	end
end
local ContextActionService_upvr = game:GetService("ContextActionService")
function module_upvr._DisableRobloxJumpButton(arg1) -- Line 995
	--[[ Upvalues[1]:
		[1]: ContextActionService_upvr (readonly)
	]]
	while true do
		local any_GetBoundActionInfo_result1 = ContextActionService_upvr:GetBoundActionInfo("jumpAction")
		if not any_GetBoundActionInfo_result1 then
			any_GetBoundActionInfo_result1 = {}
		end
		if next(any_GetBoundActionInfo_result1) then
			ContextActionService_upvr:UnbindAction("jumpAction")
		end
		wait(1)
	end
end
function module_upvr._HookFighter(arg1) -- Line 1007
	--[[ Upvalues[3]:
		[1]: Players_upvr (readonly)
		[2]: PlayerDataController_upvr (readonly)
		[3]: CONSTANTS_upvr (readonly)
	]]
	arg1.LocalFighter = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.FighterController):WaitForLocalFighter()
	arg1.LocalFighter.StopSliding:Connect(function() -- Line 1010
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:StopSliding()
	end)
	arg1.LocalFighter:GetDataChangedSignal("AutoShootRestriction"):Connect(function() -- Line 1014
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ToggleAutoShoot()
	end)
	arg1.LocalFighter:GetDataChangedSignal("CheaterMode"):Connect(function() -- Line 1018
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ToggleAutoShoot()
	end)
	arg1.LocalFighter:GetDataChangedSignal("IsHiddenByCutscene"):Connect(function() -- Line 1022
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ToggleAutoShoot()
	end)
	local tbl_upvw = {}
	arg1.LocalFighter.EquippedItemChanged:Connect(function(arg1_8) -- Line 1028
		--[[ Upvalues[2]:
			[1]: tbl_upvw (read and write)
			[2]: arg1 (readonly)
		]]
		for _, v_4 in pairs(tbl_upvw) do
			v_4:Disconnect()
		end
		tbl_upvw = {}
		arg1:_UpdateWalkSpeed()
		arg1:_ToggleAutoShoot()
		if not arg1_8 then
		else
			table.insert(tbl_upvw, arg1_8.StopSprinting:Connect(function() -- Line 1042
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				arg1:SetSprinting(false)
			end))
			table.insert(tbl_upvw, arg1_8.AttemptToSprintAgain:Connect(function() -- Line 1046
				--[[ Upvalues[1]:
					[1]: arg1 (copied, readonly)
				]]
				if arg1:IsInputDown("Sprint") or arg1:IsInputDown("AutoSprint") then
					arg1:SetSprinting(true)
				end
			end))
		end
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Auto Jump"):Connect(function() -- Line 1053, Named "update_auto_jump"
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: PlayerDataController_upvr (copied, readonly)
		]]
		if arg1.LocalFighter.Entity and arg1.LocalFighter.Entity.Humanoid then
			arg1.LocalFighter.Entity.Humanoid.AutoJumpEnabled = PlayerDataController_upvr:Get("Settings Auto Jump")
		end
	end)
	local function entity_added(arg1_9) -- Line 1061
		--[[ Upvalues[3]:
			[1]: arg1 (readonly)
			[2]: CONSTANTS_upvr (copied, readonly)
			[3]: PlayerDataController_upvr (copied, readonly)
		]]
		arg1._original_humanoid_animations = {}
		arg1._double_jumps_used = {}
		arg1:SetCrouching(false)
		arg1:SetSprinting(false)
		arg1:StopSliding()
		arg1:_UpdateWalkSpeed()
		arg1_9.Humanoid.CameraOffset = Vector3.new(0, 1, 0)
		local BodyForce_upvr = Instance.new("BodyForce")
		BodyForce_upvr.Name = "CustomGravity"
		BodyForce_upvr.Parent = arg1_9.RootPart
		local function update_gravity_upvr() -- Line 1079, Named "update_gravity"
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_9 (readonly)
				[3]: CONSTANTS_upvr (copied, readonly)
				[4]: BodyForce_upvr (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [4] 4. Error Block 7 start (CF ANALYSIS FAILED)
			local any_Get_result1_8 = arg1_9:Get("Gravity")
			if not any_Get_result1_8 then
				-- KONSTANTERROR: [10] 9. Error Block 3 start (CF ANALYSIS FAILED)
				any_Get_result1_8 = 1
				-- KONSTANTERROR: [10] 9. Error Block 3 end (CF ANALYSIS FAILED)
			end
			BodyForce_upvr.Force = Vector3.new(0, arg1_9.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_upvr.BASE_GRAVITY * any_Get_result1_8), 0)
			arg1_9.Humanoid.JumpPower = CONSTANTS_upvr.BASE_JUMPPOWER
			-- KONSTANTERROR: [4] 4. Error Block 7 end (CF ANALYSIS FAILED)
		end
		arg1_9:GetDataChangedSignal("Gravity"):Connect(update_gravity_upvr)
		arg1_9.EmoteStatusChanged:Connect(update_gravity_upvr)
		arg1.StateChanged:Connect(update_gravity_upvr)
		local descendant_added
		local function INLINED_11() -- Internal function, doesn't exist in bytecode
			descendant_added = arg1_9:Get("Gravity")
			return descendant_added
		end
		if arg1.IsCrouching or not INLINED_11() then
			descendant_added = 1
		end
		BodyForce_upvr.Force = Vector3.new(0, arg1_9.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_upvr.BASE_GRAVITY * descendant_added), 0)
		arg1_9.Humanoid.JumpPower = CONSTANTS_upvr.BASE_JUMPPOWER
		function descendant_added(arg1_13) -- Line 1093
			--[[ Upvalues[1]:
				[1]: update_gravity_upvr (readonly)
			]]
			if arg1_13:IsA("BasePart") then
				arg1_13:GetPropertyChangedSignal("AssemblyMass"):Connect(update_gravity_upvr)
				arg1_13:GetPropertyChangedSignal("Mass"):Connect(update_gravity_upvr)
			end
		end
		arg1_9.Model.DescendantAdded:Connect(descendant_added)
		for i_5, v_5 in pairs(arg1_9.Model:GetDescendants()) do
			if v_5:IsA("BasePart") then
				v_5:GetPropertyChangedSignal("AssemblyMass"):Connect(update_gravity_upvr)
				v_5:GetPropertyChangedSignal("Mass"):Connect(update_gravity_upvr)
			end
		end
		arg1_9.Humanoid.Jumping:Connect(function() -- Line 1106
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_9 (readonly)
				[3]: CONSTANTS_upvr (copied, readonly)
				[4]: BodyForce_upvr (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [4] 4. Error Block 7 start (CF ANALYSIS FAILED)
			local any_Get_result1_7 = arg1_9:Get("Gravity")
			if not any_Get_result1_7 then
				-- KONSTANTERROR: [10] 9. Error Block 3 start (CF ANALYSIS FAILED)
				any_Get_result1_7 = 1
				-- KONSTANTERROR: [10] 9. Error Block 3 end (CF ANALYSIS FAILED)
			end
			BodyForce_upvr.Force = Vector3.new(0, arg1_9.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_upvr.BASE_GRAVITY * any_Get_result1_7), 0)
			arg1_9.Humanoid.JumpPower = CONSTANTS_upvr.BASE_JUMPPOWER
			arg1:StopSliding(true)
			-- KONSTANTERROR: [4] 4. Error Block 7 end (CF ANALYSIS FAILED)
		end)
		arg1_9.Humanoid.StateChanged:Connect(function(arg1_14, arg2) -- Line 1111
			--[[ Upvalues[4]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_9 (readonly)
				[3]: CONSTANTS_upvr (copied, readonly)
				[4]: BodyForce_upvr (readonly)
			]]
			-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
			-- KONSTANTERROR: [4] 4. Error Block 13 start (CF ANALYSIS FAILED)
			local any_Get_result1_6 = arg1_9:Get("Gravity")
			if not any_Get_result1_6 then
				-- KONSTANTERROR: [10] 9. Error Block 3 start (CF ANALYSIS FAILED)
				any_Get_result1_6 = 1
				-- KONSTANTERROR: [10] 9. Error Block 3 end (CF ANALYSIS FAILED)
			end
			BodyForce_upvr.Force = Vector3.new(0, arg1_9.RootPart.AssemblyMass * workspace.Gravity * (1 - CONSTANTS_upvr.BASE_GRAVITY * any_Get_result1_6), 0)
			arg1_9.Humanoid.JumpPower = CONSTANTS_upvr.BASE_JUMPPOWER
			if arg2 == Enum.HumanoidStateType.Climbing then
				arg1:StopSliding()
			else
				if arg2 == Enum.HumanoidStateType.Landed then
					arg1._double_jumps_used = {}
				end
				-- KONSTANTERROR: [4] 4. Error Block 13 end (CF ANALYSIS FAILED)
			end
		end)
		arg1_9.Humanoid.Died:Connect(function() -- Line 1121
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			arg1:SetSprinting(false)
			arg1:SetCrouching(false)
			arg1:StopSliding()
		end)
		arg1_9.AirborneLocallyChanged:Connect(function() -- Line 1127
			--[[ Upvalues[2]:
				[1]: arg1 (copied, readonly)
				[2]: arg1_9 (readonly)
			]]
			arg1:_UpdateServerState("IsAirborne", arg1_9:IsAirborne())
		end)
		arg1_9.RedirectSliding:Connect(function(arg1_15) -- Line 1131
			--[[ Upvalues[1]:
				[1]: arg1 (copied, readonly)
			]]
			if arg1._update_slide_direction then
				arg1._update_slide_direction(arg1_15)
			end
		end)
		if arg1.LocalFighter.Entity then
			i_5 = arg1
			if i_5.LocalFighter.Entity.Humanoid then
				i_5 = arg1
				i_5 = "Settings Auto Jump"
				i_5.LocalFighter.Entity.Humanoid.AutoJumpEnabled = PlayerDataController_upvr:Get(i_5)
			end
		end
	end
	arg1.LocalFighter.EntityAdded:Connect(entity_added)
	if arg1.LocalFighter.Entity then
		task.spawn(entity_added, arg1.LocalFighter.Entity)
	end
	arg1._internal_local_fighter_added:Fire()
	arg1:_SetupControls()
	arg1:_ToggleAutoShoot()
	task.defer(arg1._DisableRobloxJumpButton, arg1)
end
function module_upvr._Init(arg1) -- Line 1153
	--[[ Upvalues[2]:
		[1]: ControlsController_upvr (readonly)
		[2]: PlayerDataController_upvr (readonly)
	]]
	ControlsController_upvr.ControlsChanged:Connect(function() -- Line 1154
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_SetupControls()
		arg1:_ToggleAutoShoot()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Auto Shoot"):Connect(function() -- Line 1159
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ToggleAutoShoot()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Auto Shoot Reaction Time"):Connect(function() -- Line 1163
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ToggleAutoShoot()
	end)
	task.defer(arg1._HookFighter, arg1)
end
return module_upvr._new()
