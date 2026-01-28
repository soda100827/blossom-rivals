-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:17:04
-- Luau version 6, Types version 3
-- Time taken: 0.009587 seconds

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 13
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local EnemyController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.EnemyController)
local FighterController_upvr = require(Players.LocalPlayer.PlayerScripts.Controllers.FighterController)
local CONSTANTS_upvr = require(ReplicatedStorage.Modules.CONSTANTS)
function module_upvr.GetScreenPoints(arg1, arg2, arg3) -- Line 25
	--[[ Upvalues[3]:
		[1]: EnemyController_upvr (readonly)
		[2]: FighterController_upvr (readonly)
		[3]: CONSTANTS_upvr (readonly)
	]]
	for _, v in pairs({ EnemyController_upvr.Objects, FighterController_upvr:GetEntities() }) do
		for _, v_2 in pairs(v) do
			if not arg3 or not v_2.AimAssistBlacklist then
				if arg2:IsValidTarget(v_2) then
					local any_GetScreenPoint_result1_2, any_GetScreenPoint_result2 = v_2:GetScreenPoint()
					if
						any_GetScreenPoint_result2
						and any_GetScreenPoint_result1_2.Z < CONSTANTS_upvr.RENDER_DISTANCE
					then
						({})[v_2] = any_GetScreenPoint_result1_2
					end
				end
			end
		end
	end
	-- KONSTANTERROR: Expression was reused, decompilation is incorrect
	return {}
end
local Utility_upvr = require(ReplicatedStorage.Modules.Utility)
function module_upvr._SetupHurtEffect(arg1, arg2) -- Line 50
	--[[ Upvalues[1]:
		[1]: Utility_upvr (readonly)
	]]
	local var35 = false
	if typeof(arg2) == "Instance" then
		var35 = arg2:IsA("Model")
	end
	assert(var35, "Argument 1 invalid, expected a Model")
	arg2:SetAttribute("PlayHurtEffect", 0)
	local var37_upvw
	arg2:GetAttributeChangedSignal("PlayHurtEffect"):Connect(function() -- Line 57
		--[[ Upvalues[3]:
			[1]: var37_upvw (read and write)
			[2]: arg2 (readonly)
			[3]: Utility_upvr (copied, readonly)
		]]
		if var37_upvw then
			var37_upvw:Destroy()
			var37_upvw = nil
		end
		local Highlight_upvr = Instance.new("Highlight")
		Highlight_upvr.Name = "HurtEffect"
		Highlight_upvr.FillColor = Color3.fromRGB(255, 255, 255)
		Highlight_upvr.OutlineColor = Color3.fromRGB(255, 100, 100)
		Highlight_upvr.DepthMode = Enum.HighlightDepthMode.Occluded
		Highlight_upvr.Adornee = arg2
		Highlight_upvr.Parent = arg2
		var37_upvw = Highlight_upvr
		Utility_upvr:RenderstepForLoop(0, 100, 1, function(arg1_2) -- Line 73
			--[[ Upvalues[2]:
				[1]: Highlight_upvr (readonly)
				[2]: var37_upvw (copied, read and write)
			]]
			if Highlight_upvr ~= var37_upvw then
				return true
			end
			local var40 = 1 - (1 - arg1_2 / 100) ^ 5
			Highlight_upvr.FillColor = Color3.fromRGB(255, 255, 255)
				:Lerp(Color3.fromRGB(255, 50, 50), math.min(1, arg1_2 / 5))
			Highlight_upvr.FillTransparency = var40
			Highlight_upvr.OutlineTransparency = var40
		end)
		Highlight_upvr:Destroy()
	end)
end
function module_upvr._SetupHurtEffects(arg1) -- Line 89
	local Model = Instance.new("Model")
	Model.Name = "HurtEffect"
	Model.Parent = workspace
	arg1:_SetupHurtEffect(Model)
	arg1:_SetupHurtEffect(workspace:WaitForChild("ViewModels"):WaitForChild("FirstPerson"))
end
function module_upvr._Init(arg1) -- Line 98
	task.spawn(arg1._SetupHurtEffects, arg1)
end
return module_upvr._new()
