local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
require(v1.Modules.EnumLibrary)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules:WaitForChild("ClientReplicatedClasses"):WaitForChild("ClientFighter"):WaitForChild("ClientItem"):WaitForChild("ClientViewModel"))
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.GetPaintballColor(_)
    return Color3.fromHSV(tick() * 2 % 1, 0.75, 1)
end
function v_u_5.PlaySplatSound(_, p9)
    v_u_3:CreateSound("rbxassetid://16835701807", 0.5, 1 + 0.4 * math.random(), p9, true, 1)
end
function v_u_5._Init(_) end
return v_u_5