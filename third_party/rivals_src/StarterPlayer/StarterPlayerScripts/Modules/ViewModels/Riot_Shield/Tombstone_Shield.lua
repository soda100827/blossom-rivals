local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.BetterDebris)
local v_u_3 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ViewModels"):WaitForChild("Riot Shield"))
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.AbsorbedHit(p8)
    p8:CreateSound("rbxassetid://126398565710312", 1, 0.9 + 0.2 * math.random(), true, 5)
end
function v_u_4._Init(_) end
return v_u_4