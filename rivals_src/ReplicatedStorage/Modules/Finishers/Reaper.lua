local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
game:GetService("Players")
local v_u_3 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.BetterDebris)
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
function v_u_5.PlayServer(p9, ...)
    local v10 = p9._is_humanoid and p9._subject.RootPart or p9._subject
    v10.Anchored = true
    wait(0.9)
    v10.Anchored = false
    local v11 = p9._is_humanoid
    if v11 then
        v11 = p9._subject.Parent:FindFirstChild("Waist", true)
    end
    if v11 then
        v11:Destroy()
    end
    v_u_3.PlayServer(p9, ...)
    local v12 = p9._is_humanoid
    if v12 then
        v12 = p9._subject.Parent:FindFirstChild("UpperTorso")
    end
    if v12 then
        local v13 = Random.new():NextUnitVector() * Vector3.new(1, 0, 1)
        local v14 = math.random()
        v12.Velocity = (v13 + Vector3.new(0, v14, 0)) * (50 + 150 * math.random())
    end
end
function v_u_5.PlayClient(p15)
    local v_u_16 = p15._is_humanoid and p15._subject.RootPart or p15._subject
    local v_u_17 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    if p15._is_humanoid then
        local v18 = Instance.new("Animation")
        v18.AnimationId = "rbxassetid://4769412289"
        local v19, v20 = pcall(p15._subject.LoadAnimation, p15._subject, v18)
        if v19 then
            v20:Play(0)
            v20:AdjustSpeed(0.16666666666666666)
        end
    end
    local v_u_21 = script.Model:Clone()
    v_u_21.Parent = workspace
    local v22 = p15._destroy_these
    table.insert(v22, v_u_21)
    local v23 = v_u_2.RenderStepped:Connect(function()
        v_u_21:PivotTo(CFrame.new(v_u_16.Position) * v_u_17)
    end)
    local v24 = p15._connections
    table.insert(v24, v23)
    local v25, v26 = pcall(v_u_21.AnimationController.LoadAnimation, v_u_21.AnimationController, v_u_21.Animation)
    if v25 then
        v26:Play(0)
        p15:CreateSound("rbxassetid://85156927480464", 2, 1, nil, true, 5)
        wait(0.7)
        p15:CreateSound("rbxassetid://14111617408", 2, 1, nil, true, 5)
        p15:CreateSound("rbxassetid://14111617269", 1.5, 1, nil, true, 5)
        wait(0.2)
        v_u_4:PlayParticles(v_u_21.HumanoidRootPart.Particles)
        if v26.IsPlaying then
            v26.Stopped:Wait()
        end
        v_u_21:Destroy()
        wait(3)
    end
    v23:Disconnect()
end
function v_u_5._Init(_) end
return v_u_5