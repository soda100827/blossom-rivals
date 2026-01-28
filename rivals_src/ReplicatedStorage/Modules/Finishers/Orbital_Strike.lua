local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("TweenService")
local v_u_3 = game:GetService("RunService")
local v_u_4 = require(v1.Modules.BetterDebris)
local v_u_5 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.Utility)
local v_u_6 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local v_u_7 = TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
local v_u_8 = setmetatable({}, v_u_5)
v_u_8.__index = v_u_8
function v_u_8.new(...)
    local v9 = v_u_5.new(...)
    local v10 = v_u_8
    local v11 = setmetatable(v9, v10)
    v11:_Init()
    return v11
end
function v_u_8.PlayServer(p12, ...)
    v_u_5.PlayServer(p12, ...)
    local v13 = Instance.new("BodyVelocity")
    v13.MaxForce = Vector3.new(0, 10000, 0)
    v13.Velocity = Vector3.new(0, -100, 0)
    v13.Parent = p12._is_humanoid and p12._subject.RootPart or p12._subject
    v_u_4:AddItem(v13, 3)
end
function v_u_8.PlayClient(p14, ...)
    v_u_5.PlayClient(p14, ...)
    local v15 = p14._is_humanoid and p14._subject.RootPart or p14._subject
    local v16 = p14:_GetGroundPosition(v15.Position, { p14._is_humanoid and p14._subject.Parent or p14._subject })
    for _, v17 in pairs(p14:_GetObjects(true)) do
        if v17:IsA("BasePart") and v17 ~= v15 then
            v17:Destroy()
        end
    end
    v15.Size = Vector3.new(0, 0, 0)
    local v_u_18 = script.DustPile:Clone()
    v_u_18.Anchored = true
    v_u_18.Size = Vector3.new(0, 0, 0)
    v_u_18.CFrame = CFrame.new(v16) * CFrame.new(0, v_u_18.Size.Y / 2, 0)
    v_u_18.CollisionGroup = "IgnoreEntities"
    v_u_18.Parent = v15
    local v19 = p14._destroy_these
    table.insert(v19, v_u_18)
    v_u_2:Create(v_u_18, v_u_6, {
        ["Size"] = script.DustPile.Size
    }):Play()
    local v_u_20 = script.Particles:Clone()
    v_u_20.Parent = v_u_18
    local v21 = p14._destroy_these
    table.insert(v21, v_u_20)
    local v22 = v_u_3.RenderStepped:Connect(function()
        v_u_20.CFrame = CFrame.new(v_u_18.Position + Vector3.new(0, 1, 0))
    end)
    local v23 = p14._connections
    table.insert(v23, v22)
    p14:CreateSound("rbxassetid://118654142384127", 1.25, 0.95 + 0.1 * math.random(), v_u_20, true, 10)
    wait(1)
    v22:Disconnect()
    for _, v24 in pairs(v_u_20:GetDescendants()) do
        if v24:IsA("ParticleEmitter") or v24:IsA("Beam") then
            v24.Enabled = false
        end
    end
    v_u_18.Smoke.smoke1.Enabled = false
    v_u_18.Smoke.smoke2.Enabled = false
    wait(1)
    v_u_20:Destroy()
    wait(1)
    v_u_2:Create(v_u_18, v_u_7, {
        ["Size"] = Vector3.new(0, 0, 0)
    }):Play()
    wait(1)
end
function v_u_8._Init(_) end
return v_u_8