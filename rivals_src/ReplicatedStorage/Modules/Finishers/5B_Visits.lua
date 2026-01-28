local v1 = game:GetService("ReplicatedStorage")
local v_u_2 = game:GetService("RunService")
local v_u_3 = game:GetService("Players")
local v_u_4 = require(v1.Modules.Finisher)
local v_u_5 = require(v1.Modules.Utility)
local v_u_6 = CFrame.Angles(0, 3.141592653589793, 0) * CFrame.Angles(1.5707963267948966, 0, 1.5707963267948966) * CFrame.Angles(0, -1.5707963267948966, 0)
local v_u_7 = setmetatable({}, v_u_4)
v_u_7.__index = v_u_7
function v_u_7.new(...)
    local v8 = v_u_4.new(...)
    local v9 = v_u_7
    local v10 = setmetatable(v8, v9)
    v10:_Init()
    return v10
end
function v_u_7.PlayServer(p11, ...)
    v_u_4.PlayServer(p11, ...);
    (p11._is_humanoid and p11._subject.RootPart or p11._subject).Anchored = true
    wait(3.15)
    for _, v12 in pairs(p11:_GetObjects(true)) do
        if v12:IsA("BasePart") then
            v12.Anchored = true
            v12.CanCollide = false
            v12.CollisionGroup = "Noclip"
        end
    end
end
function v_u_7.PlayClient(p_u_13)
    local v_u_14 = p_u_13._is_humanoid and p_u_13._subject.RootPart or p_u_13._subject
    if p_u_13._is_humanoid then
        pcall(function()
            local v15 = Instance.new("Animation")
            v15.AnimationId = "rbxassetid://102021872417441"
            p_u_13._subject:LoadAnimation(v15):Play()
        end)
    end
    local v_u_16 = nil
    local v_u_17 = script:WaitForChild("Sign"):Clone()
    v_u_17.Parent = workspace
    local v18 = p_u_13._destroy_these
    table.insert(v18, v_u_17)
    p_u_13:CreateSound("rbxassetid://8970814778", 1, 0.9, nil, true, 5)
    local v_u_19 = CFrame.new(0, 256, 0)
    local v_u_20 = CFrame.identity
    local _ = v_u_17.Size
    local v_u_21 = tick()
    local v30 = v_u_2.RenderStepped:Connect(function()
        local v22 = (tick() - v_u_21) / 3.15
        local v23 = math.clamp(v22, 0, 1) ^ 2
        local v24 = (tick() - (v_u_21 + 3.15)) / 4
        local _ = math.clamp(v24, 0, 1) ^ 2
        local v25 = v_u_16 and v_u_16.Position or v_u_14.Position
        local v26 = CFrame.new(v25) * v_u_19:Lerp(v_u_20, v23)
        local v27 = v_u_17.Size.X / 2
        local v28 = v26 + Vector3.new(0, v27, 0)
        local v29 = CFrame.new(v28.Position * Vector3.new(1, 0, 1), workspace.CurrentCamera.CFrame.Position * Vector3.new(1, 0, 1))
        v_u_17:PivotTo(v28 * (v29.LookVector == v29.LookVector and v29.Rotation or CFrame.identity) * v_u_6)
    end)
    local v31 = p_u_13._connections
    table.insert(v31, v30)
    wait(3.15)
    p_u_13:CreateSound("rbxassetid://105824621418784", 1.25, 1, nil, true, 5)
    p_u_13:CreateSound("rbxassetid://89635888410432", 1.25, 1, nil, true, 5)
    local v32 = Instance.new("Camera")
    v_u_16 = script.Flattened:Clone()
    v_u_16.CFrame = CFrame.new(v_u_14.Position)
    v_u_16.Parent = workspace
    local v33 = p_u_13._destroy_these
    local v34 = v_u_16
    table.insert(v33, v34)
    local v35 = v_u_16
    for _, v36 in pairs(v_u_16:GetDescendants()) do
        if v36:IsA("ParticleEmitter") then
            v_u_5:ScaleParticleEmitter(v36, 3)
        end
    end
    v_u_5:PlayParticles(v35)
    local v37 = v35.SurfaceGui
    v37.ViewportFrame.CurrentCamera = v32
    v37.Adornee = v35
    v37.Parent = v_u_3.LocalPlayer.PlayerGui
    local v38 = p_u_13._destroy_these
    table.insert(v38, v37)
    local v39 = p_u_13._is_humanoid and p_u_13._subject.Parent or p_u_13._subject
    v39.Archivable = true
    local v40 = v39:Clone()
    v40:PivotTo(v40:GetPivot().Rotation)
    v40.Parent = v37.ViewportFrame
    v32.CFrame = CFrame.new(Vector3.new(0, 15, 0), Vector3.new(0, 0, 0)) * CFrame.Angles(0, 0, 3.141592653589793)
    v32.FieldOfView = 30
    v32.Parent = v37.ViewportFrame
    for _, v41 in pairs(v39:GetDescendants()) do
        if v41:IsA("BasePart") then
            v41.Transparency = 1
        elseif v41:IsA("ParticleEmitter") or (v41:IsA("Beam") or (v41:IsA("Trail") or v41:IsA("Decal"))) then
            v41:Destroy()
        end
    end
    wait(2)
    v35.CanCollide = false
    wait(2)
    v30:Disconnect()
    v_u_17:Destroy()
end
function v_u_7._Init(_) end
return v_u_7