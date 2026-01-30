local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = setmetatable({}, v_u_3)
v_u_4.__index = v_u_4
function v_u_4.new(...)
    local v5 = v_u_3.new(...)
    local v6 = v_u_4
    local v7 = setmetatable(v5, v6)
    v7:_Init()
    return v7
end
function v_u_4.PlayClient(p8, ...)
    v_u_3.PlayClient(p8, ...)
    wait(0.25)
    local v9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v10 = script.Chalk:Clone()
    v10.CFrame = CFrame.new(v9.Position) * CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0) + Vector3.new(0, 2, 0)
    v10.BodyGyro.CFrame = v10.CFrame
    v10.Top.LocalTransparencyModifier = 1
    v10.Bottom.LocalTransparencyModifier = 1
    v10.Parent = workspace
    local v11 = p8._destroy_these
    table.insert(v11, v10)
    for _, v12 in pairs(p8:_GetObjects(true)) do
        if v12:IsA("BasePart") then
            local v13 = Instance.new("NoCollisionConstraint")
            v13.Part0 = v10
            v13.Part1 = v12
            v13.Parent = v10
        end
    end
    wait(0.25)
    local v14 = tick()
    while tick() < v14 + 0.5 do
        local v15 = (tick() - v14) / 0.5
        local v16 = math.clamp(v15, 0, 1)
        local v17 = 1 - (1 - v16) ^ 5
        for _, v18 in pairs(p8:_GetObjects(true)) do
            if v18:IsA("BasePart") or (v18:IsA("Decal") or (v18:IsA("Texture") or (v18:IsA("Beam") or (v18:IsA("ParticleEmitter") or v18:IsA("Trail"))))) then
                v18.LocalTransparencyModifier = v17
            end
        end
        v10.Top.LocalTransparencyModifier = 1 - v16 ^ 5
        v10.Bottom.LocalTransparencyModifier = 1 - v16 ^ 5
        v_u_2.RenderStepped:Wait()
    end
    wait(15)
end
function v_u_4._Init(_) end
return v_u_4