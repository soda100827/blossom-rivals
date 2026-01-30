local v1 = game:GetService("ReplicatedStorage")
require(v1.Modules.CONSTANTS)
local v_u_2 = require(v1.Modules.Finisher)
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
function v_u_4.PlayServer(p8)
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v10 = Instance.new("Attachment")
    v10.Parent = v9
    local v11 = Instance.new("AngularVelocity")
    v11.MaxTorque = 10000
    v11.AngularVelocity = Random.new():NextUnitVector() * 5
    v11.Attachment0 = v10
    v11.Parent = v9
    local v12 = p8._destroy_these
    table.insert(v12, v11)
    local v13 = script.Guide:Clone()
    local v14 = v13.BodyForce
    local v15 = workspace.Gravity * v13:GetMass() * 0.875
    v14.Force = Vector3.new(0, v15, 0)
    v13.CFrame = v9.CFrame
    for _, v16 in pairs(p8:_GetObjects(true)) do
        if v16:IsA("BasePart") then
            v16.Massless = true
            local v17 = Instance.new("NoCollisionConstraint")
            v17.Part0 = v13
            v17.Part1 = v16
            v17.Parent = v13
        end
    end
    local v18 = Instance.new("Attachment")
    v18.Parent = v9
    local v19 = Instance.new("AlignPosition")
    v19.Attachment0 = v18
    v19.Attachment1 = v13.Attachment
    v19.MaxForce = 1000000
    v19.MaxVelocity = 32
    v19.Parent = v13
    v13.Parent = workspace
    local v20 = p8._destroy_these
    table.insert(v20, v13)
    v_u_3:Knockback(v13, Random.new():NextUnitVector() * Vector3.new(1, 0, 1) * 10 + Vector3.new(0, 15, 0))
    p8:_Ragdoll()
end
function v_u_4.PlayClient(p21)
    p21:CreateSound("rbxassetid://115089214845604", 1, 1 + 0.1 * math.random(), nil, true, 10)
end
function v_u_4._Init(_) end
return v_u_4