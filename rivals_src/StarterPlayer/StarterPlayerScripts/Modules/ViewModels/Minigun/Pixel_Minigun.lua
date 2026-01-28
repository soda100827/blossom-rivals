local v1 = game:GetService("Players")
local v_u_2 = require(v1.LocalPlayer.PlayerScripts.Modules.ViewModels.Minigun)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3._CreateMinigunShootingSounds(p7)
    local v8 = p7:CreateSound("rbxassetid://112116120783481", 8.75, 1, true)
    v8.TimePosition = 0.25 + 0.25 * math.random()
    v8.Looped = true
    return { v8 }
end
function v_u_3._CreateMinigunWindingSounds(p9)
    local v10 = p9:CreateSound("rbxassetid://111731354794881", 0.5, 1, true)
    v10.TimePosition = 2
    v10.Looped = true
    return { v10 }
end
function v_u_3._Init(_) end
return v_u_3