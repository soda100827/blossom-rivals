-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:16:39
-- Luau version 6, Types version 3
-- Time taken: 0.007456 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService_upvr = game:GetService("UserInputService")
local tbl_upvr_3 = {
	Desktop = "MouseKeyboard",
	Mobile = "Touch",
	Console = "Gamepad",
	VR = "VR",
}
local tbl_upvr = {
	[Enum.UserInputType.MouseButton1] = "MouseKeyboard",
	[Enum.UserInputType.MouseButton2] = "MouseKeyboard",
	[Enum.UserInputType.MouseButton3] = "MouseKeyboard",
	[Enum.UserInputType.Keyboard] = "MouseKeyboard",
	[Enum.UserInputType.Touch] = "Touch",
	[Enum.UserInputType.Gamepad1] = "Gamepad",
	[Enum.UserInputType.Gamepad2] = "Gamepad",
	[Enum.UserInputType.Gamepad3] = "Gamepad",
	[Enum.UserInputType.Gamepad4] = "Gamepad",
	[Enum.UserInputType.Gamepad5] = "Gamepad",
	[Enum.UserInputType.Gamepad6] = "Gamepad",
	[Enum.UserInputType.Gamepad7] = "Gamepad",
	[Enum.UserInputType.Gamepad8] = "Gamepad",
}
local tbl_upvr_2 = {
	[Enum.KeyCode.W] = "MouseKeyboard",
	[Enum.KeyCode.A] = "MouseKeyboard",
	[Enum.KeyCode.S] = "MouseKeyboard",
	[Enum.KeyCode.D] = "MouseKeyboard",
}
local module_upvr = {}
module_upvr.__index = module_upvr
local Signal_upvr = require(ReplicatedStorage.Modules.Signal)
local CONSTANTS_upvr = require(ReplicatedStorage.Modules.CONSTANTS)
function module_upvr._new() -- Line 27
	--[[ Upvalues[4]:
		[1]: module_upvr (readonly)
		[2]: Signal_upvr (readonly)
		[3]: tbl_upvr_3 (readonly)
		[4]: CONSTANTS_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.ControlsChanged = Signal_upvr.new()
	setmetatable_result1.InputBegan = Signal_upvr.new()
	setmetatable_result1.InputChanged = Signal_upvr.new()
	setmetatable_result1.InputEnded = Signal_upvr.new()
	setmetatable_result1.CurrentControls = tbl_upvr_3[CONSTANTS_upvr.DEVICE]
	setmetatable_result1._toggled_inputs = {}
	setmetatable_result1._is_verification_disabled = false
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function module_upvr.IsInputDown(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	local var10
	local function INLINED() -- Internal function, doesn't exist in bytecode
		var10 = UserInputService_upvr:IsKeyDown(arg2)
		return var10
	end
	local function INLINED_2() -- Internal function, doesn't exist in bytecode
		var10 = UserInputService_upvr:IsMouseButtonPressed(arg2)
		return var10
	end
	if arg2.EnumType ~= Enum.KeyCode or not INLINED() or arg2.EnumType ~= Enum.UserInputType or not INLINED_2() then
		local function INLINED_3() -- Internal function, doesn't exist in bytecode
			var10 = UserInputService_upvr:IsGamepadButtonDown(UserInputService_upvr:GetLastInputType(), arg2)
			return var10
		end
		if
			arg2.EnumType ~= Enum.KeyCode
			or arg1.CurrentControls ~= "Gamepad" and arg1.CurrentControls ~= "VR"
			or not INLINED_3()
		then
			var10 = arg1:IsToggled(arg2)
		end
	end
	return var10
end
function module_upvr.IsToggled(arg1, arg2) -- Line 58
	return arg1._toggled_inputs[arg2]
end
function module_upvr.ToggleInput(arg1, arg2, arg3) -- Line 63
	arg1._toggled_inputs[arg2] = arg3 or nil
end
function module_upvr.SetControls(arg1, arg2) -- Line 67
	if not arg2 or arg2 == arg1.CurrentControls then
	else
		if arg2 == "VR" or arg1.CurrentControls == "VR" then
			return
		end
		arg1.CurrentControls = arg2
		arg1.ControlsChanged:Fire()
	end
end
function module_upvr.DisableVerification(arg1, arg2) -- Line 81
	arg1._is_verification_disabled = arg2
end
local Utility_upvr = require(ReplicatedStorage.Modules.Utility)
function module_upvr._VerifyControls(arg1, arg2, arg3) -- Line 89
	--[[ Upvalues[3]:
		[1]: Utility_upvr (readonly)
		[2]: tbl_upvr (readonly)
		[3]: tbl_upvr_2 (readonly)
	]]
	if arg1._is_verification_disabled or arg3 or Utility_upvr:IsTextBoxFocused() then
	else
		if arg2.KeyCode == Enum.KeyCode.Thumbstick1 or arg2.KeyCode == Enum.KeyCode.Thumbstick2 then
			if (arg2.Position * Vector3.new(1, 1, 0)).Magnitude < 0.75 then
				return
			end
		end
		local var12 = tbl_upvr[arg2.UserInputType]
		if not var12 then
			var12 = tbl_upvr_2[arg2.KeyCode]
		end
		arg1:SetControls(var12)
	end
end
function module_upvr._Init(arg1) -- Line 102
	--[[ Upvalues[1]:
		[1]: UserInputService_upvr (readonly)
	]]
	UserInputService_upvr.InputBegan:Connect(function(...) -- Line 103
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_VerifyControls(...)
		arg1.InputBegan:Fire(...)
	end)
	UserInputService_upvr.InputChanged:Connect(function(...) -- Line 108
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_VerifyControls(...)
		arg1.InputChanged:Fire(...)
	end)
	UserInputService_upvr.InputEnded:Connect(function(...) -- Line 113
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_VerifyControls(...)
		arg1.InputEnded:Fire(...)
	end)
end
return module_upvr._new()
