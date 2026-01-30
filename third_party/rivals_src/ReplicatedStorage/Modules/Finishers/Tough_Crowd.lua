local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = {
    38,
    93,
    113,
    125,
    130,
    139,
    150
}
local v_u_7 = setmetatable({}, v_u_3)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_3.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayClient(p_u_11, ...)
    v_u_3.PlayClient(p_u_11, ...)
    local v_u_12 = p_u_11._is_humanoid and p_u_11._subject.RootPart or p_u_11._subject
    local v_u_13 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_14 = script.Model:Clone()
    v_u_14.Parent = workspace
    local v15 = p_u_11._destroy_these
    table.insert(v15, v_u_14)
    for _, v16 in pairs(v_u_14.HumanoidRootPart.Attachment:GetChildren()) do
        if v16:IsA("ParticleEmitter") then
            v_u_5:ScaleParticleEmitter(v16, 2)
        end
    end
    local v17 = v_u_2.RenderStepped:Connect(function()
        v_u_14:PivotTo(CFrame.new(v_u_12.Position) * v_u_13)
    end)
    local v18 = p_u_11._connections
    table.insert(v18, v17)
    p_u_11:CreateSound("rbxassetid://99054783153991", 1, 1 + 0.05 * math.random(), nil, true, 5)
    local v19, v20 = pcall(v_u_14.AnimationController.LoadAnimation, v_u_14.AnimationController, v_u_14.Animation)
    if v19 then
        v20:Play(0)
        v20:AdjustSpeed(1.5)
        p_u_11:_InternalThread(task.spawn, function()
            local v21 = 0
            for v22, v23 in pairs(v_u_6) do
                v21 = v21 + wait((v23 - 1 * v22) / 60 / 1.5 - v21)
                local v24 = v_u_14.HumanoidRootPart.Attachment
                local v25 = math.random() - 0.5
                local v26 = math.random() - 0.5
                local v27 = math.random() - 0.5
                v24.Position = Vector3.new(v25, v26, v27) * 5
                v_u_5:PlayParticles(v_u_14.HumanoidRootPart.Attachment)
                p_u_11:CreateSound("rbxassetid://11170608962", 0.75, 1 + 0.125 * v22, nil, true, 5)
                p_u_11:CreateSound("rbxassetid://14796313153", 1, 1 + 0.125 * v22, nil, true, 5)
            end
        end)
        if v20.IsPlaying then
            v20.Stopped:Wait()
        end
    end
    for _, v28 in pairs(v_u_14:GetDescendants()) do
        if v28:IsA("BasePart") then
            v28.Transparency = 1
        end
    end
    v_u_4:AddItem(v_u_14, 3)
    v17:Disconnect()
end
function v_u_7._Init(_) end
return v_u_7