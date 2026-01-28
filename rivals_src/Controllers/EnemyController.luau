-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:16:55
-- Luau version 6, Types version 3
-- Time taken: 0.004275 seconds

local ReplicatedController_upvr =
	require(game:GetService("Players").LocalPlayer.PlayerScripts.Modules.ReplicatedController)
local setmetatable_result1_2_upvr = setmetatable({}, ReplicatedController_upvr)
setmetatable_result1_2_upvr.__index = setmetatable_result1_2_upvr
function setmetatable_result1_2_upvr._new() -- Line 11
	--[[ Upvalues[2]:
		[1]: ReplicatedController_upvr (readonly)
		[2]: setmetatable_result1_2_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable(ReplicatedController_upvr.new("Enemy"), setmetatable_result1_2_upvr)
	setmetatable_result1._model_to_enemy = {}
	setmetatable_result1:_Init()
	return setmetatable_result1
end
function setmetatable_result1_2_upvr.GetEnemy(arg1, arg2) -- Line 26
	local var6 = arg1._model_to_enemy[arg2]
	if var6 then
		return var6
	end
	for _, v in pairs(arg1.Objects) do
		if v.Model == arg2 then
			return v
		end
	end
end
function setmetatable_result1_2_upvr.Update(arg1, arg2) -- Line 40
	for _, v_2 in pairs(arg1.Objects) do
		if v_2.Update then
			v_2:Update(arg2)
		end
	end
end
function setmetatable_result1_2_upvr._EnemyAdded(arg1, arg2) -- Line 52
	if arg2.Model then
		arg1._model_to_enemy[arg2.Model] = arg2
	end
end
local RunService_upvr = game:GetService("RunService")
function setmetatable_result1_2_upvr._Init(arg1) -- Line 58
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	arg1.ObjectAdded:Connect(function(arg1_2) -- Line 59
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:_EnemyAdded(arg1_2)
	end)
	arg1.ObjectRemoved:Connect(function(arg1_3) -- Line 63
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		for i_3, v_3 in pairs(arg1._model_to_enemy) do
			if v_3 == arg1_3 then
				arg1._model_to_enemy[i_3] = nil
			end
		end
	end)
	RunService_upvr:BindToRenderStep(
		"EnemyController",
		Enum.RenderPriority.Camera.Value + 1,
		function(arg1_4) -- Line 71
			--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
			arg1:Update(arg1_4)
		end
	)
	for _, v_4 in pairs(arg1.Objects) do
		arg1:_EnemyAdded(v_4)
	end
end
return setmetatable_result1_2_upvr._new()
