-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:16:27
-- Luau version 6, Types version 3
-- Time taken: 0.217492 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService_upvr = game:GetService("UserInputService")
local VRService_upvr = game:GetService("VRService")
local Players = game:GetService("Players")
local Utility_upvr = require(ReplicatedStorage.Modules.Utility)
local UserInterfaceController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.UserInterfaceController)
local PlayerDataController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.PlayerDataController)
local ControlsController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local Value_4_upvr = Enum.RenderPriority.Camera.Value
local tbl_upvr = {
	MouseKeyboard = 1;
	Touch = 0.875;
	Gamepad = 0.75;
}
local module_upvr = {}
module_upvr.__index = module_upvr
local Signal_upvr = require(ReplicatedStorage.Modules.Signal)
local module_upvr_2 = require(script:WaitForChild("CameraState"))
local Spring_upvr = require(ReplicatedStorage.Modules.Spring)
local QuaternionSpring_upvr = require(ReplicatedStorage.Modules.QuaternionSpring)
local Quaternion_upvr = require(ReplicatedStorage.Modules.Quaternion)
function module_upvr._new() -- Line 38
	--[[ Upvalues[6]:
		[1]: module_upvr (readonly)
		[2]: Signal_upvr (readonly)
		[3]: module_upvr_2 (readonly)
		[4]: Spring_upvr (readonly)
		[5]: QuaternionSpring_upvr (readonly)
		[6]: Quaternion_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.StateChanged = Signal_upvr.new()
	setmetatable_result1.ActiveStateChanged = Signal_upvr.new()
	setmetatable_result1.POVStateChanged = Signal_upvr.new()
	setmetatable_result1.CustomFreecamStateChanged = Signal_upvr.new()
	setmetatable_result1.RotationDeltaApplied = Signal_upvr.new()
	setmetatable_result1.SubjectChanged = Signal_upvr.new()
	setmetatable_result1.CameraState = module_upvr_2.new(setmetatable_result1)
	setmetatable_result1.Rotation = Vector2.zero
	setmetatable_result1.ShakeCFrame = CFrame.identity
	setmetatable_result1.ViewModelOffsetCFrame = CFrame.identity
	setmetatable_result1.VRCameraCFrame = nil
	setmetatable_result1._current_subject = nil
	setmetatable_result1._current_duel_subject = nil
	setmetatable_result1._third_person_override = nil
	setmetatable_result1._external_fov_offsets = {}
	setmetatable_result1._is_editing_mobile_buttons = false
	setmetatable_result1._last_dt = 0
	setmetatable_result1._last_mouse_behavior = nil
	setmetatable_result1._gamepad_rotation_input = Vector2.zero
	setmetatable_result1._bobbing_tick = 0
	setmetatable_result1._fov_spring = Spring_upvr.new(60, 0.75, 30)
	setmetatable_result1._fov_viewmodel_offset_spring = Spring_upvr.new(0, 1, 20)
	setmetatable_result1._position_spring = Spring_upvr.new(Vector3.new(0, 0, 0), 0.75, 30)
	setmetatable_result1._pov_spring = Spring_upvr.new(Vector3.new(0, 0, 0), 0.875, 25)
	setmetatable_result1._sway_spring = Spring_upvr.new(Vector2.zero, 0.5, 12.5)
	setmetatable_result1._bobbing_speed_spring = Spring_upvr.new(0, 0.5, 12.5)
	setmetatable_result1._bobbing_value_spring = Spring_upvr.new(0, 0.75, 12.5)
	setmetatable_result1._jump_spring = Spring_upvr.new(0, 0.5, 15)
	setmetatable_result1._sliding_spring = Spring_upvr.new(0, 0.5, 15)
	setmetatable_result1._leaning_spring = Spring_upvr.new(0, 1, 20)
	setmetatable_result1._camera_shaker = nil
	setmetatable_result1._collision_whitelist = {}
	setmetatable_result1._next_collision_whitelist_fetch = 0
	setmetatable_result1._viewmodel_animation_spring = QuaternionSpring_upvr.new(Quaternion_upvr.fromCFrame(CFrame.identity), 1, 10)
	setmetatable_result1._crosshair_disabled = false
	setmetatable_result1._base_fov = 80
	setmetatable_result1._fov_effects = true
	setmetatable_result1._shake_enabled = true
	setmetatable_result1._open_playerlist_input_down = false
	setmetatable_result1._inverted_identity_vector = Vector2.one
	setmetatable_result1._camera_sensitivity = 1
	setmetatable_result1._camera_sensitivity_ads_multiplier = 1
	setmetatable_result1._camera_sensitivity_x = 1
	setmetatable_result1._camera_sensitivity_y = 1
	setmetatable_result1._fov_offset_strength = 0
	setmetatable_result1._gamepad_deadzone = 0.25
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.GetPublicState(arg1, ...) -- Line 106
	return arg1.CameraState:GetPublicState(...)
end
function module_upvr.GetCurrentSubject(arg1) -- Line 110
	return arg1._current_subject
end
function module_upvr.IsSubjectEmoting(arg1) -- Line 114
	local any_GetCurrentSubject_result1_2 = arg1:GetCurrentSubject()
	local var21 = any_GetCurrentSubject_result1_2
	if var21 then
		var21 = any_GetCurrentSubject_result1_2.Entity
		if var21 then
			var21 = any_GetCurrentSubject_result1_2.Entity:IsEmoting()
		end
	end
	return var21
end
local DebugState_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.DebugController.DebugState)
function module_upvr.HasThirdPersonAccess(arg1, arg2) -- Line 120
	--[[ Upvalues[2]:
		[1]: DebugState_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
	]]
	if arg1._third_person_override ~= nil then
		return arg1._third_person_override
	end
	if arg1._current_subject and arg1._current_subject:Get("CheaterMode") then
		return true
	end
	if not arg2 and arg1:IsSubjectEmoting() then
		return true
	end
	local any_Get_result1 = DebugState_upvr:Get("AreHandicapsEnabled")
	if not any_Get_result1 then
		if ControlsController_upvr.CurrentControls ~= "Touch" then
			any_Get_result1 = false
		else
			any_Get_result1 = true
		end
	end
	return any_Get_result1
end
function module_upvr.HasUnlockedMouseAccess(arg1) -- Line 127
	--[[ Upvalues[1]:
		[1]: ControlsController_upvr (readonly)
	]]
	local any_HasThirdPersonAccess_result1 = arg1:HasThirdPersonAccess()
	if any_HasThirdPersonAccess_result1 then
		any_HasThirdPersonAccess_result1 = true
		if ControlsController_upvr.CurrentControls ~= "MouseKeyboard" then
			any_HasThirdPersonAccess_result1 = arg1:IsSubjectEmoting()
		end
	end
	return any_HasThirdPersonAccess_result1
end
function module_upvr.GetLastHeartbeatDeltaTime(arg1) -- Line 131
	return arg1._last_dt
end
function module_upvr.GetRenderstepPriority(arg1) -- Line 135
	--[[ Upvalues[1]:
		[1]: Value_4_upvr (readonly)
	]]
	return Value_4_upvr
end
function module_upvr.GetCameraCFrame(arg1) -- Line 139
	--[[ Upvalues[1]:
		[1]: ControlsController_upvr (readonly)
	]]
	local var26
	if var26 == "VR" then
		var26 = workspace.CurrentCamera.CFrame * arg1.VRCameraCFrame
		return var26
	end
	var26 = arg1._current_subject
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var26 = arg1._current_subject.Entity
		return var26
	end
	if not var26 or not INLINED() then
		var26 = CFrame.identity
		return var26
	end
	if arg1.CameraState:GetPublicState() == arg1.CameraState.States.FirstPerson then
		var26 = CFrame.new(arg1._leaning_spring.Value * Vector3.new(2, 0.10000, 0))
	else
		var26 = CFrame.identity
	end
	return CFrame.new(arg1._current_subject.Entity.RootPart.Position) * CFrame.new(arg1._position_spring.Value) * arg1:GetRotationCFrame() * var26
end
function module_upvr.GetRotationCFrame(arg1, arg2) -- Line 154
	local var27 = arg2
	if not var27 then
		var27 = arg1.Rotation
	end
	return CFrame.Angles(0, var27.Y, 0) * CFrame.Angles(var27.X, 0, 0)
end
function module_upvr.GetGamepadRotationInput(arg1, arg2) -- Line 162
	if not arg2 or not Vector2.new(arg1._gamepad_rotation_input.Y, arg1._gamepad_rotation_input.X) then
	end
	return arg1._gamepad_rotation_input
end
function module_upvr.SetRotation(arg1, arg2) -- Line 167
	if arg1._current_subject and arg1._current_subject.Entity and arg1._current_subject.Entity:Get("IsFrozen") then
	else
		arg1.Rotation = Vector2.new(math.clamp(arg2.X, -1.5690509975429023, 1.5690509975429023), arg2.Y)
	end
end
function module_upvr.GetExternalFOVOffset(arg1) -- Line 175
	local var32 = 0
	for _, v in pairs(arg1._external_fov_offsets) do
		var32 += v
	end
	return var32
end
function module_upvr.GetCameraSensitivity(arg1) -- Line 185
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local _current_subject = arg1._current_subject
	if _current_subject then
		_current_subject = arg1._current_subject.EquippedItem
		if _current_subject then
			_current_subject = arg1._current_subject.EquippedItem:Get("IsAiming")
		end
	end
	if not _current_subject or not arg1._camera_sensitivity_ads_multiplier then
	end
	return arg1._camera_sensitivity * 1
end
function module_upvr.SetSubject(arg1, arg2) -- Line 192
	arg1._current_subject = arg2
	arg1.SubjectChanged:Fire()
end
function module_upvr.SetDuelSubject(arg1, arg2) -- Line 198
	arg1._current_duel_subject = arg2
end
function module_upvr.SetExternalFOVOffset(arg1, arg2, arg3) -- Line 202
	local var39
	if arg3 == 0 then
		var39 = nil
	else
		var39 = arg3
	end
	arg1._external_fov_offsets[arg2] = var39
end
function module_upvr.SetThirdPersonOverride(arg1, arg2) -- Line 206
	arg1._third_person_override = arg2
	arg1.CameraState:VerifyPOV()
end
function module_upvr.SetIsEditingMobileButtons(arg1, arg2) -- Line 211
	arg1._is_editing_mobile_buttons = arg2
end
function module_upvr.Freeze(arg1, arg2) -- Line 215
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	if arg2 and not arg1.IsFrozen then
		UserInputService_upvr.MouseIconEnabled = true
		UserInputService_upvr.MouseBehavior = Enum.MouseBehavior.Default
	elseif not arg2 and arg1.IsFrozen then
		arg1._last_mouse_behavior = nil
	end
	arg1.IsFrozen = arg2
	arg1:Update(0)
end
function module_upvr.ApplyRotationDelta(arg1, arg2) -- Line 228
	local var40 = arg2 * arg1._inverted_identity_vector * arg1:GetCameraSensitivity() * Vector2.new(arg1._camera_sensitivity_y, arg1._camera_sensitivity_x)
	arg1:SetRotation(arg1.Rotation + var40)
	arg1.RotationDeltaApplied:Fire(var40)
end
function module_upvr.ShakeOnce(arg1, ...) -- Line 235
	arg1._camera_shaker:ShakeOnce(...)
end
function module_upvr.Shake(arg1, ...) -- Line 239
	arg1._camera_shaker:Shake(...)
end
function module_upvr.MimicRotation(arg1, arg2) -- Line 244
	local any_ToOrientation_result1, any_ToOrientation_result2, _ = arg2:ToOrientation()
	arg1:SetRotation(Vector2.new(any_ToOrientation_result1, any_ToOrientation_result2))
end
local CollectionService_upvr = game:GetService("CollectionService")
local CONSTANTS_upvr = require(ReplicatedStorage.Modules.CONSTANTS)
local GameplayUtility_upvr = require(ReplicatedStorage.Modules.GameplayUtility)
function module_upvr.Update(arg1, arg2) -- Line 250
	--[[ Upvalues[7]:
		[1]: CollectionService_upvr (readonly)
		[2]: UserInputService_upvr (readonly)
		[3]: ControlsController_upvr (readonly)
		[4]: CONSTANTS_upvr (readonly)
		[5]: UserInterfaceController_upvr (readonly)
		[6]: GameplayUtility_upvr (readonly)
		[7]: Utility_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
	local var101
	-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [3] 3. Error Block 227 start (CF ANALYSIS FAILED)
	var101 = arg1.CameraState.States.CustomFreecam
	if arg1.CameraState:GetPublicState() == var101 then
		-- KONSTANTERROR: [16] 10. Error Block 3 start (CF ANALYSIS FAILED)
		do
			return
		end
		-- KONSTANTERROR: [16] 10. Error Block 3 end (CF ANALYSIS FAILED)
	end
	var101 = false
	if arg1._current_subject ~= nil then
		var101 = arg1._current_subject:IsAlive()
		if var101 then
			var101 = arg1._current_subject
		end
	end
	if var101 then
	end
	arg1.CameraState:SetActive(var101:IsActive())
	local any_GetPublicState_result1_4 = arg1.CameraState:GetPublicState()
	local var103 = not any_GetPublicState_result1_4
	if var103 then
		var103 = arg1._current_duel_subject
		if var103 then
			var103 = not arg1._current_duel_subject.LocalDueler
		end
	end
	if var103 then
		if not arg1._current_duel_subject.Map or not arg1._current_duel_subject.Map:GetSpectatePart() then
			local _ = CollectionService_upvr:GetTagged("WaitingRoomSpectate")[1]
			-- KONSTANTWARNING: GOTO [78] #53
		end
	else
	end
	if nil then
		UserInputService_upvr.MouseIconEnabled = true
		UserInputService_upvr.MouseBehavior = Enum.MouseBehavior.Default
		workspace.CurrentCamera.CameraSubject = nil
		workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		workspace.CurrentCamera.CFrame = nil.CFrame
	else
		local var105 = true
		if any_GetPublicState_result1_4 ~= arg1.CameraState.States.ThirdPersonUnlockedMouse then
			var105 = not var101
			if not var105 then
				var105 = not var101.IsLocalPlayer
			end
		end
		local var106 = any_GetPublicState_result1_4
		if var106 then
			if any_GetPublicState_result1_4 == arg1.CameraState.States.ThirdPersonUnlockedMouse then
				var106 = false
			else
				var106 = true
			end
		end
		if var101 then
		end
		local any__Modal_result1_2 = arg1:_Modal()
		local var108 = any__Modal_result1_2
		if var108 then
			if ControlsController_upvr.CurrentControls ~= "MouseKeyboard" then
				var108 = false
			else
				var108 = true
			end
		end
		if not var106 or var105 or ControlsController_upvr.CurrentControls ~= "MouseKeyboard" or var108 or not Enum.MouseBehavior.LockCenter then
			local Default_3 = Enum.MouseBehavior.Default
		end
		if not var101 or not var101.Entity or not var101.Entity.Humanoid then
		end
		workspace.CurrentCamera.CameraSubject = nil
		if not var106 or not Enum.CameraType.Scriptable then
		end
		workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
		if not var108 then
			if not not var101.EquippedItem then
				if not not var101 then
					if not not var101.IsLocalPlayer then
						if ControlsController_upvr.CurrentControls ~= "Touch" then
						end
					end
				end
			end
		end
		UserInputService_upvr.MouseIconEnabled = arg1._crosshair_disabled and var105
		if Default_3 == Enum.MouseBehavior.LockCenter or Default_3 ~= arg1._last_mouse_behavior then
			UserInputService_upvr.MouseBehavior = Default_3
			arg1._last_mouse_behavior = Default_3
		end
		if not var106 then
			arg1:MimicRotation(workspace.CurrentCamera.CFrame.Rotation * CFrame.Angles(0.17453292519943295, 0, 0))
		end
		if not var101 then
			workspace.CurrentCamera.FieldOfView = arg1._base_fov
			return
		end
		local var110 = false
		if workspace.CurrentCamera.CameraType == Enum.CameraType.Custom then
			var110 = false
			if workspace.CurrentCamera.CameraType ~= Enum.CameraType.Custom then
				if (workspace.CurrentCamera.CFrame.Position - CFrame.new(var101.Entity.RootPart.Position).Position).Magnitude >= 128 then
					var110 = false
				else
					var110 = true
				end
			end
		end
		if var110 then
			arg1._fov_spring.Value = workspace.CurrentCamera.FieldOfView
		end
		local IsLocalPlayer_3 = var101.IsLocalPlayer
		local any_IsSliding_result1_2 = var101:IsSliding()
		local var113
		if var101 and var101.Entity then
			if var101.Entity.Humanoid then
				if var101.Entity.Humanoid:GetState() ~= Enum.HumanoidStateType.Climbing then
				else
				end
			end
		end
		local var114 = var101:GetCameraSway() * 0.25
		local any_GetClampedVelocity_result1_3 = var101.Entity:GetClampedVelocity()
		local Magnitude = (any_GetClampedVelocity_result1_3 * Vector3.new(1, 0, 1)).Magnitude
		var113 = 20 * var101:GetAimSpeed()
		arg1._fov_viewmodel_offset_spring.Speed = var113
		if any_GetPublicState_result1_4 == arg1.CameraState.States.ThirdPersonUnlockedMouse then
			var113 = 0
		else
			var113 = var101:GetFOVOffset() * arg1._fov_offset_strength
		end
		arg1._fov_viewmodel_offset_spring.Target = var113
		if not arg1._fov_effects or not (math.max(0, Magnitude - CONSTANTS_upvr.BASE_WALKSPEED) * 10 / CONSTANTS_upvr.BASE_WALKSPEED) then
		end
		var113 = arg1._base_fov + 0 + arg1:GetExternalFOVOffset()
		arg1._fov_spring.Target = var113
		var113 = arg1._fov_spring.Value
		var113 = workspace.CurrentCamera
		var113.FieldOfView = var113 + (arg1._fov_viewmodel_offset_spring.Value) * (arg1._fov_spring.Value / 80)
		var113 = arg1._position_spring
		if any_IsSliding_result1_2 then
		elseif true then
		elseif var101:IsCrouching() then
		else
		end
		var113.Target = Vector3.new(0, 1.75, 0) + Vector3.new(0, 0, 0)
		var113 = workspace.CurrentCamera.CameraType
		if var113 ~= Enum.CameraType.Scriptable then return end
		if var110 then
			var113 = arg1._position_spring
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			var113.Value = workspace.CurrentCamera.CFrame:ToObjectSpace(CFrame.new(var101.Entity.RootPart.Position)):Inverse().Position * 0.5
		end
		var113 = ControlsController_upvr.CurrentControls
		if var113 == "Gamepad" and not any__Modal_result1_2 then
			var113 = UserInterfaceController_upvr:IsPageOpen()
			if not var113 then
				var113 = arg1:ApplyRotationDelta
				var113(arg1._gamepad_rotation_input * arg1:_GetFOVMultiplier() * (arg2 or 0) * 60)
			end
		end
		var113 = CFrame.new(arg1._position_spring.Value)
		local var117
		local var118
		if any_GetPublicState_result1_4 == arg1.CameraState.States.FirstPerson and not IsLocalPlayer_3 then
			var118 = CONSTANTS_upvr.BASE_WALKSPEED
			if var101:IsGrounded() then
				var118 = 1
			else
				var118 = 0
			end
			arg1._bobbing_speed_spring.Target = Magnitude / var118 * var118 * 0.111
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			arg1._bobbing_tick += arg1._bobbing_speed_spring.Value * (arg2 or 0) * 60
			var117 = CONSTANTS_upvr
			if any_IsSliding_result1_2 then
			else
			end
			arg1._bobbing_value_spring.Target = (math.abs(math.sin(arg1._bobbing_tick)) - 0.5) * (Magnitude / var117.BASE_WALKSPEED) ^ 2 * 1 * 0.125
			local Value_7 = arg1._bobbing_value_spring.Value
		end
		local _sway_spring_4 = arg1._sway_spring
		_sway_spring_4.Value += Vector2.new(var114.Y * 0.5, var114.X)
		local _sway_spring_6 = arg1._sway_spring
		if IsLocalPlayer_3 then
			_sway_spring_6 = 0
		else
			_sway_spring_6 = 0.025
		end
		local var122 = _sway_spring_6.Value * _sway_spring_6
		if not IsLocalPlayer_3 or not CFrame.identity then
			var117 = tick() * 0.23983
			var117 = tick() * 0.372721 % (-math.pi*2)
			var117 = math.sin(tick() * 0.43123 % (-math.pi*2))
		end
		arg1._jump_spring.Target = any_GetClampedVelocity_result1_3.Y
		var117 = arg1._jump_spring
		local Value_3 = var117.Value
		var117 = CONSTANTS_upvr.BASE_GRAVITY
		if IsLocalPlayer_3 then
			Value_3 = 0
		else
			Value_3 = 0.5
		end
		var117 = math.rad(-(Value_3 / var117 * Value_3) / 15)
		var117 = 0
		if any_IsSliding_result1_2 then
			var117 = 1
		else
			var117 = 0
		end
		arg1._sliding_spring.Target = var117
		var117 = arg1._sliding_spring
		var117 = CFrame.Angles(0, 0, -0.08726646259971647 * var117.Value)
		if any_GetPublicState_result1_4 ~= arg1.CameraState.States.FirstPerson or not var101:GetCameraLean() then
		end
		arg1._leaning_spring.Target = 0
		local Value_6 = arg1._leaning_spring.Value
		-- KONSTANTERROR: Expression was reused, decompilation is incorrect
		local var125 = (CFrame.new(var101.Entity.RootPart.Position) * var113) * ((CFrame.new(0, Value_7, 0) * var101:GetRotationCFrame() * CFrame.Angles(Value_7 * 0.08726646259971647, 0, 0) * CFrame.new(arg1._pov_spring.Value) * CFrame.Angles(var122.X, 0, var122.Y) * CFrame.Angles(math.sin(var117 % (-math.pi*2)) * 0.004363323129985824, math.sin(var117) * 0.004363323129985824, var117 * 0.004363323129985824) * CFrame.Angles(math.clamp(var117, -0.7853981633974483, 0.7853981633974483), var117, 0) * var117) * (CFrame.new(Value_6 * Vector3.new(2, 0.10000, 0)) * CFrame.Angles(0, 0, Value_6 * -0.08726646259971647)) * arg1.ViewModelOffsetCFrame * arg1.ShakeCFrame)
		if arg1._next_collision_whitelist_fetch < tick() then
			arg1._next_collision_whitelist_fetch = tick() + 5
			arg1._collision_whitelist = GameplayUtility_upvr:GetRaycastWhitelist(var101:Get("EnvironmentID"))
		end
		local any_Raycast_result1_2 = Utility_upvr:Raycast(var101.Entity.RootPart.Position, var125.Position, (var125.Position - var101.Entity.RootPart.Position).Magnitude, arg1._collision_whitelist, Enum.RaycastFilterType.Include)
		if any_Raycast_result1_2.Instance then
		end
		workspace.CurrentCamera.CFrame = CFrame.new(var101.Entity.RootPart.Position + (var125.Position - var101.Entity.RootPart.Position).Unit * ((var101.Entity.RootPart.Position - any_Raycast_result1_2.Position).Magnitude - 0.5)) * var125.Rotation
		-- KONSTANTERROR: [3] 3. Error Block 227 end (CF ANALYSIS FAILED)
	end
end
function module_upvr._UpdateSettings(arg1) -- Line 432
	--[[ Upvalues[1]:
		[1]: PlayerDataController_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	arg1._crosshair_disabled = PlayerDataController_upvr:Get("Settings Crosshair Disabled")
	arg1._base_fov = PlayerDataController_upvr:Get("Settings Camera FOV")
	arg1._fov_effects = PlayerDataController_upvr:Get("Settings Camera FOV Effects")
	arg1._shake_enabled = PlayerDataController_upvr:Get("Settings Camera Shake")
	local var127
	if PlayerDataController_upvr:Get("Settings Camera Inverted Y") then
		var127 = -1
	else
		var127 = 1
	end
	if PlayerDataController_upvr:Get("Settings Camera Inverted X") then
	else
	end
	arg1._inverted_identity_vector = Vector2.new(var127, 1)
	arg1._camera_sensitivity = PlayerDataController_upvr:Get("Settings Camera Sensitivity")
	arg1._camera_sensitivity_ads_multiplier = PlayerDataController_upvr:Get("Settings Camera Sensitivity ADS")
	arg1._camera_sensitivity_x = PlayerDataController_upvr:Get("Settings Camera Sensitivity X")
	arg1._camera_sensitivity_y = PlayerDataController_upvr:Get("Settings Camera Sensitivity Y")
	arg1._fov_offset_strength = PlayerDataController_upvr:Get("Settings Camera Zoom Effects")
	arg1._gamepad_deadzone = PlayerDataController_upvr:Get("Settings Gamepad Deadzone")
end
function module_upvr._Modal(arg1) -- Line 446
	--[[ Upvalues[1]:
		[1]: UserInterfaceController_upvr (readonly)
	]]
	local _current_duel_subject_2 = arg1._current_duel_subject
	if _current_duel_subject_2 then
		_current_duel_subject_2 = arg1._current_duel_subject.DuelInterface
		if _current_duel_subject_2 then
			_current_duel_subject_2 = arg1._current_duel_subject.DuelInterface.Scoreboard:IsOpen()
		end
	end
	local var131 = _current_duel_subject_2
	if not var131 then
		var131 = UserInterfaceController_upvr:IsPageOpen()
		if not var131 then
			var131 = arg1._open_playerlist_input_down
		end
	end
	return var131
end
function module_upvr._GetFOVMultiplier(arg1) -- Line 452
	local var132
	local function INLINED_5() -- Internal function, doesn't exist in bytecode
		var132 = workspace.CurrentCamera.FieldOfView / arg1._base_fov
		return var132
	end
	if workspace.CurrentCamera.FieldOfView >= arg1._base_fov or not INLINED_5() then
		var132 = 1
	end
	return var132
end
local var133_upvr = Vector2.new(0.77, 1) * 0.008726646259971648
function module_upvr._InputChanged(arg1, arg2, arg3) -- Line 456
	--[[ Upvalues[3]:
		[1]: ControlsController_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: var133_upvr (readonly)
	]]
	if arg3 or arg1._is_editing_mobile_buttons then
	else
		if ControlsController_upvr.CurrentControls == "MouseKeyboard" and arg2.UserInputType ~= Enum.UserInputType.MouseMovement and arg2.UserInputType ~= Enum.UserInputType.MouseWheel then return end
		local var134 = tbl_upvr[ControlsController_upvr.CurrentControls]
		if ControlsController_upvr.CurrentControls == "MouseKeyboard" or ControlsController_upvr.CurrentControls == "Touch" then
			arg1:ApplyRotationDelta(Vector2.new(arg2.Delta.Y, arg2.Delta.X) * var133_upvr * var134 * arg1:_GetFOVMultiplier() * -1)
			return
		end
		if ControlsController_upvr.CurrentControls == "Gamepad" and (arg2.KeyCode == Enum.KeyCode.Thumbstick1 or arg2.KeyCode == Enum.KeyCode.Thumbstick2) then
			local maximum = math.max(0, (Vector2.new(arg2.Position.X, arg2.Position.Y).Magnitude - arg1._gamepad_deadzone) / (1 - arg1._gamepad_deadzone))
			arg1._gamepad_rotation_input = Vector2.new(math.floor(arg2.Position.Y * maximum * 10 + 0.5) * var134, -math.floor(arg2.Position.X * maximum * 10 + 0.5) * var134) * 0.01
		end
	end
end
local CameraShaker_upvr = require(Players.LocalPlayer.PlayerScripts.Modules.CameraShaker)
function module_upvr._Setup(arg1) -- Line 485
	--[[ Upvalues[2]:
		[1]: VRService_upvr (readonly)
		[2]: CameraShaker_upvr (readonly)
	]]
	if VRService_upvr:GetUserCFrameEnabled(Enum.UserCFrame.RightHand) then
		arg1.VRCameraCFrame = VRService_upvr:GetUserCFrame(Enum.UserCFrame.RightHand)
	end
	arg1._camera_shaker = CameraShaker_upvr.new(Enum.RenderPriority.Camera.Value + 1, function(arg1_2) -- Line 490
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [5] 5. Error Block 7 start (CF ANALYSIS FAILED)
		local var138 = arg1_2
		if not var138 then
			-- KONSTANTERROR: [7] 7. Error Block 3 start (CF ANALYSIS FAILED)
			var138 = CFrame.identity
			-- KONSTANTERROR: [7] 7. Error Block 3 end (CF ANALYSIS FAILED)
		end
		arg1.ShakeCFrame = var138
		-- KONSTANTERROR: [5] 5. Error Block 7 end (CF ANALYSIS FAILED)
	end)
	arg1._camera_shaker:Start()
end
local InputLibrary_upvr = require(ReplicatedStorage.Modules.InputLibrary)
local SettingsController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.SettingsController)
local RunService_upvr = game:GetService("RunService")
function module_upvr._Init(arg1) -- Line 497
	--[[ Upvalues[8]:
		[1]: ControlsController_upvr (readonly)
		[2]: Utility_upvr (readonly)
		[3]: InputLibrary_upvr (readonly)
		[4]: SettingsController_upvr (readonly)
		[5]: PlayerDataController_upvr (readonly)
		[6]: VRService_upvr (readonly)
		[7]: RunService_upvr (readonly)
		[8]: Value_4_upvr (readonly)
	]]
	arg1.StateChanged:Connect(function() -- Line 498
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 17 start (CF ANALYSIS FAILED)
		local any_GetPublicState_result1_3 = arg1.CameraState:GetPublicState()
		local var144
		if any_GetPublicState_result1_3 == arg1.CameraState.States.ThirdPerson then
			var144 = Vector3.new(3, 1.5, 7.5)
			-- KONSTANTWARNING: GOTO [43] #29
		end
		-- KONSTANTERROR: [0] 1. Error Block 17 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [20] 14. Error Block 18 start (CF ANALYSIS FAILED)
		if any_GetPublicState_result1_3 == arg1.CameraState.States.ThirdPersonMirrored then
			var144 = Vector3.new(-3, 1.5, 7.5)
		elseif any_GetPublicState_result1_3 == arg1.CameraState.States.ThirdPersonUnlockedMouse then
			var144 = Vector3.new(0, 3, 10)
		else
			var144 = Vector3.new(0, 0, 0)
		end
		arg1._pov_spring.Target = var144
		-- KONSTANTERROR: [20] 14. Error Block 18 end (CF ANALYSIS FAILED)
	end)
	arg1.CameraState.StateChanged:Connect(function(arg1_3, arg2) -- Line 507
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1.StateChanged:Fire(arg1_3, arg2)
		if not arg1_3 or not arg2 then
			arg1.ActiveStateChanged:Fire(arg1_3, arg2)
		end
		if arg1_3 == arg1.CameraState.States.CustomFreecam or arg2 == arg1.CameraState.States.CustomFreecam then
			arg1.CustomFreecamStateChanged:Fire(arg1_3, arg2)
		end
		local table_find_result1_2 = table.find(arg1.CameraState.POVStates, arg1_3)
		local table_find_result1 = table.find(arg1.CameraState.POVStates, arg2)
		if table_find_result1_2 or table_find_result1 then
			arg1.POVStateChanged:Fire(arg1_3, arg2, table_find_result1_2 and table_find_result1)
		end
	end)
	ControlsController_upvr.InputBegan:Connect(function(arg1_4, arg2) -- Line 526
		--[[ Upvalues[5]:
			[1]: arg1 (readonly)
			[2]: Utility_upvr (copied, readonly)
			[3]: InputLibrary_upvr (copied, readonly)
			[4]: SettingsController_upvr (copied, readonly)
			[5]: PlayerDataController_upvr (copied, readonly)
		]]
		local any_GetPublicState_result1_2 = arg1.CameraState:GetPublicState()
		local var150
		if any_GetPublicState_result1_2 == arg1.CameraState.States.CustomFreecam then
			var150 = Utility_upvr:IsTextBoxFocused()
		else
			var150 = arg2
		end
		if not var150 and InputLibrary_upvr:InputIs(arg1_4, "HideHUD") then
			SettingsController_upvr:ChangeSetting("Settings Hide HUD", not PlayerDataController_upvr:Get("Settings Hide HUD"))
		end
		if arg1.IsFrozen or not any_GetPublicState_result1_2 then
		else
			if not arg2 and InputLibrary_upvr:InputIs(arg1_4, "SwitchCameraPOV") then
				arg1.CameraState:TogglePOV()
				return
			end
			if not arg2 and InputLibrary_upvr:InputIs(arg1_4, "OpenPlayerList") then
				arg1._open_playerlist_input_down = true
			end
		end
	end)
	ControlsController_upvr.InputChanged:Connect(function(...) -- Line 546
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [5] 5. Error Block 7 start (CF ANALYSIS FAILED)
		if not arg1.CameraState:GetPublicState() then
			-- KONSTANTERROR: [12] 10. Error Block 3 start (CF ANALYSIS FAILED)
			do
				return
			end
			-- KONSTANTERROR: [12] 10. Error Block 3 end (CF ANALYSIS FAILED)
		end
		arg1:_InputChanged(...)
		-- KONSTANTERROR: [5] 5. Error Block 7 end (CF ANALYSIS FAILED)
	end)
	ControlsController_upvr.InputEnded:Connect(function(arg1_5, arg2) -- Line 554
		--[[ Upvalues[2]:
			[1]: InputLibrary_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		if InputLibrary_upvr:InputIs(arg1_5, "OpenPlayerList") then
			arg1._open_playerlist_input_down = false
		end
	end)
	VRService_upvr.UserCFrameChanged:Connect(function(arg1_6, arg2) -- Line 560
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: VRService_upvr (copied, readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		local var158
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [4] 4. Error Block 23 start (CF ANALYSIS FAILED)
		var158 = arg1.CameraState:GetPublicState()
		if not var158 then
			-- KONSTANTERROR: [11] 9. Error Block 3 start (CF ANALYSIS FAILED)
			do
				return
			end
			-- KONSTANTERROR: [11] 9. Error Block 3 end (CF ANALYSIS FAILED)
		end
		var158 = VRService_upvr:GetUserCFrameEnabled(Enum.UserCFrame.RightHand)
		if var158 then
			var158 = VRService_upvr:GetUserCFrame(Enum.UserCFrame.RightHand)
		end
		local any_GetUserCFrameEnabled_result1 = VRService_upvr:GetUserCFrameEnabled(Enum.UserCFrame.Head)
		if any_GetUserCFrameEnabled_result1 then
			any_GetUserCFrameEnabled_result1 = VRService_upvr:GetUserCFrame(Enum.UserCFrame.Head)
		end
		local var160 = any_GetUserCFrameEnabled_result1
		if not var160 then
			var160 = var158
			if not var160 then
				var160 = CFrame.identity
			end
		end
		local var161 = var158
		if not var161 then
			var161 = any_GetUserCFrameEnabled_result1
			if not var161 then
				var161 = CFrame.identity
			end
		end
		arg1.VRCameraCFrame = CFrame.new(var160.Position) * (var161 - var161.Position)
		-- KONSTANTERROR: [4] 4. Error Block 23 end (CF ANALYSIS FAILED)
	end)
	RunService_upvr:BindToRenderStep("CameraController", Value_4_upvr, function(arg1_7) -- Line 573
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1._last_dt = arg1_7
		arg1:Update(arg1_7)
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Crosshair Disabled"):Connect(function() -- Line 578
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera FOV"):Connect(function() -- Line 582
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera FOV Effects"):Connect(function() -- Line 586
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Inverted X"):Connect(function() -- Line 590
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Inverted Y"):Connect(function() -- Line 594
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Shake"):Connect(function() -- Line 598
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Sensitivity"):Connect(function() -- Line 602
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Sensitivity ADS"):Connect(function() -- Line 606
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Zoom Effects"):Connect(function() -- Line 610
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Gamepad Deadzone"):Connect(function() -- Line 614
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Sensitivity X"):Connect(function() -- Line 618
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr:GetDataChangedSignal("Settings Camera Sensitivity Y"):Connect(function() -- Line 622
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateSettings()
	end)
	PlayerDataController_upvr.SettingsSliderChanged:Connect(function(arg1_8, arg2) -- Line 626
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		if arg1_8 == "Settings Camera FOV" then
			arg1._base_fov = arg2
		end
	end)
	arg1:_Setup()
	arg1:_UpdateSettings()
end
return module_upvr._new()
