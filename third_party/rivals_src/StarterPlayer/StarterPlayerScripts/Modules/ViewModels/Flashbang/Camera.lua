local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ViewModels.Flashbang)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayFlashSound(p9, p10)
    v_u_4.PlayFlashSound(p9, p10)
    v_u_3:CreateSound("rbxassetid://18763877246", 1.25, 1, p10, true, 10)
end
function v_u_5._Init(_) end
return v_u_5