-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:17:18
-- Luau version 6, Types version 3
-- Time taken: 0.056903 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local Players_upvr = game:GetService("Players")
local Utility_upvr = require(ReplicatedStorage_upvr.Modules.Utility)
local ControlsController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.ControlsController)
local CameraController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Controllers.CameraController)
local ReplicatedController_upvr = require(Players_upvr.LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local setmetatable_result1_2_upvr = setmetatable({}, ReplicatedController_upvr)
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr._new() -- Line 19
	--[[ Upvalues[2]:
		[1]: ReplicatedController_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(ReplicatedController_upvr.new("Fighter"), setmetatable_result1_2_upvr)
	setmetatable_result1.LocalFighter = nil
	setmetatable_result1._network_id_map = {}
	setmetatable_result1._last_encoded_camera_rotation = nil
	setmetatable_result1._last_connection_level = nil
	setmetatable_result1._player_to_fighter = {}
	setmetatable_result1._model_to_fighter = {}
	setmetatable_result1._last_controls_replicated_time = 0
	setmetatable_result1._character_model_cache = {}
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetFighter(arg1, arg2) -- Line 42
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	-- KONSTANTWARNING: Variable analysis failed. Output will have some incorrect variable assignments
	local var17 = arg1._player_to_fighter[arg2]
	if not var17 then
		var17 = arg1._model_to_fighter[arg2]
	end
	if var17 then
		return var17
	end
	if not arg2 then
	else
		if typeof(arg2) == "Instance" then
			if arg2:IsA("Player") then
				for i_10, v_10 in pairs(arg1.Objects) do
					if v_10.Player == arg2 then
						return v_10, i_10
					end
				end
				return nil
			end
			return arg1:GetFighter(Players_upvr:GetPlayerFromCharacter(arg2))
		end
		if typeof(arg2) == "number" then
			return arg1:GetFighter(Players_upvr:GetPlayerByUserId(arg2))
		end
		if typeof(arg2) ~= "Instance" or not arg2.ClassName then
		end
		assert(
			false,
			"Argument 1 invalid, expected a Player or a Model or nil, got "
				.. tostring(arg2)
				.. " (type: "
				.. typeof(arg2)
				.. ")"
		)
	end
end
function setmetatable_result1_2_upvr.GetFighterFromNetworkID(arg1, arg2) -- Line 72
	return arg1._network_id_map[arg2]
end
function setmetatable_result1_2_upvr.GetFightersNotInDuel(arg1) -- Line 76
	for _, v in pairs(arg1.Objects) do
		if not v:Get("IsInDuel") then
			table.insert({}, v)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function setmetatable_result1_2_upvr.GetEntities(arg1) -- Line 88
	for _, v_2 in pairs(arg1.Objects) do
		if v_2.Entity then
			table.insert({}, v_2.Entity)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function setmetatable_result1_2_upvr.GetFighterModels(arg1, arg2) -- Line 102
	for _, v_3 in pairs(arg1.Objects) do
		if v_3.Entity and (not arg2 or not v_3.IsLocalPlayer) then
			table.insert({}, v_3.Entity.Model)
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
function setmetatable_result1_2_upvr.WaitForFighter(arg1, ...) -- Line 117
	while true do
		local any_GetFighter_result1 = arg1:GetFighter(...)
		if any_GetFighter_result1 then
			return any_GetFighter_result1
		end
		arg1.ObjectAdded:Wait()
	end
end
function setmetatable_result1_2_upvr.WaitForLocalFighter(arg1) -- Line 129
	--[[ Upvalues[1]:
		[1]: Players_upvr (readonly)
	]]
	return arg1:WaitForFighter(Players_upvr.LocalPlayer)
end
local DefaultCharacter_upvr =
	Players_upvr.LocalPlayer.PlayerScripts.Assets:WaitForChild("Misc"):WaitForChild("DefaultCharacter")
function setmetatable_result1_2_upvr.GenerateCharacterModel(arg1, arg2, arg3) -- Line 133
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: DefaultCharacter_upvr (readonly)
	]]
	if arg1._character_model_cache[tostring(arg2)] then
		return arg1._character_model_cache[tostring(arg2)]
	end
	local function generate() -- Line 138
		--[[ Upvalues[3]:
			[1]: Players_upvr (copied, readonly)
			[2]: arg2 (readonly)
			[3]: arg1 (readonly)
		]]
		local pcall_result1_2, pcall_result2_2 =
			pcall(Players_upvr.GetHumanoidDescriptionFromUserId, Players_upvr, arg2)
		if not pcall_result1_2 then
			warn("Failed to fetch humanoid description:", pcall_result2_2)
			return
		end
		pcall_result2_2.Head = 2432102561
		pcall_result2_2.Torso = 15365012259
		pcall_result2_2.LeftArm = 15365010034
		pcall_result2_2.RightArm = 15365012263
		pcall_result2_2.LeftLeg = 15365010038
		pcall_result2_2.RightLeg = 15365010030
		local pcall_result1, pcall_result2 = pcall(
			Players_upvr.CreateHumanoidModelFromDescription,
			Players_upvr,
			pcall_result2_2,
			Enum.HumanoidRigType.R15
		)
		if not pcall_result1 then
			warn("Failed to create humanoid model:", pcall_result2)
			return
		end
		arg1._preloaded_character_model = pcall_result2
		local module = {
			Template = pcall_result2,
		}
		arg1._character_model_cache[tostring(arg2)] = module
		return module
	end
	if arg3 then
		return generate()
	end
	task.spawn(generate)
	local var43 = arg1._character_model_cache[tostring(arg2)]
	if not var43 then
		var43 = {}
		var43.Template = DefaultCharacter_upvr
	end
	return var43
end
function setmetatable_result1_2_upvr._VerifyEntityLoop(arg1) -- Line 186
	--[[ Upvalues[2]:
		[1]: Players_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	local function is_inaccurate() -- Line 187
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: Players_upvr (copied, readonly)
		]]
		local var48 = not arg1.LocalFighter:Get("IsInDuel")
		if var48 then
			var48 = not arg1.LocalFighter:Get("IsInShootingRange")
			if var48 then
				var48 = Players_upvr.LocalPlayer.Character
				if var48 then
					var48 = not arg1.LocalFighter.Entity
					if not var48 then
						if arg1.LocalFighter.Entity.Model == Players_upvr.LocalPlayer.Character then
							var48 = false
						else
							var48 = true
						end
					end
				end
			end
		end
		return var48
	end
	while wait(1) do
		if is_inaccurate() then
			wait(2)
			if is_inaccurate() then
				ReplicatedStorage_upvr.Remotes.Replication.Fighter.VerifyClientEntity:FireServer()
				wait(10)
			end
		end
	end
end
function setmetatable_result1_2_upvr._ConnectionLevelReplicationLoop(arg1) -- Line 203
	--[[ Upvalues[2]:
		[1]: Utility_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
	]]
	while true do
		wait(1)
		if arg1.LocalFighter and arg1.LocalFighter:Get("IsInDuel") then
			local any_GetConnectionLevel_result1 =
				Utility_upvr:GetConnectionLevel(Utility_upvr:GetLocalConnectionPing())
			if any_GetConnectionLevel_result1 ~= arg1._last_connection_level then
				arg1._last_connection_level = any_GetConnectionLevel_result1
				ReplicatedStorage_upvr.Remotes.Replication.Fighter.UpdateConnectionLevel:FireServer(
					any_GetConnectionLevel_result1
				)
			end
		end
	end
end
function setmetatable_result1_2_upvr._UpdateNetworkIDMap(arg1) -- Line 223
	arg1._network_id_map = {}
	for _, v_4 in pairs(arg1.Objects) do
		local any_Get_result1 = v_4:Get("DecodedNetworkID")
		if any_Get_result1 then
			arg1._network_id_map[any_Get_result1] = v_4
		end
	end
end
function setmetatable_result1_2_upvr._FighterAdded(arg1, arg2) -- Line 235
	arg2:GetDataChangedSignal("DecodedNetworkID"):Connect(function() -- Line 236
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_UpdateNetworkIDMap()
	end)
	arg2.EntityAdded:Connect(function(arg1_2) -- Line 240
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		arg1._model_to_fighter[arg1_2.Model] = arg2
	end)
	arg2.EntityRemoved:Connect(function(arg1_3) -- Line 244
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: arg2 (readonly)
		]]
		for i_5, v_5 in pairs(arg1._model_to_fighter) do
			if v_5 == arg2 then
				arg1._model_to_fighter[i_5] = nil
			end
		end
	end)
	if arg2.Entity and arg2.Entity.Model then
		arg1._model_to_fighter[arg2.Entity.Model] = arg2
	end
	arg1._player_to_fighter[arg2.Player] = arg2
	arg1:_UpdateNetworkIDMap()
end
function setmetatable_result1_2_upvr._ReplicateControls(arg1) -- Line 260
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: ControlsController_upvr (readonly)
	]]
	if not arg1.LocalFighter then
	else
		task.delay(math.max(0.2 - (tick() - arg1._last_controls_replicated_time), 0.2), function() -- Line 268
			--[[ Upvalues[2]:
				[1]: ReplicatedStorage_upvr (copied, readonly)
				[2]: ControlsController_upvr (copied, readonly)
			]]
			ReplicatedStorage_upvr.Remotes.Replication.Fighter.SetControls:FireServer(
				ControlsController_upvr.CurrentControls
			)
		end)
	end
end
function setmetatable_result1_2_upvr._CameraReplicationLoop(arg1) -- Line 273
	--[[ Upvalues[3]:
		[1]: CameraController_upvr (readonly)
		[2]: Utility_upvr (readonly)
		[3]: ReplicatedStorage_upvr (readonly)
	]]
	-- KONSTANTERROR: [0] 1. Error Block 18 start (CF ANALYSIS FAILED)
	wait(0.1)
	-- KONSTANTERROR: [0] 1. Error Block 18 end (CF ANALYSIS FAILED)
	-- KONSTANTERROR: [7] 6. Error Block 22 start (CF ANALYSIS FAILED)
	if arg1.LocalFighter:Get("IsSpectating") then
		if CameraController_upvr:GetPublicState() then
			local any_EncodeCameraRotation_result1 = Utility_upvr:EncodeCameraRotation(CameraController_upvr.Rotation)
			if arg1._replication_stopped or any_EncodeCameraRotation_result1 ~= arg1._last_encoded_camera_rotation then
				ReplicatedStorage_upvr.Remotes.Replication.Fighter.UpdateCameraRotation:FireServer(
					any_EncodeCameraRotation_result1,
					nil
				)
			end
			arg1._last_encoded_camera_rotation = any_EncodeCameraRotation_result1
			arg1._replication_stopped = false
			-- KONSTANTWARNING: GOTO [78] #53
		end
	end
	-- KONSTANTERROR: [7] 6. Error Block 22 end (CF ANALYSIS FAILED)
end
local StarterGui_upvr = game:GetService("StarterGui")
function setmetatable_result1_2_upvr._HookLocalFighter(arg1) -- Line 293
	--[[ Upvalues[3]:
		[1]: CameraController_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: StarterGui_upvr (readonly)
	]]
	arg1.LocalFighter = arg1:WaitForLocalFighter()
	local function update_third_person_overide() -- Line 296
		--[[ Upvalues[2]:
			[1]: CameraController_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
		CameraController_upvr:SetThirdPersonOverride(arg1.LocalFighter:Get("ThirdPersonOverride"))
	end
	arg1.LocalFighter:GetDataChangedSignal("ThirdPersonOverride"):Connect(update_third_person_overide)
	task.defer(update_third_person_overide)
	local BindableEvent_upvr = Instance.new("BindableEvent")
	BindableEvent_upvr.Event:Connect(function() -- Line 306
		--[[ Upvalues[1]:
			[1]: ReplicatedStorage_upvr (copied, readonly)
		]]
		ReplicatedStorage_upvr.Remotes.Replication.Fighter.ResetCharacter:FireServer()
	end)
	local var69_upvw = 0
	local function update_reset_button() -- Line 310
		--[[ Upvalues[4]:
			[1]: var69_upvw (read and write)
			[2]: StarterGui_upvr (copied, readonly)
			[3]: arg1 (readonly)
			[4]: BindableEvent_upvr (readonly)
		]]
		-- KONSTANTERROR: [0] 1. Error Block 1 start (CF ANALYSIS FAILED)
		var69_upvw += 1
		-- KONSTANTERROR: [0] 1. Error Block 1 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [33] 28. Error Block 8 start (CF ANALYSIS FAILED)
		wait(0.1)
		-- KONSTANTERROR: [33] 28. Error Block 8 end (CF ANALYSIS FAILED)
		-- KONSTANTERROR: [4] 5. Error Block 13 start (CF ANALYSIS FAILED)
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [37.1]
		-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [37.65666]
		if nil == var69_upvw then
			-- KONSTANTWARNING: Failed to evaluate expression, replaced with nil [37.5]
			if nil then
			end
			-- KONSTANTERROR: Expression was reused, decompilation is incorrect
			if not nil then
				-- KONSTANTWARNING: GOTO [33] #28
			end
			-- KONSTANTWARNING: GOTO [38] #32
		end
		-- KONSTANTERROR: [4] 5. Error Block 13 end (CF ANALYSIS FAILED)
	end
	arg1.LocalFighter:GetDataChangedSignal("IsInDuel"):Connect(update_reset_button)
	task.defer(update_reset_button)
	arg1:_ReplicateControls()
	task.defer(arg1._CameraReplicationLoop, arg1)
	task.defer(arg1._ConnectionLevelReplicationLoop, arg1)
	task.defer(arg1._VerifyEntityLoop, arg1)
end
local EnumLibrary_upvr = require(ReplicatedStorage_upvr.Modules.EnumLibrary)
function setmetatable_result1_2_upvr._Setup(arg1) -- Line 336
	--[[ Upvalues[2]:
		[1]: EnumLibrary_upvr (readonly)
		[2]: Players_upvr (readonly)
	]]
	function arg1._reject_object_added_serial_callback(arg1_4) -- Line 337
		--[[ Upvalues[2]:
			[1]: EnumLibrary_upvr (copied, readonly)
			[2]: Players_upvr (copied, readonly)
		]]
		local var72 = not arg1_4[EnumLibrary_upvr:ToEnum("Player")]
		if var72 then
			var72 = not Players_upvr:GetPlayerByUserId(arg1_4[EnumLibrary_upvr:ToEnum("UserID")])
		end
		return var72
	end
end
function setmetatable_result1_2_upvr._Init(arg1) -- Line 342
	--[[ Upvalues[3]:
		[1]: ControlsController_upvr (readonly)
		[2]: ReplicatedStorage_upvr (readonly)
		[3]: Utility_upvr (readonly)
	]]
	arg1.ObjectAdded:Connect(function(arg1_5) -- Line 343
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_FighterAdded(arg1_5)
	end)
	arg1.ObjectRemoved:Connect(function(arg1_6) -- Line 347
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		for i_6, v_6 in pairs(arg1._player_to_fighter) do
			if v_6 == arg1_6 then
				arg1._model_to_fighter[i_6] = nil
			end
		end
		for i_7, v_7 in pairs(arg1._model_to_fighter) do
			if v_7 == arg1_6 then
				arg1._model_to_fighter[i_7] = nil
			end
		end
	end)
	ControlsController_upvr.ControlsChanged:Connect(function() -- Line 361
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_ReplicateControls()
	end)
	ReplicatedStorage_upvr.Remotes.Replication.Fighter.UpdateCameraRotations.OnClientEvent:Connect(
		function(arg1_7) -- Line 365
			--[[ Upvalues[2]:
			[1]: Utility_upvr (copied, readonly)
			[2]: arg1 (readonly)
		]]
			for _, v_8 in pairs(Utility_upvr:DecodeCameraRotationBulk(arg1_7)) do
				local unpacked_value_1, unpacked_value_2, unpacked_value_3 = table.unpack(v_8)
				local any_GetFighterFromNetworkID_result1 = arg1:GetFighterFromNetworkID(unpacked_value_1)
				if any_GetFighterFromNetworkID_result1 then
					any_GetFighterFromNetworkID_result1:SetReplicate(
						"CameraRotation",
						Utility_upvr:FromXYToCameraRotation(unpacked_value_2, unpacked_value_3)
					)
				end
			end
		end
	)
	for _, v_9 in pairs(arg1.Objects) do
		task.spawn(arg1._FighterAdded, arg1, v_9)
	end
	arg1:_Setup()
	task.defer(arg1._HookLocalFighter, arg1)
end
return setmetatable_result1_2_upvr._new()
