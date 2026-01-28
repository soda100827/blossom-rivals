local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = require(v1.Modules.Utility)
local v_u_4 = setmetatable({}, v_u_2)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_2.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayClient(p8, ...)
    v_u_2.PlayClient(p8, ...)
    local v9 = script.Particles.Attachment:Clone()
    v9.Parent = p8._is_humanoid and p8._subject.Parent.UpperTorso or p8._subject
    local v10 = p8._destroy_these
    table.insert(v10, v9)
    for _, v11 in pairs(v9:GetChildren()) do
        if v11:IsA("ParticleEmitter") then
            v_u_3:ScaleParticleEmitter(v11, 0.25)
        end
    end
    v_u_3:PlayParticles(v9)
    wait(0.5)
    for v12 = 1, 3 do
        p8:CreateSound("rbxassetid://127325407221199", 1.5 - 0.25 * v12, 1, nil, true, 5)
        wait(0.9)
    end
    p8:CreateSound("rbxassetid://106567630436220", 0.75, 1, nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4