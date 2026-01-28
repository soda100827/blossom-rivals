local v1 = game:GetService("ReplicatedStorage")
local v2 = game:GetService("Players")
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = require(v2.LocalPlayer.PlayerScripts.Modules.ClientReplicatedClasses.ClientEntity.ClientHumanoidEntity.ClientEnemy)
local v_u_5 = { "rbxassetid://95537657751620", "rbxassetid://79660414273289" }
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.ReplicateFromServer(p10, p11, ...)
    if p11 == "DinkEffect" then
        if p10:IsRendered() then
            v_u_3:CreateSound(v_u_5[math.random(1, #v_u_5)], 0.625 + 0.25 * math.random(), 1 + 0.5 * math.random(), p10.RootPart, true, 10)
            local v12 = v_u_3
            local v13 = p10.Model:FindFirstChild("Head")
            if v13 then
                v13 = p10.Model.Head:FindFirstChild("DinkVFX")
            end
            v12:PlayParticles(v13)
        end
    else
        v_u_4.ReplicateFromServer(p10, p11, ...)
        return
    end
end
function v_u_6._Init(_) end
return v_u_6