local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.Finishers.Ragdoll)
local v_u_3 = setmetatable({}, v_u_2)
v_u_3.__index = v_u_3
function v_u_3.new(...)
    local v4 = v_u_2.new(...)
    local v5 = v_u_3
    local v6 = setmetatable(v4, v5)
    v6:_Init()
    return v6
end
function v_u_3.PlayClient(p7, ...)
    v_u_2.PlayClient(p7, ...)
    local v8 = p7._is_humanoid and p7._subject.Parent:FindFirstChild("UpperTorso") or p7._subject
    local v9 = script.Particles:Clone()
    v9.CFrame = v8.CFrame
    v9.Parent = p7._subject
    local v10 = p7._destroy_these
    table.insert(v10, v9)
    local v11 = Instance.new("WeldConstraint")
    v11.Part0 = v8
    v11.Part1 = v9
    v11.Parent = v9
    p7:CreateSound("rbxassetid://94428502262714", 1, 0.9 + 0.2 * math.random(), nil, true, 5)
end
function v_u_3._Init(_) end
return v_u_3