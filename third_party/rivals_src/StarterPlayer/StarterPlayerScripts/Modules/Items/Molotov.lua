local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ItemTypes.Throwable)
local v_u_5 = setmetatable({}, v_u_4)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_4.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.ReplicateFromServer(p9, p10, ...)
    if p10 == "MolotovExplode" then
        if p9:IsRendered() then
            p9.ViewModel:ExplosionEffect(..., p9.Info.FireRadius)
        end
    else
        v_u_4.ReplicateFromServer(p9, p10, ...)
        return
    end
end
function v_u_5._Init(p11)
    p11.ProjectileThrown:Connect(function(p12, _)
        v_u_3:CreateSound("rbxassetid://14812827928", 1, 1, p12, true, 10)
    end)
end
return v_u_5