local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = require(v1.Modules.BetterDebris)
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = setmetatable({}, v_u_4)
v_u_6.__index = v_u_6
function v_u_6.new(...)
    local v7 = v_u_4.new(...)
    local v8 = v_u_6
    local v9 = setmetatable(v7, v8)
    v9:_Init()
    return v9
end
function v_u_6.PlayServer(p10, ...)
    v_u_4.PlayServer(p10, ...)
    local v11 = p10._is_humanoid and p10._subject.RootPart or p10._subject
    local v12 = p10._eliminator and p10._eliminator.Character
    if v12 then
        v12 = p10._eliminator.Character:FindFirstChild("HumanoidRootPart")
    end
    if v12 then
        local v13 = Instance.new("BodyVelocity")
        v13.MaxForce = Vector3.new(10000, 10000, 10000)
        v13.Velocity = CFrame.new(v12.Position, v11.Position).LookVector * 100
        v13.Parent = v11
        v_u_3:AddItem(v13, 3)
    end
end
function v_u_6.PlayClient(p14, ...)
    v_u_4.PlayClient(p14, ...)
    local v_u_15 = p14._is_humanoid and p14._subject.RootPart or p14._subject
    local v_u_16 = p14._eliminator and p14._eliminator.Character
    if v_u_16 then
        v_u_16 = p14._eliminator.Character:FindFirstChild("HumanoidRootPart")
    end
    if v_u_16 then
        local v_u_17 = script.Particles:Clone()
        v_u_17.Parent = workspace
        local v18 = p14._destroy_these
        table.insert(v18, v_u_17)
        p14:CreateSound("rbxassetid://87269038986811", 1.25, 0.95 + 0.1 * math.random(), v_u_15, true, 10)
        local v20 = v_u_2.RenderStepped:Connect(function()
            local v19 = CFrame.new(v_u_16.Position, v_u_15.Position)
            v_u_17.Hit.WorldCFrame = CFrame.new(v_u_15.Position) * v19.Rotation
            v_u_17.Start.WorldCFrame = v19 * CFrame.new(0, 0, -1)
        end)
        local v21 = p14._connections
        table.insert(v21, v20)
        local v_u_22 = {}
        for _, v23 in pairs(v_u_17:GetDescendants()) do
            if v23:IsA("Beam") then
                v_u_22[v23] = { v23.Width0, v23.Width1 }
            end
        end
        v_u_5:RenderstepForLoop(0, 1, 0.01, function(p24)
            local v25 = 1 - p24 ^ 4
            for v26, v27 in pairs(v_u_22) do
                v26.Width0 = v27[1] * v25
                v26.Width1 = v27[2] * v25
            end
        end)
        for _, v28 in pairs(v_u_17:GetDescendants()) do
            if v28:IsA("ParticleEmitter") or v28:IsA("Beam") then
                v28.Enabled = false
            end
        end
        wait(1)
        v20:Disconnect()
    end
end
function v_u_6._Init(_) end
return v_u_6