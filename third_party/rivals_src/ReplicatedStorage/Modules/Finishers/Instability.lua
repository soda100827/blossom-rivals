local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = require(v1.Modules.BetterDebris)
local v_u_3 = require(v1.Modules.Finisher)
local v_u_4 = require(v1.Modules.Utility)
local v_u_5 = setmetatable({}, v_u_3)
v_u_5.__index = v_u_5
function v_u_5.new(...)
    local v6 = v_u_3.new(...)
    local v7 = v_u_5
    local v8 = setmetatable(v6, v7)
    v8:_Init()
    return v8
end
function v_u_5.PlayServer(p9)
    p9:_BreakJoints()
    p9:_InternalThread(task.delay, 0.25, p9._BreakJoints, p9)
    p9:_AnchorModel()
    for _, v10 in pairs(p9:_GetObjects()) do
        if v10:IsA("BasePart") and v10.Name ~= "HumanoidRootPart" then
            local v11 = v10.AssemblyLinearVelocity
            local v12 = math.random() - 0.5
            local v13 = math.random()
            local v14 = math.random() - 0.5
            v10.AssemblyLinearVelocity = v11 + Vector3.new(v12, v13, v14) * 256
        end
    end
end
function v_u_5.PlayClient(p15)
    p15:CreateSound("rbxassetid://119382605046173", 1, 1 + 0.1 * math.random(), nil, true, 5)
    local v16 = script.Explosion:Clone()
    v16.CFrame = (p15._is_humanoid and p15._subject.RootPart or p15._subject).CFrame
    v16.Parent = p15._subject
    local v17 = p15._destroy_these
    table.insert(v17, v16)
    v_u_2:AddItem(v16, 5)
    v_u_4:PlayParticles(v16)
end
function v_u_5._Init(_) end
return v_u_5