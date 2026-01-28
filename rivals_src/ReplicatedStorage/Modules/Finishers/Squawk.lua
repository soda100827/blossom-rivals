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
function v_u_4.PlayClient(p8)
    p8:_HideBody()
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v10 = script.Particles:Clone()
    v10.CFrame = v9.CFrame
    v10.Parent = workspace
    local v11 = p8._destroy_these
    table.insert(v11, v10)
    v_u_3:PlayParticles(v10)
    p8:CreateSound("rbxassetid://91581971640099", 1, 1, nil, true, 5)
    p8:CreateSound("rbxassetid://90656022565955", 1.5, 1, nil, true, 5)
    p8:CreateSound("rbxassetid://108364426842582", 1.5, 1, nil, true, 5)
    wait(3)
end
function v_u_4._Init(_) end
return v_u_4