local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = Color3.fromRGB(221, 221, 221)
local v_u_4 = Color3.fromRGB(27, 42, 53)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = require(v1.Modules.Finishers.Ragdoll)
local v_u_7 = setmetatable({}, v_u_6)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_6.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayClient(p_u_11, ...)
    v_u_6.PlayClient(p_u_11, ...)
    local v_u_12 = script.Model:Clone()
    v_u_12.Parent = workspace
    local v13 = p_u_11._destroy_these
    table.insert(v13, v_u_12)
    local v_u_14 = p_u_11._is_humanoid and p_u_11._subject.RootPart or p_u_11._subject
    local v_u_15 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v16 = v_u_2.Heartbeat:Connect(function()
        v_u_12:PivotTo(CFrame.new(v_u_14.Position) * v_u_15)
    end)
    local v17 = p_u_11._connections
    table.insert(v17, v16)
    local v18, v19 = pcall(v_u_12.AnimationController.LoadAnimation, v_u_12.AnimationController, v_u_12.Animation)
    if v18 then
        v19:Play(0)
        wait(1.375)
        v_u_12.Cloud.vfx.water1.Enabled = true
        v_u_12.Cloud.vfx2.water2.Enabled = true
        v_u_12.Cloud.ground.ring1.Enabled = true
        v_u_12.Cloud.ground.splash1.Enabled = true
        p_u_11:_InternalThread(task.spawn, v_u_5.RenderstepForLoop, v_u_5, 0, 100, 2, function(p20)
            local v21 = 1 - (1 - p20 / 100) ^ 2
            v_u_12.Cloud.Color = v_u_3:Lerp(v_u_4, v21)
        end)
        p_u_11:_InternalThread(task.defer, function()
            wait(0.5)
            v_u_5:PlayParticles(v_u_12.Cloud.Thunder)
            p_u_11:CreateSound("rbxassetid://79197041664081", 1.5, 0.75 + 0.25 * math.random(), nil, true, 5)
            wait(1)
            v_u_5:PlayParticles(v_u_12.Cloud.Thunder)
            p_u_11:CreateSound("rbxassetid://79197041664081", 1.5, 0.75 + 0.25 * math.random(), nil, true, 5)
            wait(0.3)
            v_u_5:PlayParticles(v_u_12.Cloud.Thunder)
            p_u_11:CreateSound("rbxassetid://79197041664081", 1.5, 0.75 + 0.25 * math.random(), nil, true, 5)
        end)
        p_u_11:CreateSound("rbxassetid://114760171297145", 2, 1, nil, true, 5)
        wait(2.75)
        v_u_12.Cloud.vfx.water1.Enabled = false
        v_u_12.Cloud.vfx2.water2.Enabled = false
        v_u_12.Cloud.ground.ring1.Enabled = false
        v_u_12.Cloud.ground.splash1.Enabled = false
        p_u_11:_InternalThread(task.spawn, v_u_5.RenderstepForLoop, v_u_5, 0, 100, 2, function(p22)
            local v23 = (p22 / 100) ^ 2
            v_u_12.Cloud.Color = v_u_4:Lerp(v_u_3, v23)
        end)
        wait(1)
    end
    v_u_12:Destroy()
end
function v_u_7._Init(_) end
return v_u_7