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
function v_u_4.PlayClient(p8)
    local v_u_9 = p8._is_humanoid and p8._subject.RootPart or p8._subject
    local v_u_10 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_11 = script.Model:Clone()
    v_u_11.Parent = workspace
    local v12 = p8._destroy_these
    table.insert(v12, v_u_11)
    local v13 = v_u_2.RenderStepped:Connect(function()
        v_u_11:PivotTo(CFrame.new(v_u_9.Position) * v_u_10 * CFrame.Angles(1.5707963267948966, 0, 0))
    end)
    local v14 = p8._connections
    table.insert(v14, v13)
    local v15, v16 = pcall(v_u_11.AnimationController.LoadAnimation, v_u_11.AnimationController, v_u_11.Animation)
    if v15 then
        v16:Play(0)
        wait(0.65)
        p8:CreateSound("rbxassetid://121251326830312", 1.25, 1, nil, true, 5)
        wait(0.1)
        local v17 = {}
        for _, v18 in pairs(p8:_GetObjects(true)) do
            if v18:IsA("BasePart") or (v18:IsA("Decal") or (v18:IsA("Texture") or (v18:IsA("Beam") or (v18:IsA("ParticleEmitter") or v18:IsA("Trail"))))) then
                v17[v18] = true
            end
        end
        local v19 = tick()
        while tick() < v19 + 0.75 do
            local v20 = (tick() - v19) / 0.75
            local v21 = math.clamp(v20, 0, 1)
            for v22 in pairs(v17) do
                v22.LocalTransparencyModifier = v21
            end
            v_u_2.RenderStepped:Wait()
        end
        for v23 in pairs(v17) do
            v23.LocalTransparencyModifier = 1
        end
        if v16.IsPlaying then
            v16.Stopped:Wait()
        end
    end
    v_u_11:Destroy()
    v13:Disconnect()
end
function v_u_4._Init(_) end
return v_u_4