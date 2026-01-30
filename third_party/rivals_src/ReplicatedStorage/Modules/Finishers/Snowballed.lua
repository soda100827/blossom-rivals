local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = {
    50,
    55,
    57,
    58,
    62,
    63,
    75,
    78,
    104,
    107,
    111,
    115
}
local v_u_7 = { "rbxassetid://11800684674", "rbxassetid://11800684590", "rbxassetid://11800684481" }
local v_u_8 = setmetatable({}, v_u_3)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_3.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.PlayClient(p_u_12, ...)
    v_u_3.PlayClient(p_u_12, ...)
    local v_u_13 = p_u_12._is_humanoid and p_u_12._subject.RootPart or p_u_12._subject
    local v_u_14 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_15 = script.Model:Clone()
    v_u_15.Parent = workspace
    local v16 = p_u_12._destroy_these
    table.insert(v16, v_u_15)
    for _, v17 in pairs(v_u_15.HumanoidRootPart.Attachment:GetChildren()) do
        if v17:IsA("ParticleEmitter") then
            v_u_5:ScaleParticleEmitter(v17, 1.5)
        end
    end
    local v18 = v_u_2.RenderStepped:Connect(function()
        v_u_15:PivotTo(CFrame.new(v_u_13.Position) * v_u_14)
    end)
    local v19 = p_u_12._connections
    table.insert(v19, v18)
    local v20, v21 = pcall(v_u_15.AnimationController.LoadAnimation, v_u_15.AnimationController, v_u_15.Animation)
    if v20 then
        v21:Play(0)
        v21:AdjustSpeed(1)
        p_u_12:_InternalThread(task.spawn, function()
            local v22 = 0.08333333333333333
            for v23, v24 in pairs(v_u_6) do
                v22 = v22 + wait((v24 - 1 * v23) / 60 / 1 - v22)
                local v25 = v_u_15.HumanoidRootPart.Attachment
                local v26 = math.random() - 0.5
                local v27 = math.random() - 0.5
                local v28 = math.random() - 0.5
                v25.Position = Vector3.new(v26, v27, v28) * 5
                v_u_5:PlayParticles(v_u_15.HumanoidRootPart.Attachment)
                p_u_12:CreateSound(v_u_7[math.random(#v_u_7)], 0.4 + 0.4 * (v23 / #v_u_6), 0.9 + 0.2 * math.random(), nil, true, 5)
            end
        end)
        if v21.IsPlaying then
            v21.Stopped:Wait()
        end
    end
    for _, v29 in pairs(v_u_15:GetDescendants()) do
        if v29:IsA("BasePart") then
            v29.Transparency = 1
        end
    end
    v_u_4:AddItem(v_u_15, 3)
    v18:Disconnect()
end
function v_u_8._Init(_) end
return v_u_8