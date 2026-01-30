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
    local v9 = {}
    for _, v10 in pairs(script.Particles:GetChildren()) do
        local v11 = v10:Clone()
        v11.Parent = p8._is_humanoid and p8._subject.RootPart or p8._subject
        local v12 = p8._destroy_these
        table.insert(v12, v11)
        table.insert(v9, v11)
        if v11:IsA("Attachment") then
            v11.WorldCFrame = CFrame.new(v11.WorldPosition)
        end
    end
    v_u_3:PlayParticles(v9)
    p8:CreateSound("rbxassetid://105446759660735", 1, 1 + 0.2 * math.random(), nil, true, 5)
end
function v_u_4._Init(_) end
return v_u_4