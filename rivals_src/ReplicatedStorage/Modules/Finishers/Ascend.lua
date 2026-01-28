local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
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
    (p9._is_humanoid and p9._subject.RootPart or p9._subject).Anchored = true
end
function v_u_5.PlayClient(p10)
    if p10._is_humanoid then
        local v11 = Instance.new("Animation")
        v11.AnimationId = "rbxassetid://134648473605383"
        local v12, v13 = pcall(p10._subject.LoadAnimation, p10._subject, v11)
        if v12 then
            v13:Play(0)
        end
    end
    local v14 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    local v15 = script.Explosion.Attachment:Clone()
    v15.Parent = v14
    v_u_4:PlayParticles(v15)
    script.Idle.Attachment:Clone().Parent = p10._is_humanoid and p10._subject.Parent.UpperTorso or p10._subject
    p10:CreateSound("rbxassetid://86210336908274", 1, 1, nil, true, 5)
    p10:CreateSound("rbxassetid://112056531317514", 1, 1, nil, true, 5)
    wait(1)
    local v16 = {}
    for _, v17 in pairs(p10:_GetObjects(true)) do
        if v17:IsA("BasePart") or (v17:IsA("Decal") or (v17:IsA("Texture") or (v17:IsA("Beam") or (v17:IsA("ParticleEmitter") or v17:IsA("Trail"))))) then
            v16[v17] = true
        end
    end
    local v18 = tick()
    while tick() < v18 + 0.3333333333333333 do
        local v19 = (tick() - v18) / 0.3333333333333333
        local v20 = 1 - (1 - math.clamp(v19, 0, 1)) ^ 3
        for v21 in pairs(v16) do
            v21.LocalTransparencyModifier = v20
        end
        v_u_2.RenderStepped:Wait()
    end
    p10:_HideBody()
end
function v_u_5._Init(_) end
return v_u_5