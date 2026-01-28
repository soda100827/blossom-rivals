-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:29:33
-- Luau version 6, Types version 3
-- Time taken: 0.003366 seconds

local tbl_upvr = {
	"FlickeringLights",
	"SmokeClouds",
	"FireHitboxes",
	"CustomKnockbackParts",
	"UISparkleEffects",
	"UILoadingDots",
	"UIBackgrounds",
	"UIInputFrames",
	"UIKeybinds",
	"OpenPagePrompts",
	"SnowballPrompts",
	"OutOfBoundsParts",
	"UserIDsFilter",
	"JumpPads",
	"SubspaceTripmines",
	"UIShinyTexts",
	"UIGlitchEffects",
	"PortalModels",
	"Vortexes",
	"OneWayFloors",
}
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 17
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1.Components = {}
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local GameComponents_upvr = game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("GameComponents")
function module_upvr._Setup(arg1) -- Line 37
	--[[ Upvalues[2]:
		[1]: tbl_upvr (readonly)
		[2]: GameComponents_upvr (readonly)
	]]
	for _, v_upvr in pairs(tbl_upvr) do
		task.spawn(function() -- Line 39
			--[[ Upvalues[3]:
				[1]: arg1 (readonly)
				[2]: v_upvr (readonly)
				[3]: GameComponents_upvr (copied, readonly)
			]]
			arg1.Components[v_upvr] = require(GameComponents_upvr:WaitForChild(v_upvr))
		end)
	end
end
local RunService_upvr = game:GetService("RunService")
function module_upvr._Init(arg1) -- Line 45
	--[[ Upvalues[1]:
		[1]: RunService_upvr (readonly)
	]]
	RunService_upvr:BindToRenderStep("GameComponentsController", 1, function(arg1_2) -- Line 46
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		for _, v_2 in pairs(arg1.Components) do
			if v_2.Update then
				v_2:Update(arg1_2)
			end
		end
	end)
	arg1:_Setup()
end
return module_upvr._new()
