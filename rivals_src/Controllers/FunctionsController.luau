-- Decompiled with Konstant V2.1, a fast Luau decompiler made in Luau by plusgiant5 (https://discord.gg/brNTY8nX8t)
-- Decompiled on 2026-01-28 07:17:28
-- Luau version 6, Types version 3
-- Time taken: 0.003161 seconds

local ReplicatedStorage_upvr = game:GetService("ReplicatedStorage")
local EnumLibrary_upvr = require(ReplicatedStorage_upvr.Modules.EnumLibrary)
local module_upvr = {}
module_upvr.__index = module_upvr
function module_upvr._new() -- Line 12
	--[[ Upvalues[1]:
		[1]: module_upvr (readonly)
	]]
	local setmetatable_result1 = setmetatable({}, module_upvr)
	setmetatable_result1:_Init()
	return setmetatable_result1
end
local Functions_upvr = game:GetService("Players").LocalPlayer.PlayerScripts.Modules:WaitForChild("Functions")
function module_upvr.FireAsync(arg1, arg2, ...) -- Line 24
	--[[ Upvalues[2]:
		[1]: Functions_upvr (readonly)
		[2]: EnumLibrary_upvr (readonly)
	]]
	require(Functions_upvr[EnumLibrary_upvr:FromEnum(arg2)])(...)
end
function module_upvr.FireSync(arg1, ...) -- Line 29
	task.spawn(arg1.FireAsync, arg1, ...)
end
function module_upvr._Init(arg1) -- Line 37
	--[[ Upvalues[2]:
		[1]: ReplicatedStorage_upvr (readonly)
		[2]: EnumLibrary_upvr (readonly)
	]]
	ReplicatedStorage_upvr.Remotes.Misc.TeleportFailed.OnClientEvent:Connect(function(arg1_2) -- Line 38
		--[[ Upvalues[2]:
			[1]: arg1 (readonly)
			[2]: EnumLibrary_upvr (copied, readonly)
		]]
		arg1:FireAsync(EnumLibrary_upvr:ToEnum("SendChat"), {
			Text = "[SERVER] Teleport failed, please try again. Error: " .. tostring(arg1_2),
			Color = Color3.fromRGB(255, 50, 50),
		})
	end)
	ReplicatedStorage_upvr.Remotes.Misc.Functions.OnClientEvent:Connect(function(...) -- Line 47
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:FireAsync(...)
	end)
	ReplicatedStorage_upvr.Remotes.Misc.FunctionsUnreliable.OnClientEvent:Connect(function(...) -- Line 51
		--[[ Upvalues[1]:
			[1]: arg1 (readonly)
		]]
		arg1:FireAsync(...)
	end)
end
return module_upvr._new()
