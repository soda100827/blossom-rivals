local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Finishers.Ragdoll)
require(v1.Modules.BetterDebris)
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
    wait(1.0833333333333333)
    for _, v11 in pairs(p10:_GetObjects(true)) do
        if v11:IsA("BasePart") then
            v11.Anchored = true
            v11.CanCollide = false
            v11.CollisionGroup = "Noclip"
        end
    end
end
function v_u_6.PlayClient(p12, ...)
    v_u_4.PlayClient(p12, ...)
    local v_u_13 = p12._is_humanoid and p12._subject.RootPart or p12._subject
    local v_u_14 = CFrame.Angles(0, math.random() * 3.141592653589793 * 2, 0)
    local v_u_15 = script.Model:Clone()
    v_u_15.Parent = workspace
    local v16 = p12._destroy_these
    table.insert(v16, v_u_15)
    local v17 = v_u_2.RenderStepped:Connect(function()
        v_u_15:PivotTo(CFrame.new(v_u_13.Position) * v_u_14 - Vector3.new(0, 1.5, 0))
    end)
    local v18 = p12._connections
    table.insert(v18, v17)
    p12:CreateSound("rbxassetid://85156927480464", 2, 0.75, nil, true, 5)
    local v19, v20 = pcall(v_u_15.AnimationController.LoadAnimation, v_u_15.AnimationController, v_u_15.Animation)
    if v19 then
        v20:Play(0)
        wait(1.0833333333333333)
        p12:CreateSound("rbxassetid://4164190231", 1, 1, nil, true, 5)
        local v21 = Instance.new("Camera")
        local v22 = script.Flattened:Clone()
        v22.CFrame = CFrame.new(v_u_13.Position)
        v22.Parent = workspace
        local v23 = p12._destroy_these
        table.insert(v23, v22)
        for _, v24 in pairs(v22:GetDescendants()) do
            if v24:IsA("ParticleEmitter") then
                v_u_5:ScaleParticleEmitter(v24, 2)
            end
        end
        v_u_5:PlayParticles(v22)
        local v25 = v22.SurfaceGui
        v25.ViewportFrame.CurrentCamera = v21
        v25.Adornee = v22
        v25.Parent = v_u_3.LocalPlayer.PlayerGui
        local v26 = p12._destroy_these
        table.insert(v26, v25)
        local v27 = p12._is_humanoid and p12._subject.Parent or p12._subject
        v27.Archivable = true
        local v28 = v27:Clone()
        v28:PivotTo(v28:GetPivot().Rotation)
        v28.Parent = v25.ViewportFrame
        v21.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 3.141592653589793)
        v21.FieldOfView = 30
        v21.Parent = v25.ViewportFrame
        for _, v29 in pairs(v27:GetDescendants()) do
            if v29:IsA("BasePart") then
                v29.Transparency = 1
            elseif v29:IsA("ParticleEmitter") or (v29:IsA("Beam") or (v29:IsA("Trail") or v29:IsA("Decal"))) then
                v29:Destroy()
            end
        end
        if v20.IsPlaying then
            v20.Stopped:Wait()
        end
        v_u_15:Destroy()
        wait(3)
    end
    v17:Disconnect()
end
function v_u_6._Init(_) end
return v_u_6